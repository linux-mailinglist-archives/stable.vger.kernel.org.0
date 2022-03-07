Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 512A74CF6A0
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 10:41:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237466AbiCGJm2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 04:42:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241056AbiCGJls (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 04:41:48 -0500
Received: from www.linuxtv.org (www.linuxtv.org [130.149.80.248])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78BFF6D940
        for <stable@vger.kernel.org>; Mon,  7 Mar 2022 01:39:42 -0800 (PST)
Received: from mchehab by www.linuxtv.org with local (Exim 4.92)
        (envelope-from <mchehab@linuxtv.org>)
        id 1nR9q8-00BwHA-7j; Mon, 07 Mar 2022 09:39:40 +0000
From:   Mauro Carvalho Chehab <mchehab@kernel.org>
Date:   Mon, 07 Mar 2022 09:34:52 +0000
Subject: [git:media_stage/master] media: venus: vdec: fixed possible memory leak issue
To:     linuxtv-commits@linuxtv.org
Cc:     Ameer Hamza <amhamza.mgc@gmail.com>,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        stable@vger.kernel.org,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>
Mail-followup-to: linux-media@vger.kernel.org
Forward-to: linux-media@vger.kernel.org
Reply-to: linux-media@vger.kernel.org
Message-Id: <E1nR9q8-00BwHA-7j@www.linuxtv.org>
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is an automatic generated email to let you know that the following patch were queued:

Subject: media: venus: vdec: fixed possible memory leak issue
Author:  Ameer Hamza <amhamza.mgc@gmail.com>
Date:    Mon Dec 6 11:43:15 2021 +0100

The venus_helper_alloc_dpb_bufs() implementation allows an early return
on an error path when checking the id from ida_alloc_min() which would
not release the earlier buffer allocation.

Move the direct kfree() from the error checking of dma_alloc_attrs() to
the common fail path to ensure that allocations are released on all
error paths in this function.

Addresses-Coverity: 1494120 ("Resource leak")

cc: stable@vger.kernel.org # 5.16+
Fixes: 40d87aafee29 ("media: venus: vdec: decoded picture buffer handling during reconfig sequence")
Signed-off-by: Ameer Hamza <amhamza.mgc@gmail.com>
Reviewed-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Signed-off-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>

 drivers/media/platform/qcom/venus/helpers.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

---

diff --git a/drivers/media/platform/qcom/venus/helpers.c b/drivers/media/platform/qcom/venus/helpers.c
index 84c3a511ec31..0bca95d01650 100644
--- a/drivers/media/platform/qcom/venus/helpers.c
+++ b/drivers/media/platform/qcom/venus/helpers.c
@@ -189,7 +189,6 @@ int venus_helper_alloc_dpb_bufs(struct venus_inst *inst)
 		buf->va = dma_alloc_attrs(dev, buf->size, &buf->da, GFP_KERNEL,
 					  buf->attrs);
 		if (!buf->va) {
-			kfree(buf);
 			ret = -ENOMEM;
 			goto fail;
 		}
@@ -209,6 +208,7 @@ int venus_helper_alloc_dpb_bufs(struct venus_inst *inst)
 	return 0;
 
 fail:
+	kfree(buf);
 	venus_helper_free_dpb_bufs(inst);
 	return ret;
 }
