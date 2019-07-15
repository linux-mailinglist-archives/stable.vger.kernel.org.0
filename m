Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C2A4D69545
	for <lists+stable@lfdr.de>; Mon, 15 Jul 2019 16:58:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390589AbfGOOWU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Jul 2019 10:22:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:49754 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390274AbfGOOWT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Jul 2019 10:22:19 -0400
Received: from sasha-vm.mshome.net (unknown [73.61.17.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A72BA21537;
        Mon, 15 Jul 2019 14:22:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563200538;
        bh=UZazOLY4xLkk2qBr8+dsHkB/Jc4iCiMRLqDD81r72bM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TcwtL/YqCHC9B2ikeXDnr/8LSLHM6tCPPSJj+DGH92G9x7BM3FrYjHsD3o86jdXMk
         BvLMphCUHZT/91vAJp18jnIwwSpU21v73ivjntZ/O7DqtYi28OS5ycehVoJU3vB9WN
         6M+q+wmFGPaFMnNTm4RSC09W4FuMYahQwvGdqkWg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tejun Heo <tj@kernel.org>, Jan Kara <jack@suse.cz>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>,
        linux-fsdevel@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 072/158] blkcg, writeback: dead memcgs shouldn't contribute to writeback ownership arbitration
Date:   Mon, 15 Jul 2019 10:16:43 -0400
Message-Id: <20190715141809.8445-72-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190715141809.8445-1-sashal@kernel.org>
References: <20190715141809.8445-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tejun Heo <tj@kernel.org>

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
index 9544e2f8b79f..7ee86d8f313d 100644
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

