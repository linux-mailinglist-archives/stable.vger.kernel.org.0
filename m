Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 772E2676D2A
	for <lists+stable@lfdr.de>; Sun, 22 Jan 2023 14:35:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229966AbjAVNfW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Jan 2023 08:35:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229963AbjAVNfV (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 22 Jan 2023 08:35:21 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45AA91ABE1
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 05:35:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D518460BA4
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 13:35:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9EEDC433D2;
        Sun, 22 Jan 2023 13:35:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1674394520;
        bh=esT9+GUtjqIbHylbvH69Kb1N/DRXFnlh1EqXFiYBkBI=;
        h=Subject:To:Cc:From:Date:From;
        b=WTLX93Q7mHsKdXIU6JAWnYvJV2AWrqLyrpJwMkr51OuP351qXtznTcCIL7jvGjj6Y
         so7QxX2eWKO+mlONZlBASV0LtD66xL7CKYRP7u8h144JhSW5jSMHb3vWBko/Isy0Fc
         de9WCl4q1vYecZ2GcnzQDOOtsl+woo01Ip2irtw4=
Subject: FAILED: patch "[PATCH] drm/amdgpu: Correct the power calcultion for Renior/Cezanne." failed to apply to 5.15-stable tree
To:     jesse.zhang@amd.com, Jesse.Zhang@amd.com, aaron.liu@amd.com,
        alexander.deucher@amd.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 22 Jan 2023 14:35:17 +0100
Message-ID: <167439451724102@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

c7bae4aaa560 ("drm/amdgpu: Correct the power calcultion for Renior/Cezanne.")
138292f1dc00 ("drm/amd/pm: update smartshift powerboost calc for smu12")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From c7bae4aaa5609c1fa9761c35dbcc5fcc92915222 Mon Sep 17 00:00:00 2001
From: jie1zhan <jesse.zhang@amd.com>
Date: Fri, 13 Jan 2023 10:39:13 +0800
Subject: [PATCH] drm/amdgpu: Correct the power calcultion for Renior/Cezanne.

From smu firmware,the value of power is transferred  in units of watts.

Bug: https://gitlab.freedesktop.org/drm/amd/-/issues/2321
Fixes: 137aac26a2ed ("drm/amdgpu/smu12: fix power reporting on renoir")
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Jesse Zhang <Jesse.Zhang@amd.com>
Reviewed-by: Aaron Liu <aaron.liu@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org

diff --git a/drivers/gpu/drm/amd/pm/swsmu/smu12/renoir_ppt.c b/drivers/gpu/drm/amd/pm/swsmu/smu12/renoir_ppt.c
index 85e22210963f..5cdc07165480 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/smu12/renoir_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu12/renoir_ppt.c
@@ -1171,6 +1171,7 @@ static int renoir_get_smu_metrics_data(struct smu_context *smu,
 	int ret = 0;
 	uint32_t apu_percent = 0;
 	uint32_t dgpu_percent = 0;
+	struct amdgpu_device *adev = smu->adev;
 
 
 	ret = smu_cmn_get_metrics_table(smu,
@@ -1196,7 +1197,11 @@ static int renoir_get_smu_metrics_data(struct smu_context *smu,
 		*value = metrics->AverageUvdActivity / 100;
 		break;
 	case METRICS_AVERAGE_SOCKETPOWER:
-		*value = (metrics->CurrentSocketPower << 8) / 1000;
+		if (((adev->ip_versions[MP1_HWIP][0] == IP_VERSION(12, 0, 1)) && (adev->pm.fw_version >= 0x40000f)) ||
+		((adev->ip_versions[MP1_HWIP][0] == IP_VERSION(12, 0, 0)) && (adev->pm.fw_version >= 0x373200)))
+			*value = metrics->CurrentSocketPower << 8;
+		else
+			*value = (metrics->CurrentSocketPower << 8) / 1000;
 		break;
 	case METRICS_TEMPERATURE_EDGE:
 		*value = (metrics->GfxTemperature / 100) *

