Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A55F677000
	for <lists+stable@lfdr.de>; Sun, 22 Jan 2023 16:27:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231448AbjAVP1Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Jan 2023 10:27:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231453AbjAVP1Z (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 22 Jan 2023 10:27:25 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EBAE23130
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 07:27:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EE83260C57
        for <stable@vger.kernel.org>; Sun, 22 Jan 2023 15:27:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09388C433D2;
        Sun, 22 Jan 2023 15:27:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1674401243;
        bh=6cMzpeRJkK0QFC8MKqejIFXYbEFYRCdczwOQ2LFQSRw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oaI+/X9o2pxAwxuNHbOY2MsN59Dm69YMkk8jFBUREnzvR7Nq6thwBrMk7n4oktHXX
         lSwZehwmMkUvRNdV8X9fsoN/gQbtAIahd2K95XESChgjgFraJ7sJ41oyNu92nEDace
         me3CB9tz9aMbMRit+y2xIOL5vZOgmKBSWQSUqavc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Alex Deucher <alexander.deucher@amd.com>,
        Jesse Zhang <Jesse.Zhang@amd.com>,
        Aaron Liu <aaron.liu@amd.com>
Subject: [PATCH 6.1 136/193] drm/amdgpu: Correct the power calcultion for Renior/Cezanne.
Date:   Sun, 22 Jan 2023 16:04:25 +0100
Message-Id: <20230122150252.574674722@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230122150246.321043584@linuxfoundation.org>
References: <20230122150246.321043584@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: jie1zhan <jesse.zhang@amd.com>

commit c7bae4aaa5609c1fa9761c35dbcc5fcc92915222 upstream.

>From smu firmware,the value of power is transferred  in units of watts.

Bug: https://gitlab.freedesktop.org/drm/amd/-/issues/2321
Fixes: 137aac26a2ed ("drm/amdgpu/smu12: fix power reporting on renoir")
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Jesse Zhang <Jesse.Zhang@amd.com>
Reviewed-by: Aaron Liu <aaron.liu@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/pm/swsmu/smu12/renoir_ppt.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/pm/swsmu/smu12/renoir_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu12/renoir_ppt.c
@@ -1171,6 +1171,7 @@ static int renoir_get_smu_metrics_data(s
 	int ret = 0;
 	uint32_t apu_percent = 0;
 	uint32_t dgpu_percent = 0;
+	struct amdgpu_device *adev = smu->adev;
 
 
 	ret = smu_cmn_get_metrics_table(smu,
@@ -1196,7 +1197,11 @@ static int renoir_get_smu_metrics_data(s
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


