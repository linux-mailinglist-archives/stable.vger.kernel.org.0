Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9DADD680FA9
	for <lists+stable@lfdr.de>; Mon, 30 Jan 2023 14:55:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236503AbjA3Nzy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Jan 2023 08:55:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236501AbjA3Nzu (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Jan 2023 08:55:50 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 120A339BA6
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 05:55:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A251F61017
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 13:55:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E1E8C433EF;
        Mon, 30 Jan 2023 13:55:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675086941;
        bh=ayTkJWif331Yo34G6gJNX6kt9BGO8zBlSKHWCPk6J54=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZpHu5/dxi+wWmqBk/MCpoUw3WFmLN6QQ2R9PLUfdnfvtV24Ez6rRQZoSOqhp03Vap
         4U74oSfjha6mxrG3xj8oUpdypPWVkIWYyaD2HQCRhrzeH4h1jGHhgzht5dyNuXVVm1
         H/h4oHrLD0Nl1aD2vNBEKvcYWmAMaYbRwY1Bph3Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Dean Luick <dean.luick@cornelisnetworks.com>,
        Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
        Leon Romanovsky <leon@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 047/313] IB/hfi1: Reserve user expected TIDs
Date:   Mon, 30 Jan 2023 14:48:02 +0100
Message-Id: <20230130134338.882581134@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134336.532886729@linuxfoundation.org>
References: <20230130134336.532886729@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

[ Upstream commit ecf91551cdd2925ed6d9a9d99074fa5f67b90596 ]

To avoid a race, reserve the number of user expected
TIDs before setup.

Fixes: 7e7a436ecb6e ("staging/hfi1: Add TID entry program function body")
Signed-off-by: Dean Luick <dean.luick@cornelisnetworks.com>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>
Link: https://lore.kernel.org/r/167328547636.1472310.7419712824785353905.stgit@awfm-02.cornelisnetworks.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hfi1/user_exp_rcv.c | 14 ++++++--------
 1 file changed, 6 insertions(+), 8 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/user_exp_rcv.c b/drivers/infiniband/hw/hfi1/user_exp_rcv.c
index 3c609b11e71c..d7487555d109 100644
--- a/drivers/infiniband/hw/hfi1/user_exp_rcv.c
+++ b/drivers/infiniband/hw/hfi1/user_exp_rcv.c
@@ -282,16 +282,13 @@ int hfi1_user_exp_rcv_setup(struct hfi1_filedata *fd,
 	/* Find sets of physically contiguous pages */
 	tidbuf->n_psets = find_phys_blocks(tidbuf, pinned);
 
-	/*
-	 * We don't need to access this under a lock since tid_used is per
-	 * process and the same process cannot be in hfi1_user_exp_rcv_clear()
-	 * and hfi1_user_exp_rcv_setup() at the same time.
-	 */
+	/* Reserve the number of expected tids to be used. */
 	spin_lock(&fd->tid_lock);
 	if (fd->tid_used + tidbuf->n_psets > fd->tid_limit)
 		pageset_count = fd->tid_limit - fd->tid_used;
 	else
 		pageset_count = tidbuf->n_psets;
+	fd->tid_used += pageset_count;
 	spin_unlock(&fd->tid_lock);
 
 	if (!pageset_count)
@@ -400,10 +397,11 @@ int hfi1_user_exp_rcv_setup(struct hfi1_filedata *fd,
 nomem:
 	hfi1_cdbg(TID, "total mapped: tidpairs:%u pages:%u (%d)", tididx,
 		  mapped_pages, ret);
+	/* adjust reserved tid_used to actual count */
+	spin_lock(&fd->tid_lock);
+	fd->tid_used -= pageset_count - tididx;
+	spin_unlock(&fd->tid_lock);
 	if (tididx) {
-		spin_lock(&fd->tid_lock);
-		fd->tid_used += tididx;
-		spin_unlock(&fd->tid_lock);
 		tinfo->tidcnt = tididx;
 		tinfo->length = mapped_pages * PAGE_SIZE;
 
-- 
2.39.0



