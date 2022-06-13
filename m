Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 311AD5480BA
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 09:41:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234334AbiFMHjH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 03:39:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230132AbiFMHjF (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 03:39:05 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 379521CB3E
        for <stable@vger.kernel.org>; Mon, 13 Jun 2022 00:39:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E84F0B80D70
        for <stable@vger.kernel.org>; Mon, 13 Jun 2022 07:39:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64338C34114;
        Mon, 13 Jun 2022 07:39:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655105941;
        bh=3WUTw++D7jfUAeZmKeoZ88acXlbwM8L5y0EVpAEe2mE=;
        h=Subject:To:Cc:From:Date:From;
        b=V8BpYSOS/zVJuE2XwfvuR8go1THeh0Uz3lYp/gGi85afKGM9XtCTawBXgkDAt28W+
         0P8yZkQLrXQvVwq4Ue4SbtciEO74WuA4vB9aNS5FsruRObAH0nthAgF8+XVL0LTqX9
         LssAW0XiSfa501GYmGMf1pz8H109aVGcjoVyS/Ek=
Subject: FAILED: patch "[PATCH] drm/amdgpu/jpeg2: Add jpeg vmid update under IB submit" failed to apply to 5.10-stable tree
To:     Mohammadzafar.ziya@amd.com, alexander.deucher@amd.com,
        christian.koenig@amd.com, lijo.lazar@amd.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 13 Jun 2022 09:38:59 +0200
Message-ID: <165510593920050@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 578eb31776df57c81307fb3f96ef0781332c3c7c Mon Sep 17 00:00:00 2001
From: Mohammad Zafar Ziya <Mohammadzafar.ziya@amd.com>
Date: Tue, 7 Jun 2022 11:38:16 +0800
Subject: [PATCH] drm/amdgpu/jpeg2: Add jpeg vmid update under IB submit
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Add jpeg vmid update under IB submit

Signed-off-by: Mohammad Zafar Ziya <Mohammadzafar.ziya@amd.com>
Acked-by: Christian König <christian.koenig@amd.com>
Reviewed-by: Lijo Lazar <lijo.lazar@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org

diff --git a/drivers/gpu/drm/amd/amdgpu/jpeg_v2_0.c b/drivers/gpu/drm/amd/amdgpu/jpeg_v2_0.c
index d2722adabd1b..f3c1af5130ab 100644
--- a/drivers/gpu/drm/amd/amdgpu/jpeg_v2_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/jpeg_v2_0.c
@@ -535,6 +535,10 @@ void jpeg_v2_0_dec_ring_emit_ib(struct amdgpu_ring *ring,
 {
 	unsigned vmid = AMDGPU_JOB_GET_VMID(job);
 
+	amdgpu_ring_write(ring,	PACKETJ(mmUVD_JPEG_IH_CTRL_INTERNAL_OFFSET,
+		0, 0, PACKETJ_TYPE0));
+	amdgpu_ring_write(ring, (vmid << JPEG_IH_CTRL__IH_VMID__SHIFT));
+
 	amdgpu_ring_write(ring, PACKETJ(mmUVD_LMI_JRBC_IB_VMID_INTERNAL_OFFSET,
 		0, 0, PACKETJ_TYPE0));
 	amdgpu_ring_write(ring, (vmid | (vmid << 4)));
@@ -768,7 +772,7 @@ static const struct amdgpu_ring_funcs jpeg_v2_0_dec_ring_vm_funcs = {
 		8 + /* jpeg_v2_0_dec_ring_emit_vm_flush */
 		18 + 18 + /* jpeg_v2_0_dec_ring_emit_fence x2 vm fence */
 		8 + 16,
-	.emit_ib_size = 22, /* jpeg_v2_0_dec_ring_emit_ib */
+	.emit_ib_size = 24, /* jpeg_v2_0_dec_ring_emit_ib */
 	.emit_ib = jpeg_v2_0_dec_ring_emit_ib,
 	.emit_fence = jpeg_v2_0_dec_ring_emit_fence,
 	.emit_vm_flush = jpeg_v2_0_dec_ring_emit_vm_flush,
diff --git a/drivers/gpu/drm/amd/amdgpu/jpeg_v2_0.h b/drivers/gpu/drm/amd/amdgpu/jpeg_v2_0.h
index 1a03baa59755..654e43e83e2c 100644
--- a/drivers/gpu/drm/amd/amdgpu/jpeg_v2_0.h
+++ b/drivers/gpu/drm/amd/amdgpu/jpeg_v2_0.h
@@ -41,6 +41,7 @@
 #define mmUVD_JRBC_RB_REF_DATA_INTERNAL_OFFSET				0x4084
 #define mmUVD_JRBC_STATUS_INTERNAL_OFFSET				0x4089
 #define mmUVD_JPEG_PITCH_INTERNAL_OFFSET				0x401f
+#define mmUVD_JPEG_IH_CTRL_INTERNAL_OFFSET				0x4149
 
 #define JRBC_DEC_EXTERNAL_REG_WRITE_ADDR				0x18000
 

