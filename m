Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AEA5D462535
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 23:33:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232740AbhK2WgS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 17:36:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233594AbhK2Wf0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 17:35:26 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DFC5C1E0FC7;
        Mon, 29 Nov 2021 10:41:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 1310DCE1626;
        Mon, 29 Nov 2021 18:41:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4DF3C53FAD;
        Mon, 29 Nov 2021 18:41:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638211313;
        bh=xmqzAEqeq5OFYODhHCgAuYALbJJ2cvyOSy8z/cS8o9s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ceCrgDcjo+9qLfSc37Xeg6LsOWjant/Drp9F9uTIYnuiQz0XGULP3eZxYMbMTjtmO
         8wOta1F2zuYbjezeIwAz8IOV/cy0EOzG/pTM5XttR3shFBBi3I16HwUwXQ37PW+PxU
         0u3PbXVT6E6wLhB06fuQHVr0T81VJbXldEFI1mUk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Luben Tuikov <luben.tuikov@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.15 178/179] drm/amdgpu/gfx10: add wraparound gpu counter check for APUs as well
Date:   Mon, 29 Nov 2021 19:19:32 +0100
Message-Id: <20211129181724.793284288@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211129181718.913038547@linuxfoundation.org>
References: <20211129181718.913038547@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alex Deucher <alexander.deucher@amd.com>

commit 244ee398855df2adc7d3ac5702b58424a5f684cc upstream.

Apply the same check we do for dGPUs for APUs as well.

Acked-by: Luben Tuikov <luben.tuikov@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c |   15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v10_0.c
@@ -7729,8 +7729,19 @@ static uint64_t gfx_v10_0_get_gpu_clock_
 	switch (adev->asic_type) {
 	case CHIP_VANGOGH:
 	case CHIP_YELLOW_CARP:
-		clock = (uint64_t)RREG32_SOC15(SMUIO, 0, mmGOLDEN_TSC_COUNT_LOWER_Vangogh) |
-			((uint64_t)RREG32_SOC15(SMUIO, 0, mmGOLDEN_TSC_COUNT_UPPER_Vangogh) << 32ULL);
+		preempt_disable();
+		clock_hi = RREG32_SOC15_NO_KIQ(SMUIO, 0, mmGOLDEN_TSC_COUNT_UPPER_Vangogh);
+		clock_lo = RREG32_SOC15_NO_KIQ(SMUIO, 0, mmGOLDEN_TSC_COUNT_LOWER_Vangogh);
+		hi_check = RREG32_SOC15_NO_KIQ(SMUIO, 0, mmGOLDEN_TSC_COUNT_UPPER_Vangogh);
+		/* The SMUIO TSC clock frequency is 100MHz, which sets 32-bit carry over
+		 * roughly every 42 seconds.
+		 */
+		if (hi_check != clock_hi) {
+			clock_lo = RREG32_SOC15_NO_KIQ(SMUIO, 0, mmGOLDEN_TSC_COUNT_LOWER_Vangogh);
+			clock_hi = hi_check;
+		}
+		preempt_enable();
+		clock = clock_lo | (clock_hi << 32ULL);
 		break;
 	default:
 		preempt_disable();


