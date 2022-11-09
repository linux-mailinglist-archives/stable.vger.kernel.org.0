Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9768F622E37
	for <lists+stable@lfdr.de>; Wed,  9 Nov 2022 15:44:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230210AbiKIOoW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Nov 2022 09:44:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231631AbiKIOoV (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Nov 2022 09:44:21 -0500
X-Greylist: delayed 610 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 09 Nov 2022 06:44:19 PST
Received: from mx.swemel.ru (mx.swemel.ru [95.143.211.150])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43CF17651
        for <stable@vger.kernel.org>; Wed,  9 Nov 2022 06:44:19 -0800 (PST)
From:   Denis Arefev <arefev@swemel.ru>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=swemel.ru; s=mail;
        t=1668004445;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=RSUEXu6tzAjomBfevIrbmjFIMAZE8djXJv3/8t7UBsk=;
        b=V/wq6CTxSVtSNu9Vr1lLRfocbxVOoGeTSgpTwg/3WUjEVUOasKJmFw+Uzjq0/vpgNUI1jT
        TTa48uu4rmw/0dwaIEAKGMCnyom/WC//meLp09ykyJGJagWN6XVAlX3fXv7XtIc8+wkm9C
        IeIEzd/hrfPEvsJgm3hbkxh48JSDPmU=
To:     David Airlie <airlied@linux.ie>, Daniel Vetter <daniel@ffwll.ch>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     Alexey Khoroshilov <khoroshilov@ispras.ru>,
        ldv-project@linuxtesting.org, trufanov@swemel.ru, vfh@swemel.ru
Subject: 
Date:   Wed,  9 Nov 2022 17:34:13 +0300
Message-Id: <20221109143413.71896-1-arefev@swemel.ru>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Date: Wed, 9 Nov 2022 16:52:17 +0300
Subject: [PATCH 5.10] nbio_v7_4: Add pointer check

Return value of a function 'amdgpu_ras_find_obj' is dereferenced at nbio_v7_4.c:325 without checking for null

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Signed-off-by: Denis Arefev <arefev@swemel.ru>
---
 drivers/gpu/drm/amd/amdgpu/nbio_v7_4.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/nbio_v7_4.c b/drivers/gpu/drm/amd/amdgpu/nbio_v7_4.c
index eadc9526d33f..d2627a610e48 100644
--- a/drivers/gpu/drm/amd/amdgpu/nbio_v7_4.c
+++ b/drivers/gpu/drm/amd/amdgpu/nbio_v7_4.c
@@ -303,6 +303,9 @@ static void nbio_v7_4_handle_ras_controller_intr_no_bifring(struct amdgpu_device
 	struct ras_manager *obj = amdgpu_ras_find_obj(adev, adev->nbio.ras_if);
 	struct ras_err_data err_data = {0, 0, 0, NULL};
 	struct amdgpu_ras *ras = amdgpu_ras_get_context(adev);

+	if (!obj)
+		return;
 
 	bif_doorbell_intr_cntl = RREG32_SOC15(NBIO, 0, mmBIF_DOORBELL_INT_CNTL);
 	if (REG_GET_FIELD(bif_doorbell_intr_cntl,
-- 
2.25.1

