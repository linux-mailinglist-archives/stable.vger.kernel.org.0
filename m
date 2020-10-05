Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E72228382B
	for <lists+stable@lfdr.de>; Mon,  5 Oct 2020 16:45:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726595AbgJEOpJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Oct 2020 10:45:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:51830 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726530AbgJEOpF (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Oct 2020 10:45:05 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 72FE62085B;
        Mon,  5 Oct 2020 14:45:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601909105;
        bh=At7ky3ZfpiTAObD9dz3UtrspXXMAGjzscC1SuKNflTk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tpqTPrze5P0I0eWOsCVPgMbsOzR2kQ1FmFnYmAARniJnNVt1dA3Sgc+jRwCuPJmue
         JjCzmRd+ZR1/ArEeNYviiiT9amV62dDpvpnp681LbbvRNx8UzRzDBtCs2ZnhR5dIEa
         tK9pJlPKplyidbBf6qBNqZMAmsXp2nGEucOJfSX4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Al Viro <viro@zeniv.linux.org.uk>, Sasha Levin <sashal@kernel.org>,
        linux-fsdevel@vger.kernel.org
Subject: [PATCH AUTOSEL 5.8 03/12] epoll: EPOLL_CTL_ADD: close the race in decision to take fast path
Date:   Mon,  5 Oct 2020 10:44:51 -0400
Message-Id: <20201005144501.2527477-3-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201005144501.2527477-1-sashal@kernel.org>
References: <20201005144501.2527477-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Al Viro <viro@zeniv.linux.org.uk>

[ Upstream commit fe0a916c1eae8e17e86c3753d13919177d63ed7e ]

Checking for the lack of epitems refering to the epoll we want to insert into
is not enough; we might have an insertion of that epoll into another one that
has already collected the set of files to recheck for excessive reverse paths,
but hasn't gotten to creating/inserting the epitem for it.

However, any such insertion in progress can be detected - it will update the
generation count in our epoll when it's done looking through it for files
to check.  That gets done under ->mtx of our epoll and that allows us to
detect that safely.

We are *not* holding epmutex here, so the generation count is not stable.
However, since both the update of ep->gen by loop check and (later)
insertion into ->f_ep_link are done with ep->mtx held, we are fine -
the sequence is
	grab epmutex
	bump loop_check_gen
	...
	grab tep->mtx		// 1
	tep->gen = loop_check_gen
	...
	drop tep->mtx		// 2
	...
	grab tep->mtx		// 3
	...
	insert into ->f_ep_link
	...
	drop tep->mtx		// 4
	bump loop_check_gen
	drop epmutex
and if the fastpath check in another thread happens for that
eventpoll, it can come
	* before (1) - in that case fastpath is just fine
	* after (4) - we'll see non-empty ->f_ep_link, slow path
taken
	* between (2) and (3) - loop_check_gen is stable,
with ->mtx providing barriers and we end up taking slow path.

Note that ->f_ep_link emptiness check is slightly racy - we are protected
against insertions into that list, but removals can happen right under us.
Not a problem - in the worst case we'll end up taking a slow path for
no good reason.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/eventpoll.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/eventpoll.c b/fs/eventpoll.c
index 82ab9a25f12f2..16313180e4c16 100644
--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -2181,6 +2181,7 @@ int do_epoll_ctl(int epfd, int op, int fd, struct epoll_event *epds,
 		goto error_tgt_fput;
 	if (op == EPOLL_CTL_ADD) {
 		if (!list_empty(&f.file->f_ep_links) ||
+				ep->gen == loop_check_gen ||
 						is_file_epoll(tf.file)) {
 			mutex_unlock(&ep->mtx);
 			error = epoll_mutex_lock(&epmutex, 0, nonblock);
-- 
2.25.1

