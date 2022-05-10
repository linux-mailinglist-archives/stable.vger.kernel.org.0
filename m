Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C44EB5219C8
	for <lists+stable@lfdr.de>; Tue, 10 May 2022 15:48:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244770AbiEJNvQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 May 2022 09:51:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245048AbiEJNrN (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 May 2022 09:47:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A58BF4AE3C;
        Tue, 10 May 2022 06:34:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 41228615C8;
        Tue, 10 May 2022 13:34:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DF9CC385C2;
        Tue, 10 May 2022 13:34:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652189660;
        bh=otcH+6sO+IxaIG0a9dFoxjZ2jbpyQeB2t/jagiK3euc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eVzM3XOXP6lkej+8D6Nz2fYp8MFve+CyYWnx8EuEcESZPuNvxFtGZg3oi646bQj5U
         nosbun9Mk+i4y652OTEIg3OA5lxo2xaEoIzh3npmttC2AvpQFwtpj+Ho/As9dUi+/k
         DMXLPYHisxFwo5yMOapr22VcrvRTavtINh2R/zQA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        "Limonciello, Mario" <Mario.Limonciello@amd.com>
Subject: [PATCH 5.15 085/135] drm/amdgpu: Ensure HDA function is suspended before ASIC reset
Date:   Tue, 10 May 2022 15:07:47 +0200
Message-Id: <20220510130742.850433789@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220510130740.392653815@linuxfoundation.org>
References: <20220510130740.392653815@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kai-Heng Feng <kai.heng.feng@canonical.com>

commit 887f75cfd0da44c19dda93b2ff9e70ca8792cdc1 upstream.

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
Cc: "Limonciello, Mario" <Mario.Limonciello@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c |   18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c
@@ -2246,18 +2246,23 @@ static int amdgpu_pmops_suspend(struct d
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
@@ -2494,6 +2499,7 @@ static const struct dev_pm_ops amdgpu_pm
 	.prepare = amdgpu_pmops_prepare,
 	.complete = amdgpu_pmops_complete,
 	.suspend = amdgpu_pmops_suspend,
+	.suspend_noirq = amdgpu_pmops_suspend_noirq,
 	.resume = amdgpu_pmops_resume,
 	.freeze = amdgpu_pmops_freeze,
 	.thaw = amdgpu_pmops_thaw,


