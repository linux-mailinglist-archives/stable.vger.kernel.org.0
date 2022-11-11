Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6436E625086
	for <lists+stable@lfdr.de>; Fri, 11 Nov 2022 03:36:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232094AbiKKCgN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Nov 2022 21:36:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232901AbiKKCfp (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Nov 2022 21:35:45 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E45DE68C7E;
        Thu, 10 Nov 2022 18:34:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C113AB823E0;
        Fri, 11 Nov 2022 02:34:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69118C433C1;
        Fri, 11 Nov 2022 02:34:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668134076;
        bh=rnuZN+iCie0gINOXbx+tLIEv5lK1RT+pR6UPa/vAJH0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uQ7GdlOinSk3Vhh6sPMJyw1GrXJ5/IWqT5MUHfxHR57cyD6ssQReZOa154ZLYQlEb
         iYgbyUVrHzd1+FLMlKNK/bkSiUQYYhS3u1DG+OxUhw5pKJkop7BKzTrPYg/P8O1K2L
         e3Xy7pae2pBOCCoLS9PFRwobMAUtFFCt/1SGDIBsKKXlWyxiTu8WAFeFiCF64IrEjk
         YQMuDJmBrDvitFn77+7HlLhkswg23yXeEmOIpuG8mKXX4MVP7asEnUQj1VGQOoAxmP
         vK/YslxotrQUMQAzN3cP9+vB6vCXO1NwYtS1qpFZCOvyETKIY65qo7nNamUd7SsiQF
         vJ0sJNBA3LW3Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     George Shen <george.shen@amd.com>, Alvin Lee <Alvin.Lee2@amd.com>,
        Alex Hung <alex.hung@amd.com>,
        Mark Broadworth <mark.broadworth@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, harry.wentland@amd.com,
        sunpeng.li@amd.com, Rodrigo.Siqueira@amd.com,
        christian.koenig@amd.com, Xinhui.Pan@amd.com, airlied@gmail.com,
        daniel@ffwll.ch, nathan@kernel.org, chris.park@amd.com,
        wayne.lin@amd.com, mairacanal@riseup.net, aurabindo.pillai@amd.com,
        amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 6.0 22/30] drm/amd/display: Fix DCN32 DSC delay calculation
Date:   Thu, 10 Nov 2022 21:33:30 -0500
Message-Id: <20221111023340.227279-22-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221111023340.227279-1-sashal@kernel.org>
References: <20221111023340.227279-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: George Shen <george.shen@amd.com>

[ Upstream commit bad610c97c08eef3ed1fa769a8b08b94f95b451e ]

[Why]
DCN32 DSC delay calculation had an unintentional integer division,
resulting in a mismatch against the DML spreadsheet.

[How]
Cast numerator to double before performing the division.

Reviewed-by: Alvin Lee <Alvin.Lee2@amd.com>
Acked-by: Alex Hung <alex.hung@amd.com>
Signed-off-by: George Shen <george.shen@amd.com>
Tested-by: Mark Broadworth <mark.broadworth@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../gpu/drm/amd/display/dc/dml/dcn32/display_mode_vba_util_32.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dml/dcn32/display_mode_vba_util_32.c b/drivers/gpu/drm/amd/display/dc/dml/dcn32/display_mode_vba_util_32.c
index 365d290bba99..67af8f4df8b8 100644
--- a/drivers/gpu/drm/amd/display/dc/dml/dcn32/display_mode_vba_util_32.c
+++ b/drivers/gpu/drm/amd/display/dc/dml/dcn32/display_mode_vba_util_32.c
@@ -1746,7 +1746,7 @@ unsigned int dml32_DSCDelayRequirement(bool DSCEnabled,
 		}
 
 		DSCDelayRequirement_val = DSCDelayRequirement_val + (HTotal - HActive) *
-				dml_ceil(DSCDelayRequirement_val / HActive, 1);
+				dml_ceil((double)DSCDelayRequirement_val / HActive, 1);
 
 		DSCDelayRequirement_val = DSCDelayRequirement_val * PixelClock / PixelClockBackEnd;
 
-- 
2.35.1

