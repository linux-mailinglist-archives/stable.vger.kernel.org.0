Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E79F14CF752
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 10:44:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238296AbiCGJpf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 04:45:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241139AbiCGJlz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 04:41:55 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E06192DDA;
        Mon,  7 Mar 2022 01:40:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 4C995CE0EAA;
        Mon,  7 Mar 2022 09:40:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 096F2C340E9;
        Mon,  7 Mar 2022 09:40:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646646040;
        bh=nRMkltgKgdbuMr9XsmL+FvkFhQmImYJklYWMTfuJkEE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qIFohVh5zglX7NqyymdpzGXLSW5aBr36F26GP+s8p70MIyhmbZLfuElpr4pZElB9E
         tlHCCq/ohncNrs32YeTFbI1zAlfNxHl/4xE0KyluokrjkpQiZgRtpyEdINF3inhDkE
         GxLvnyqf5C1YuiAu9a8+xx3GslCOsouU9aJzR2fk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guchun Chen <guchun.chen@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Kelly Zytaruk <kelly.zytaruk@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 087/262] drm/amdgpu: use spin_lock_irqsave to avoid deadlock by local interrupt
Date:   Mon,  7 Mar 2022 10:17:11 +0100
Message-Id: <20220307091704.936659224@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220307091702.378509770@linuxfoundation.org>
References: <20220307091702.378509770@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Guchun Chen <guchun.chen@amd.com>

[ Upstream commit 2096b74b1da5ca418827b54ac4904493bd9de89c ]

This is observed in SRIOV case with virtual KMS as display.

_raw_spin_lock_irqsave+0x37/0x40
drm_handle_vblank+0x69/0x350 [drm]
? try_to_wake_up+0x432/0x5c0
? amdgpu_vkms_prepare_fb+0x1c0/0x1c0 [amdgpu]
drm_crtc_handle_vblank+0x17/0x20 [drm]
amdgpu_vkms_vblank_simulate+0x4d/0x80 [amdgpu]
__hrtimer_run_queues+0xfb/0x230
hrtimer_interrupt+0x109/0x220
__sysvec_apic_timer_interrupt+0x64/0xe0
asm_call_irq_on_stack+0x12/0x20

Fixes: 84ec374bd580 ("drm/amdgpu: create amdgpu_vkms (v4)")
Signed-off-by: Guchun Chen <guchun.chen@amd.com>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Tested-by: Kelly Zytaruk <kelly.zytaruk@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_vkms.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_vkms.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_vkms.c
index ac9a8cd21c4b6..7d58bf410be05 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_vkms.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_vkms.c
@@ -142,15 +142,16 @@ static void amdgpu_vkms_crtc_atomic_disable(struct drm_crtc *crtc,
 static void amdgpu_vkms_crtc_atomic_flush(struct drm_crtc *crtc,
 					  struct drm_atomic_state *state)
 {
+	unsigned long flags;
 	if (crtc->state->event) {
-		spin_lock(&crtc->dev->event_lock);
+		spin_lock_irqsave(&crtc->dev->event_lock, flags);
 
 		if (drm_crtc_vblank_get(crtc) != 0)
 			drm_crtc_send_vblank_event(crtc, crtc->state->event);
 		else
 			drm_crtc_arm_vblank_event(crtc, crtc->state->event);
 
-		spin_unlock(&crtc->dev->event_lock);
+		spin_unlock_irqrestore(&crtc->dev->event_lock, flags);
 
 		crtc->state->event = NULL;
 	}
-- 
2.34.1



