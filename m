Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F804698609
	for <lists+stable@lfdr.de>; Wed, 15 Feb 2023 21:47:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229982AbjBOUrY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Feb 2023 15:47:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229921AbjBOUq5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Feb 2023 15:46:57 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08F9542DEC;
        Wed, 15 Feb 2023 12:46:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2DF2A61D9A;
        Wed, 15 Feb 2023 20:46:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52358C433A4;
        Wed, 15 Feb 2023 20:46:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676493974;
        bh=kmq5FspM/q0eymI4FU3ewlLpMu0ahiaXI8VvyUXs2IY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Bi847Z51udj2DQ5bJLlLgvD540uxvlxEx2e/pzht1/uo+Fn+tN8F27MtLxZwhvDgb
         DEQeJxMeq6XIKHo6TJDyaaAhFOxuh1OJ9BVAihO+iN/H8trN2CibSJO+m1BfOnlxOj
         JjQL68kW26xSNTJTRW+iJKjZlYFeab+vzXEZ1G72gFchmvm1D1StcK2VbIf07wAmEM
         1EmkRvktkaq7G7eVAsJWahd6h736UNukUJxy9+pP7rKr5Yc3ioE+damI6W8FpVbbne
         zL9Ug2QsidXAJEFWVTi5OrejpBfxMxT6fniapOYXPP8q+OwpUm8DC/9pMxKyvWHM8d
         kNMwMaUF30s9w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dean Luick <dean.luick@cornelisnetworks.com>,
        Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
        Leon Romanovsky <leon@kernel.org>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>, linux-rdma@vger.kernel.org
Subject: [PATCH AUTOSEL 6.1 14/24] IB/hfi1: Assign npages earlier
Date:   Wed, 15 Feb 2023 15:45:37 -0500
Message-Id: <20230215204547.2760761-14-sashal@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230215204547.2760761-1-sashal@kernel.org>
References: <20230215204547.2760761-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dean Luick <dean.luick@cornelisnetworks.com>

[ Upstream commit f9c47b2caa7ffc903ec950b454b59c209afe3182 ]

Improve code clarity and enable earlier use of
tidbuf->npages by moving its assignment to
structure creation time.

Signed-off-by: Dean Luick <dean.luick@cornelisnetworks.com>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>
Link: https://lore.kernel.org/r/167329104884.1472990.4639750192433251493.stgit@awfm-02.cornelisnetworks.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hfi1/user_exp_rcv.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/user_exp_rcv.c b/drivers/infiniband/hw/hfi1/user_exp_rcv.c
index b02f2f0809c81..350884d5f0896 100644
--- a/drivers/infiniband/hw/hfi1/user_exp_rcv.c
+++ b/drivers/infiniband/hw/hfi1/user_exp_rcv.c
@@ -160,16 +160,11 @@ static void unpin_rcv_pages(struct hfi1_filedata *fd,
 static int pin_rcv_pages(struct hfi1_filedata *fd, struct tid_user_buf *tidbuf)
 {
 	int pinned;
-	unsigned int npages;
+	unsigned int npages = tidbuf->npages;
 	unsigned long vaddr = tidbuf->vaddr;
 	struct page **pages = NULL;
 	struct hfi1_devdata *dd = fd->uctxt->dd;
 
-	/* Get the number of pages the user buffer spans */
-	npages = num_user_pages(vaddr, tidbuf->length);
-	if (!npages)
-		return -EINVAL;
-
 	if (npages > fd->uctxt->expected_count) {
 		dd_dev_err(dd, "Expected buffer too big\n");
 		return -EINVAL;
@@ -196,7 +191,6 @@ static int pin_rcv_pages(struct hfi1_filedata *fd, struct tid_user_buf *tidbuf)
 		return pinned;
 	}
 	tidbuf->pages = pages;
-	tidbuf->npages = npages;
 	fd->tid_n_pinned += pinned;
 	return pinned;
 }
@@ -274,6 +268,7 @@ int hfi1_user_exp_rcv_setup(struct hfi1_filedata *fd,
 	mutex_init(&tidbuf->cover_mutex);
 	tidbuf->vaddr = tinfo->vaddr;
 	tidbuf->length = tinfo->length;
+	tidbuf->npages = num_user_pages(tidbuf->vaddr, tidbuf->length);
 	tidbuf->psets = kcalloc(uctxt->expected_count, sizeof(*tidbuf->psets),
 				GFP_KERNEL);
 	if (!tidbuf->psets) {
-- 
2.39.0

