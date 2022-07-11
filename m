Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22C3756FD1D
	for <lists+stable@lfdr.de>; Mon, 11 Jul 2022 11:51:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233867AbiGKJu7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 05:50:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233761AbiGKJuQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 05:50:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1ACA31224;
        Mon, 11 Jul 2022 02:24:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 699E16112E;
        Mon, 11 Jul 2022 09:24:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79C8DC34115;
        Mon, 11 Jul 2022 09:24:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657531468;
        bh=U0t7320AYDbcwwyLOZh9lTpswuXbCQhm6S7HxSJKKR0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FO4CnZ996AG2Sv7sveLFVeXtG86KHWUtMu4GotvLd5f3rdl8Rcdo1nfl1c8SnOhac
         qMkvtsv4gdmqRXbA4rE9NBxWFlyfPVdbtmLqUAS4qTrgXxq4DWoU+MnVagWPvyHpnp
         J1g14BXcvXWJQ8T94VeIuEakLjrbQZc6NcpY37zg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, James Zhu <James.Zhu@amd.com>,
        tiancyin <tianci.yin@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 116/230] drm/amd/vcn: fix an error msg on vcn 3.0
Date:   Mon, 11 Jul 2022 11:06:12 +0200
Message-Id: <20220711090607.357523545@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220711090604.055883544@linuxfoundation.org>
References: <20220711090604.055883544@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: tiancyin <tianci.yin@amd.com>

[ Upstream commit 425d7a87e54ee358f580eaf10cf28dc95f7121c1 ]

Some video card has more than one vcn instance, passing 0 to
vcn_v3_0_pause_dpg_mode is incorrect.

Error msg:
Register(1) [mmUVD_POWER_STATUS] failed to reach value
0x00000001 != 0x00000002

Reviewed-by: James Zhu <James.Zhu@amd.com>
Signed-off-by: tiancyin <tianci.yin@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/vcn_v3_0.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/vcn_v3_0.c b/drivers/gpu/drm/amd/amdgpu/vcn_v3_0.c
index 6e56bef4fdf8..1310617f030f 100644
--- a/drivers/gpu/drm/amd/amdgpu/vcn_v3_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/vcn_v3_0.c
@@ -1511,7 +1511,7 @@ static int vcn_v3_0_stop_dpg_mode(struct amdgpu_device *adev, int inst_idx)
 	struct dpg_pause_state state = {.fw_based = VCN_DPG_STATE__UNPAUSE};
 	uint32_t tmp;
 
-	vcn_v3_0_pause_dpg_mode(adev, 0, &state);
+	vcn_v3_0_pause_dpg_mode(adev, inst_idx, &state);
 
 	/* Wait for power status to be 1 */
 	SOC15_WAIT_ON_RREG(VCN, inst_idx, mmUVD_POWER_STATUS, 1,
-- 
2.35.1



