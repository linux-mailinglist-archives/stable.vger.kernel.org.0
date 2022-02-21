Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB9EC4BE61C
	for <lists+stable@lfdr.de>; Mon, 21 Feb 2022 19:01:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349003AbiBUJXb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 04:23:31 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:38984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350346AbiBUJW1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Feb 2022 04:22:27 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDCFD387A0;
        Mon, 21 Feb 2022 01:09:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5E52560B24;
        Mon, 21 Feb 2022 09:09:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46DA6C340E9;
        Mon, 21 Feb 2022 09:09:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645434594;
        bh=lzNlqDpoAJKh6gySC7LSWD1h2RzEJ+837TUQzaYknuY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OYJ0Lvwmn7FZDEY5Fkpm1NPeaxYujDZtApvUuz6okHEQUysLvT8CM9SbzAx0UeHrG
         fyV4eIoRApp1wbcSveeoQucXsbZyE4MIjyKyuPfn4r6l0D+4/4h/Eoug4Xcd0k26hJ
         1AHULlPXYBMJ91k/N8BG6bjaFZt4j9ytLTwV5vQo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yifan Zhang <yifan1.zhang@amd.com>,
        Aaron Liu <aaron.liu@amd.com>, Huang Rui <ray.huang@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.15 063/196] drm/amd/pm: correct the sequence of sending gpu reset msg
Date:   Mon, 21 Feb 2022 09:48:15 +0100
Message-Id: <20220221084933.041430152@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220221084930.872957717@linuxfoundation.org>
References: <20220221084930.872957717@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Yifan Zhang <yifan1.zhang@amd.com>

commit 9c4f59ea3f865693150edf0c91d1cc6b451360dd upstream.

the 2nd parameter should be smu msg type rather than asic msg index.

Fixes: 7d38d9dc4ecc ("drm/amdgpu: add mode2 reset support for yellow carp")
Signed-off-by: Yifan Zhang <yifan1.zhang@amd.com>
Acked-by: Aaron Liu <aaron.liu@amd.com>
Reviewed-by: Huang Rui <ray.huang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/pm/swsmu/smu13/yellow_carp_ppt.c |    9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

--- a/drivers/gpu/drm/amd/pm/swsmu/smu13/yellow_carp_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu13/yellow_carp_ppt.c
@@ -291,14 +291,9 @@ static int yellow_carp_post_smu_init(str
 
 static int yellow_carp_mode_reset(struct smu_context *smu, int type)
 {
-	int ret = 0, index = 0;
+	int ret = 0;
 
-	index = smu_cmn_to_asic_specific_index(smu, CMN2ASIC_MAPPING_MSG,
-				SMU_MSG_GfxDeviceDriverReset);
-	if (index < 0)
-		return index == -EACCES ? 0 : index;
-
-	ret = smu_cmn_send_smc_msg_with_param(smu, (uint16_t)index, type, NULL);
+	ret = smu_cmn_send_smc_msg_with_param(smu, SMU_MSG_GfxDeviceDriverReset, type, NULL);
 	if (ret)
 		dev_err(smu->adev->dev, "Failed to mode reset!\n");
 


