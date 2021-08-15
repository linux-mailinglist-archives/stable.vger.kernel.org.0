Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0EC7E3EC920
	for <lists+stable@lfdr.de>; Sun, 15 Aug 2021 14:44:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235540AbhHOMop (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 15 Aug 2021 08:44:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:47198 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231809AbhHOMop (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 15 Aug 2021 08:44:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4309C61152;
        Sun, 15 Aug 2021 12:44:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1629031455;
        bh=tJ03xcUW3S13cxKZtKLQoLzKPo3h++z7i2dulcH2FHg=;
        h=Subject:To:Cc:From:Date:From;
        b=oi9kl7Wv4IyFLz4nyEwZAkk1Bu0o86zE7IBxDXr7OUXWAzbC8OjYRJmz8Xr57hhtn
         bYZn15QBAGhc12QYWMIFcJbBr1dCmrRUkPOhxLBWvx7kkt1qPv8ngaP+lgbV3Qp1FA
         gU9InNX9hZhQABjtF9jpzHm+Tq3WkJ9yz43jn23E=
Subject: FAILED: patch "[PATCH] drm/amd/pm: bug fix for the runtime pm BACO" failed to apply to 5.13-stable tree
To:     kenneth.feng@amd.com, Jack.Gui@amd.com, alexander.deucher@amd.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 15 Aug 2021 14:44:05 +0200
Message-ID: <1629031445111199@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.13-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 3042f80c6cb9340354dc56ecb06473be57adc432 Mon Sep 17 00:00:00 2001
From: Kenneth Feng <kenneth.feng@amd.com>
Date: Fri, 6 Aug 2021 10:28:04 +0800
Subject: [PATCH] drm/amd/pm: bug fix for the runtime pm BACO

In some systems only MACO is supported. This is to fix the problem
that runtime pm is enabled but BACO is not supported. MACO will be
handled seperately.

Signed-off-by: Kenneth Feng <kenneth.feng@amd.com>
Reviewed-by: Jack Gui <Jack.Gui@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org

diff --git a/drivers/gpu/drm/amd/pm/swsmu/smu11/sienna_cichlid_ppt.c b/drivers/gpu/drm/amd/pm/swsmu/smu11/sienna_cichlid_ppt.c
index c751f717a0da..d92dd2c7448e 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/smu11/sienna_cichlid_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu11/sienna_cichlid_ppt.c
@@ -353,8 +353,7 @@ static void sienna_cichlid_check_bxco_support(struct smu_context *smu)
 	struct amdgpu_device *adev = smu->adev;
 	uint32_t val;
 
-	if (powerplay_table->platform_caps & SMU_11_0_7_PP_PLATFORM_CAP_BACO ||
-	    powerplay_table->platform_caps & SMU_11_0_7_PP_PLATFORM_CAP_MACO) {
+	if (powerplay_table->platform_caps & SMU_11_0_7_PP_PLATFORM_CAP_BACO) {
 		val = RREG32_SOC15(NBIO, 0, mmRCC_BIF_STRAP0);
 		smu_baco->platform_support =
 			(val & RCC_BIF_STRAP0__STRAP_PX_CAPABLE_MASK) ? true :

