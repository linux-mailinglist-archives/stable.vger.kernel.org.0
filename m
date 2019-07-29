Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8245379978
	for <lists+stable@lfdr.de>; Mon, 29 Jul 2019 22:15:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728350AbfG2T0I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jul 2019 15:26:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:38484 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388324AbfG2T0F (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jul 2019 15:26:05 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3F5B421655;
        Mon, 29 Jul 2019 19:26:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564428364;
        bh=LXsBI1nP7aC1KOGbkxAHfjXu8m/BrtXHKl3pF47vSZY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TRGnuTwS2M2tLFXk3JcbGPcFXygIK3pieEH/CoteqpHGyfHGKj+dgwOJRGxqpM0mt
         ukCaoezLwPQdEHxpzJqsVF0/DW/X/HGfh5H6fPSLfH8rl0W9dicOwGby2OyH9izA9Z
         3NlVWEBXTOq6/+QaHtu3DZwQ0jRt/swvQEOmULDk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        Jan Kara <jack@suse.cz>, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 051/293] blkcg, writeback: dead memcgs shouldnt contribute to writeback ownership arbitration
Date:   Mon, 29 Jul 2019 21:19:02 +0200
Message-Id: <20190729190827.527765441@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190729190820.321094988@linuxfoundation.org>
References: <20190729190820.321094988@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 6631142229005e1b1c311a09efe9fb3cfdac8559 ]

wbc_account_io() collects information on cgroup ownership of writeback
pages to determine which cgroup should own the inode.  Pages can stay
associated with dead memcgs but we want to avoid attributing IOs to
dead blkcgs as much as possible as the association is likely to be
stale.  However, currently, pages associated with dead memcgs
contribute to the accounting delaying and/or confusing the
arbitration.

Fix it by ignoring pages associated with dead memcgs.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Jan Kara <jack@suse.cz>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/fs-writeback.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index 4d561ee08d05..9e8fde348d61 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -721,6 +721,7 @@ void wbc_detach_inode(struct writeback_control *wbc)
 void wbc_account_io(struct writeback_control *wbc, struct page *page,
 		    size_t bytes)
 {
+	struct cgroup_subsys_state *css;
 	int id;
 
 	/*
@@ -732,7 +733,12 @@ void wbc_account_io(struct writeback_control *wbc, struct page *page,
 	if (!wbc->wb)
 		return;
 
-	id = mem_cgroup_css_from_page(page)->id;
+	css = mem_cgroup_css_from_page(page);
+	/* dead cgroups shouldn't contribute to inode ownership arbitration */
+	if (!(css->flags & CSS_ONLINE))
+		return;
+
+	id = css->id;
 
 	if (id == wbc->wb_id) {
 		wbc->wb_bytes += bytes;
-- 
2.20.1



