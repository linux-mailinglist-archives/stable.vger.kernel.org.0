Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9DFA150526F
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 14:43:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239012AbiDRMop (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 08:44:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240020AbiDRMnf (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 08:43:35 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1C56205DD;
        Mon, 18 Apr 2022 05:32:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9C25EB80EC1;
        Mon, 18 Apr 2022 12:32:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3D7EC385A1;
        Mon, 18 Apr 2022 12:32:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650285137;
        bh=SkTxKGpq5IdnT24frrZD85hnt9CFrIND0AlDlK+IMmI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fsAQFTTPREskvHtWYb6JI7O642ckmxBBHp2nSTQ0Np7KOvUJ5GhFqaTQR0q6zY16+
         2wkV26UwW1FBhYg6A5I3LFOmOaPJsa2qixlzfIJE7tq5Yqp+XzXnz1RHYSMT6k2EJd
         ENm7f6aArnm+B9c+mWWJBDGLSicBEEmETnDMceLg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, James Zhu <James.Zhu@amd.com>,
        Tianci Yin <tianci.yin@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 114/189] drm/amdgpu/vcn: improve vcn dpg stop procedure
Date:   Mon, 18 Apr 2022 14:12:14 +0200
Message-Id: <20220418121203.735337217@linuxfoundation.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220418121200.312988959@linuxfoundation.org>
References: <20220418121200.312988959@linuxfoundation.org>
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

From: Tianci Yin <tianci.yin@amd.com>

[ Upstream commit 6ea239adc2a712eb318f04f5c29b018ba65ea38a ]

Prior to disabling dpg, VCN need unpausing dpg mode, or VCN will hang in
S3 resuming.

Reviewed-by: James Zhu <James.Zhu@amd.com>
Signed-off-by: Tianci Yin <tianci.yin@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/vcn_v3_0.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/vcn_v3_0.c b/drivers/gpu/drm/amd/amdgpu/vcn_v3_0.c
index 54b405fc600d..6e56bef4fdf8 100644
--- a/drivers/gpu/drm/amd/amdgpu/vcn_v3_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/vcn_v3_0.c
@@ -1508,8 +1508,11 @@ static int vcn_v3_0_start_sriov(struct amdgpu_device *adev)
 
 static int vcn_v3_0_stop_dpg_mode(struct amdgpu_device *adev, int inst_idx)
 {
+	struct dpg_pause_state state = {.fw_based = VCN_DPG_STATE__UNPAUSE};
 	uint32_t tmp;
 
+	vcn_v3_0_pause_dpg_mode(adev, 0, &state);
+
 	/* Wait for power status to be 1 */
 	SOC15_WAIT_ON_RREG(VCN, inst_idx, mmUVD_POWER_STATUS, 1,
 		UVD_POWER_STATUS__UVD_POWER_STATUS_MASK);
-- 
2.35.1



