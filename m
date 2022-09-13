Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B82D5B7026
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 16:24:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233231AbiIMOUb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 10:20:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233543AbiIMOTS (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 10:19:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD22965243;
        Tue, 13 Sep 2022 07:14:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9D0A8614C2;
        Tue, 13 Sep 2022 14:14:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DE6AC433C1;
        Tue, 13 Sep 2022 14:14:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663078441;
        bh=bTOIqGHcoGMJCze9crysSPTuC4OBpIBJRzrBeSjJLpQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PuZ5B5+tXK9VUpBe6n3G5qJr77qJbMCUwbRi0xc2W5PA98vzpH84nJuskmsgJiZAg
         CFIKHZHoBlGf1dSp7u/hmXa4nI4VF2Zp68ftd/ttOR9UnipuF+1glA/GmcG4aVq8x8
         MaUi6bU9izU4n6CwL0UjfyNyRVPGXfFZ1xNzGa4k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sindhu-Devale <sindhu.devale@intel.com>,
        Shiraz Saleem <shiraz.saleem@intel.com>,
        Leon Romanovsky <leon@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 141/192] RDMA/irdma: Return error on MR deregister CQP failure
Date:   Tue, 13 Sep 2022 16:04:07 +0200
Message-Id: <20220913140417.043917520@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220913140410.043243217@linuxfoundation.org>
References: <20220913140410.043243217@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sindhu-Devale <sindhu.devale@intel.com>

[ Upstream commit 6b227bd32db778eddc6f3b22cc72a28dda0f2272 ]

The MR deregister CQP can fail if an MW is bound to it.
Return an appropriate error for this case.

Fixes: b48c24c2d710 ("RDMA/irdma: Implement device supported verb APIs")
Signed-off-by: Sindhu-Devale <sindhu.devale@intel.com>
Signed-off-by: Shiraz Saleem <shiraz.saleem@intel.com>
Link: https://lore.kernel.org/r/20220906223244.1119-3-shiraz.saleem@intel.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/irdma/utils.c | 13 ++++++++-----
 drivers/infiniband/hw/irdma/verbs.c |  6 +++++-
 2 files changed, 13 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/hw/irdma/utils.c b/drivers/infiniband/hw/irdma/utils.c
index 7b15faadfef5c..f4d774451160d 100644
--- a/drivers/infiniband/hw/irdma/utils.c
+++ b/drivers/infiniband/hw/irdma/utils.c
@@ -590,11 +590,14 @@ static int irdma_wait_event(struct irdma_pci_f *rf,
 	cqp_error = cqp_request->compl_info.error;
 	if (cqp_error) {
 		err_code = -EIO;
-		if (cqp_request->compl_info.maj_err_code == 0xFFFF &&
-		    cqp_request->compl_info.min_err_code == 0x8029) {
-			if (!rf->reset) {
-				rf->reset = true;
-				rf->gen_ops.request_reset(rf);
+		if (cqp_request->compl_info.maj_err_code == 0xFFFF) {
+			if (cqp_request->compl_info.min_err_code == 0x8002)
+				err_code = -EBUSY;
+			else if (cqp_request->compl_info.min_err_code == 0x8029) {
+				if (!rf->reset) {
+					rf->reset = true;
+					rf->gen_ops.request_reset(rf);
+				}
 			}
 		}
 	}
diff --git a/drivers/infiniband/hw/irdma/verbs.c b/drivers/infiniband/hw/irdma/verbs.c
index 4835702871677..e7120d7a5b4c6 100644
--- a/drivers/infiniband/hw/irdma/verbs.c
+++ b/drivers/infiniband/hw/irdma/verbs.c
@@ -3001,6 +3001,7 @@ static int irdma_dereg_mr(struct ib_mr *ib_mr, struct ib_udata *udata)
 	struct irdma_pble_alloc *palloc = &iwpbl->pble_alloc;
 	struct irdma_cqp_request *cqp_request;
 	struct cqp_cmds_info *cqp_info;
+	int status;
 
 	if (iwmr->type != IRDMA_MEMREG_TYPE_MEM) {
 		if (iwmr->region) {
@@ -3031,8 +3032,11 @@ static int irdma_dereg_mr(struct ib_mr *ib_mr, struct ib_udata *udata)
 	cqp_info->post_sq = 1;
 	cqp_info->in.u.dealloc_stag.dev = &iwdev->rf->sc_dev;
 	cqp_info->in.u.dealloc_stag.scratch = (uintptr_t)cqp_request;
-	irdma_handle_cqp_op(iwdev->rf, cqp_request);
+	status = irdma_handle_cqp_op(iwdev->rf, cqp_request);
 	irdma_put_cqp_request(&iwdev->rf->cqp, cqp_request);
+	if (status)
+		return status;
+
 	irdma_free_stag(iwdev, iwmr->stag);
 done:
 	if (iwpbl->pbl_allocated)
-- 
2.35.1



