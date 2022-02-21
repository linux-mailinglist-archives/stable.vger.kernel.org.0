Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B8E94BE284
	for <lists+stable@lfdr.de>; Mon, 21 Feb 2022 18:55:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351543AbiBUJte (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 04:49:34 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:40410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352937AbiBUJsC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Feb 2022 04:48:02 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33FEAFEF;
        Mon, 21 Feb 2022 01:21:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BC45160F4E;
        Mon, 21 Feb 2022 09:21:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C996DC340EC;
        Mon, 21 Feb 2022 09:21:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645435295;
        bh=a3J8QM1OA1gD01iP8ymTHliU1reXk59up1EmTg4RyTo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VYkT72XcLt9OI1SMuFNHDRL0bruhuIghrtowQ2oNdKLHZjkaAJuNyJ1GZudENvSU7
         MxUdYI1Jg3EhBXqmrUeR9UAJGu/yyLJwIr6YBkvpv8UkOGGi8L5/qjBshxbt2mtN2k
         KWtIqWFgryHZEe/9tw7OjPQynBffBCOtPTOHdzs8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yifan Zhang <yifan1.zhang@amd.com>,
        Aaron Liu <aaron.liu@amd.com>, Huang Rui <ray.huang@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.16 081/227] drm/amd/pm: correct the sequence of sending gpu reset msg
Date:   Mon, 21 Feb 2022 09:48:20 +0100
Message-Id: <20220221084937.563094576@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220221084934.836145070@linuxfoundation.org>
References: <20220221084934.836145070@linuxfoundation.org>
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
@@ -282,14 +282,9 @@ static int yellow_carp_post_smu_init(str
 
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
 


