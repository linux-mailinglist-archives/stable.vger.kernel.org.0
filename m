Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C2B995495E9
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:34:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233663AbiFMOty (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 10:49:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1386022AbiFMOqh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 10:46:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DE32BF8BB;
        Mon, 13 Jun 2022 04:52:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8A091614A0;
        Mon, 13 Jun 2022 11:52:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A4C5C34114;
        Mon, 13 Jun 2022 11:52:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655121138;
        bh=i5fKpp80z6wDEA2rNJ1KQb7U1RDqRijDRcCP4XwkONk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GpmBsNz2e1D481fPmSRZuxxD3fyD4+bZQx/4jokp+ZgYeJXYQKpz2bXWP/3yh+ngI
         nFx4aucT0Yv8yywrzoUM6t/8h47SDc6abQf2Mq/21XByhrL18X3kteIL06LhtTNNIz
         JTKkRLcQ5HW2JCddspY+7huWf+AYMDIKskPOjWm0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Mohammad Zafar Ziya <Mohammadzafar.ziya@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Lijo Lazar <lijo.lazar@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.17 286/298] drm/amdgpu/jpeg2: Add jpeg vmid update under IB submit
Date:   Mon, 13 Jun 2022 12:13:00 +0200
Message-Id: <20220613094933.754913324@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094924.913340374@linuxfoundation.org>
References: <20220613094924.913340374@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Mohammad Zafar Ziya <Mohammadzafar.ziya@amd.com>

commit 578eb31776df57c81307fb3f96ef0781332c3c7c upstream.

Add jpeg vmid update under IB submit

Signed-off-by: Mohammad Zafar Ziya <Mohammadzafar.ziya@amd.com>
Acked-by: Christian König <christian.koenig@amd.com>
Reviewed-by: Lijo Lazar <lijo.lazar@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/jpeg_v2_0.c |    6 +++++-
 drivers/gpu/drm/amd/amdgpu/jpeg_v2_0.h |    1 +
 2 files changed, 6 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/amdgpu/jpeg_v2_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/jpeg_v2_0.c
@@ -535,6 +535,10 @@ void jpeg_v2_0_dec_ring_emit_ib(struct a
 {
 	unsigned vmid = AMDGPU_JOB_GET_VMID(job);
 
+	amdgpu_ring_write(ring,	PACKETJ(mmUVD_JPEG_IH_CTRL_INTERNAL_OFFSET,
+		0, 0, PACKETJ_TYPE0));
+	amdgpu_ring_write(ring, (vmid << JPEG_IH_CTRL__IH_VMID__SHIFT));
+
 	amdgpu_ring_write(ring, PACKETJ(mmUVD_LMI_JRBC_IB_VMID_INTERNAL_OFFSET,
 		0, 0, PACKETJ_TYPE0));
 	amdgpu_ring_write(ring, (vmid | (vmid << 4)));
@@ -768,7 +772,7 @@ static const struct amdgpu_ring_funcs jp
 		8 + /* jpeg_v2_0_dec_ring_emit_vm_flush */
 		18 + 18 + /* jpeg_v2_0_dec_ring_emit_fence x2 vm fence */
 		8 + 16,
-	.emit_ib_size = 22, /* jpeg_v2_0_dec_ring_emit_ib */
+	.emit_ib_size = 24, /* jpeg_v2_0_dec_ring_emit_ib */
 	.emit_ib = jpeg_v2_0_dec_ring_emit_ib,
 	.emit_fence = jpeg_v2_0_dec_ring_emit_fence,
 	.emit_vm_flush = jpeg_v2_0_dec_ring_emit_vm_flush,
--- a/drivers/gpu/drm/amd/amdgpu/jpeg_v2_0.h
+++ b/drivers/gpu/drm/amd/amdgpu/jpeg_v2_0.h
@@ -41,6 +41,7 @@
 #define mmUVD_JRBC_RB_REF_DATA_INTERNAL_OFFSET				0x4084
 #define mmUVD_JRBC_STATUS_INTERNAL_OFFSET				0x4089
 #define mmUVD_JPEG_PITCH_INTERNAL_OFFSET				0x401f
+#define mmUVD_JPEG_IH_CTRL_INTERNAL_OFFSET				0x4149
 
 #define JRBC_DEC_EXTERNAL_REG_WRITE_ADDR				0x18000
 


