Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1DA1283B7B
	for <lists+stable@lfdr.de>; Mon,  5 Oct 2020 17:42:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728504AbgJEPmc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Oct 2020 11:42:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:52882 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727331AbgJEP2E (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Oct 2020 11:28:04 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A556E2074F;
        Mon,  5 Oct 2020 15:28:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601911683;
        bh=zXvlVSrf6VohK+ykQFuPF18aQpHLBBLC/HSdGT2mgiI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b12aRwfz96r41vfFIyew0VnIuG0YRHM4tsT1hLGXKPqgqKTzyKDmt1/lqPaIerJWI
         w9g8nOK6WyYD2lh+l0NiZuz6pA2bW3BNR7nxPNupDuNmiq1pAujf/Xr8k2GpRMMVj8
         PbiHIR8SlcMLO2xDhHgAoTpnBrfKEwOzt+EGu7tE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>
Subject: [PATCH 4.19 36/38] epoll: EPOLL_CTL_ADD: close the race in decision to take fast path
Date:   Mon,  5 Oct 2020 17:26:53 +0200
Message-Id: <20201005142110.413835796@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201005142108.650363140@linuxfoundation.org>
References: <20201005142108.650363140@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Al Viro <viro@zeniv.linux.org.uk>

commit fe0a916c1eae8e17e86c3753d13919177d63ed7e upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/eventpoll.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/eventpoll.c
+++ b/fs/eventpoll.c
@@ -2074,6 +2074,7 @@ SYSCALL_DEFINE4(epoll_ctl, int, epfd, in
 	mutex_lock_nested(&ep->mtx, 0);
 	if (op == EPOLL_CTL_ADD) {
 		if (!list_empty(&f.file->f_ep_links) ||
+				ep->gen == loop_check_gen ||
 						is_file_epoll(tf.file)) {
 			full_check = 1;
 			mutex_unlock(&ep->mtx);


