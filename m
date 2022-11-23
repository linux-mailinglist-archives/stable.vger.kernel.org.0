Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B446D63588F
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 11:00:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236563AbiKWKAm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 05:00:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236729AbiKWKAA (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 05:00:00 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 677531582E
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 01:52:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AA4BD61B8F
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 09:52:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7BCAC433D7;
        Wed, 23 Nov 2022 09:52:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669197169;
        bh=AAKqkl3uqeuK4e2cWRPZJ4l3NWqe3HZuYSnLijkIz74=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YMNyelZcP4Betv7CqJHKibp9ZPrUQnPP0dp/c+zXJzp6/FN/wWhs6YV4N1cz+U84y
         JtwhbUyxP4t8vpPUYzRMZchSuR/+w08bFiW2/TvP45EySuLOsx55IgyvWFl4n6uIZx
         7PeA1WWED0gpHUKy8FPNccmnT+hnNlXFYJj8mg1U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Nicholas Kazlauskas <Nicholas.Kazlauskas@amd.com>,
        Tom Chung <chiahsuan.chung@amd.com>,
        Roman Li <roman.li@amd.com>,
        Daniel Wheeler <daniel.wheeler@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.0 218/314] drm/amd/display: Fix optc2_configure warning on dcn314
Date:   Wed, 23 Nov 2022 09:51:03 +0100
Message-Id: <20221123084635.420464398@linuxfoundation.org>
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

From: Roman Li <roman.li@amd.com>

commit e7e4f77c991c9abf90924929a9d55f90b0bb78de upstream.

[Why]
dcn314 uses optc2_configure_crc() that wraps
optc1_configure_crc() + set additional registers
not applicable to dcn314.
It's not critical but when used leads to warning like:
WARNING: drivers/gpu/drm/amd/amdgpu/../display/dc/dc_helper.c
Call Trace:
<TASK>
generic_reg_set_ex+0x6d/0xe0 [amdgpu]
optc2_configure_crc+0x60/0x80 [amdgpu]
dc_stream_configure_crc+0x129/0x150 [amdgpu]
amdgpu_dm_crtc_configure_crc_source+0x5d/0xe0 [amdgpu]

[How]
Use optc1_configure_crc() directly

Reviewed-by: Nicholas Kazlauskas <Nicholas.Kazlauskas@amd.com>
Acked-by: Tom Chung <chiahsuan.chung@amd.com>
Signed-off-by: Roman Li <roman.li@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org # 6.0.x
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/dcn314/dcn314_optc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/display/dc/dcn314/dcn314_optc.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn314/dcn314_optc.c
@@ -237,7 +237,7 @@ static struct timing_generator_funcs dcn
 		.clear_optc_underflow = optc1_clear_optc_underflow,
 		.setup_global_swap_lock = NULL,
 		.get_crc = optc1_get_crc,
-		.configure_crc = optc2_configure_crc,
+		.configure_crc = optc1_configure_crc,
 		.set_dsc_config = optc3_set_dsc_config,
 		.get_dsc_status = optc2_get_dsc_status,
 		.set_dwb_source = NULL,


