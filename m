Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2EEF84FD52D
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 12:11:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351389AbiDLHdA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 03:33:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354054AbiDLH0B (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 03:26:01 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3D5A16589;
        Tue, 12 Apr 2022 00:05:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 545E4B81B51;
        Tue, 12 Apr 2022 07:05:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4A34C385A6;
        Tue, 12 Apr 2022 07:05:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649747125;
        bh=K13Fcmd4pjZ4VFRVTHDJAb+fVTQ92rUnm6te9GXG10M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SCIsJ5DLuh0C4DEhD0uZNHq0xXDIvSaqNSEvnkZakognbi8eag2r5BtLoB6+S5vEZ
         Ivf0NZWS1yzTjbzPamWPDzu20+mwuvjGZOZFqyxmmDcFdWZHAFPb3gCIsYJdOlklb8
         jGriCBcw86qrY0SSIqOB/jPnrRMZruvS+M7VLKeg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Benjamin Marty <info@benjaminmarty.ch>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.16 253/285] drm/amdgpu/display: change pipe policy for DCN 2.1
Date:   Tue, 12 Apr 2022 08:31:50 +0200
Message-Id: <20220412062950.962957758@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412062943.670770901@linuxfoundation.org>
References: <20220412062943.670770901@linuxfoundation.org>
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

From: Benjamin Marty <info@benjaminmarty.ch>

commit 879791ad8bf3dc5453061cad74776a617b6e3319 upstream.

Fixes crash on MST Hub disconnect.

Bug: https://gitlab.freedesktop.org/drm/amd/-/issues/1849
Fixes: ee2698cf79cc ("drm/amd/display: Changed pipe split policy to allow for multi-display pipe split")
Signed-off-by: Benjamin Marty <info@benjaminmarty.ch>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/dcn21/dcn21_resource.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/display/dc/dcn21/dcn21_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn21/dcn21_resource.c
@@ -874,7 +874,7 @@ static const struct dc_debug_options deb
 		.clock_trace = true,
 		.disable_pplib_clock_request = true,
 		.min_disp_clk_khz = 100000,
-		.pipe_split_policy = MPC_SPLIT_DYNAMIC,
+		.pipe_split_policy = MPC_SPLIT_AVOID_MULT_DISP,
 		.force_single_disp_pipe_split = false,
 		.disable_dcc = DCC_ENABLE,
 		.vsr_support = true,


