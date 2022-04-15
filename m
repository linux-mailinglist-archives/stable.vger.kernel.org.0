Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EFBE9502855
	for <lists+stable@lfdr.de>; Fri, 15 Apr 2022 12:32:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352323AbiDOKfN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Apr 2022 06:35:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352311AbiDOKfM (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 15 Apr 2022 06:35:12 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD8F015FCC
        for <stable@vger.kernel.org>; Fri, 15 Apr 2022 03:32:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 93183B82DEA
        for <stable@vger.kernel.org>; Fri, 15 Apr 2022 10:32:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4E47C385A5;
        Fri, 15 Apr 2022 10:32:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650018762;
        bh=NTkvGiUfrqpfEdLjN4IfQTg9fJS7UJ56Q3q0RFyUX8E=;
        h=Subject:To:Cc:From:Date:From;
        b=zvtyRzh7UzMVvswbCdxqEPokM7b86cecK4So/Qy07pNulw1YbZHrF0AkT5oab7c+M
         YLCPy3vmM2gMhHG2tin2AeMsg2lJGSschVs7KXEQ4uW1byOvyUmYZUziAsgQQr4mzJ
         Ek+FTku3TtVUMLH38otHpIzISM8mFKQrD2wzw5Fc=
Subject: FAILED: patch "[PATCH] drm/amdgpu: Ensure HDA function is suspended before ASIC" failed to apply to 5.15-stable tree
To:     kai.heng.feng@canonical.com, alexander.deucher@amd.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 15 Apr 2022 12:32:39 +0200
Message-ID: <165001875966231@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
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


The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 887f75cfd0da44c19dda93b2ff9e70ca8792cdc1 Mon Sep 17 00:00:00 2001
From: Kai-Heng Feng <kai.heng.feng@canonical.com>
Date: Thu, 7 Apr 2022 20:12:28 +0800
Subject: [PATCH] drm/amdgpu: Ensure HDA function is suspended before ASIC
 reset

DP/HDMI audio on AMD PRO VII stops working after S3:
[  149.450391] amdgpu 0000:63:00.0: amdgpu: MODE1 reset
[  149.450395] amdgpu 0000:63:00.0: amdgpu: GPU mode1 reset
[  149.450494] amdgpu 0000:63:00.0: amdgpu: GPU psp mode1 reset
[  149.983693] snd_hda_intel 0000:63:00.1: refused to change power state from D0 to D3hot
[  150.003439] amdgpu 0000:63:00.0: refused to change power state from D0 to D3hot
...
[  155.432975] snd_hda_intel 0000:63:00.1: CORB reset timeout#2, CORBRP = 65535

The offending commit is daf8de0874ab5b ("drm/amdgpu: always reset the asic in
suspend (v2)"). Commit 34452ac3038a7 ("drm/amdgpu: don't use BACO for
reset in S3 ") doesn't help, so the issue is something different.

Assuming that to make HDA resume to D0 fully realized, it needs to be
successfully put to D3 first. And this guesswork proves working, by
moving amdgpu_asic_reset() to noirq callback, so it's called after HDA
function is in D3.

Fixes: daf8de0874ab5b ("drm/amdgpu: always reset the asic in suspend (v2)")
Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
index b03663f42cc9..29e9419a914b 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
@@ -2323,18 +2323,23 @@ static int amdgpu_pmops_suspend(struct device *dev)
 {
 	struct drm_device *drm_dev = dev_get_drvdata(dev);
 	struct amdgpu_device *adev = drm_to_adev(drm_dev);
-	int r;
 
 	if (amdgpu_acpi_is_s0ix_active(adev))
 		adev->in_s0ix = true;
 	else
 		adev->in_s3 = true;
-	r = amdgpu_device_suspend(drm_dev, true);
-	if (r)
-		return r;
+	return amdgpu_device_suspend(drm_dev, true);
+}
+
+static int amdgpu_pmops_suspend_noirq(struct device *dev)
+{
+	struct drm_device *drm_dev = dev_get_drvdata(dev);
+	struct amdgpu_device *adev = drm_to_adev(drm_dev);
+
 	if (!adev->in_s0ix)
-		r = amdgpu_asic_reset(adev);
-	return r;
+		return amdgpu_asic_reset(adev);
+
+	return 0;
 }
 
 static int amdgpu_pmops_resume(struct device *dev)
@@ -2575,6 +2580,7 @@ static const struct dev_pm_ops amdgpu_pm_ops = {
 	.prepare = amdgpu_pmops_prepare,
 	.complete = amdgpu_pmops_complete,
 	.suspend = amdgpu_pmops_suspend,
+	.suspend_noirq = amdgpu_pmops_suspend_noirq,
 	.resume = amdgpu_pmops_resume,
 	.freeze = amdgpu_pmops_freeze,
 	.thaw = amdgpu_pmops_thaw,

