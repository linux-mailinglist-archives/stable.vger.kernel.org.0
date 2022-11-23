Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF0056357AE
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 10:46:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238208AbiKWJoS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 04:44:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238188AbiKWJn5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 04:43:57 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 253E83E0A1
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 01:41:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B615D61B6D
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 09:41:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9781C433D6;
        Wed, 23 Nov 2022 09:41:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669196514;
        bh=rnuZN+iCie0gINOXbx+tLIEv5lK1RT+pR6UPa/vAJH0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JVmWIKbCbT6i0PIz1/Alvswd4zL4niis/1IKcobGvCQ/ZfwqH2aLdvaokWbaeTR3U
         svempPo0AG3h5slBfuMYbA6Ru6ZoIrNfrGq8VSseQNHfatFKanYgVH55mad1tRTpKr
         lfcP0OHEEBWdhdNJlPUZRiKvhOSjz21auGHeY/c4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Alvin Lee <Alvin.Lee2@amd.com>,
        Alex Hung <alex.hung@amd.com>,
        George Shen <george.shen@amd.com>,
        Mark Broadworth <mark.broadworth@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 053/314] drm/amd/display: Fix DCN32 DSC delay calculation
Date:   Wed, 23 Nov 2022 09:48:18 +0100
Message-Id: <20221123084627.916590175@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084625.457073469@linuxfoundation.org>
References: <20221123084625.457073469@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



