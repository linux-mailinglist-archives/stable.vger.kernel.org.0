Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 350604ABCCD
	for <lists+stable@lfdr.de>; Mon,  7 Feb 2022 12:50:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1387126AbiBGLjX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Feb 2022 06:39:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1385982AbiBGLdO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Feb 2022 06:33:14 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3E93C043181;
        Mon,  7 Feb 2022 03:33:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 51A8460B20;
        Mon,  7 Feb 2022 11:33:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C6D0C004E1;
        Mon,  7 Feb 2022 11:33:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644233592;
        bh=XQ2A7nbGwX4O6tcgG0WTiKbbbmm4PnYNbnVuQr6D52U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QmLCciIucW2XiuaHt+dW8etwOL3zlLathUBaCasX6Rq6U72op6974LrFCMErT/t9T
         dSUSxCYftG0fafBy17zoOBGgkTDtNdehTpbOF1gmyQT9yX9XFXAzAPYM20jT7XhsPn
         xOPOEOBf0r9EWYsBNwVorWDE2HMjh4ut3cwaYXb8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Aun-Ali Zaidi <admin@kodeit.net>,
        Harry Wentland <harry.wentland@amd.com>,
        Aditya Garg <gargaditya08@live.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.16 028/126] drm/amd/display: Force link_rate as LINK_RATE_RBR2 for 2018 15" Apple Retina panels
Date:   Mon,  7 Feb 2022 12:05:59 +0100
Message-Id: <20220207103805.117814786@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220207103804.053675072@linuxfoundation.org>
References: <20220207103804.053675072@linuxfoundation.org>
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

From: Aun-Ali Zaidi <admin@kodeit.net>

commit 30fbce374745a9c6af93c775a5ac49a97f822fda upstream.

The eDP link rate reported by the DP_MAX_LINK_RATE dpcd register (0xa) is
contradictory to the highest rate supported reported by
EDID (0xc = LINK_RATE_RBR2). The effects of this compounded with commit
'4a8ca46bae8a ("drm/amd/display: Default max bpc to 16 for eDP")' results
in no display modes being found and a dark panel.

For now, simply force the maximum supported link rate for the eDP attached
2018 15" Apple Retina panels.

Additionally, we must also check the firmware revision since the device ID
reported by the DPCD is identical to that of the more capable 16,1,
incorrectly quirking it. We also use said firmware check to quirk the
refreshed 15,1 models with Vega graphics as they use a slightly newer
firmware version.

Tested-by: Aun-Ali Zaidi <admin@kodeit.net>
Reviewed-by: Harry Wentland <harry.wentland@amd.com>
Signed-off-by: Aun-Ali Zaidi <admin@kodeit.net>
Signed-off-by: Aditya Garg <gargaditya08@live.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c |   20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

--- a/drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c
@@ -4730,6 +4730,26 @@ static bool retrieve_link_cap(struct dc_
 		dp_hw_fw_revision.ieee_fw_rev,
 		sizeof(dp_hw_fw_revision.ieee_fw_rev));
 
+	/* Quirk for Apple MBP 2018 15" Retina panels: wrong DP_MAX_LINK_RATE */
+	{
+		uint8_t str_mbp_2018[] = { 101, 68, 21, 103, 98, 97 };
+		uint8_t fwrev_mbp_2018[] = { 7, 4 };
+		uint8_t fwrev_mbp_2018_vega[] = { 8, 4 };
+
+		/* We also check for the firmware revision as 16,1 models have an
+		 * identical device id and are incorrectly quirked otherwise.
+		 */
+		if ((link->dpcd_caps.sink_dev_id == 0x0010fa) &&
+		    !memcmp(link->dpcd_caps.sink_dev_id_str, str_mbp_2018,
+			     sizeof(str_mbp_2018)) &&
+		    (!memcmp(link->dpcd_caps.sink_fw_revision, fwrev_mbp_2018,
+			     sizeof(fwrev_mbp_2018)) ||
+		    !memcmp(link->dpcd_caps.sink_fw_revision, fwrev_mbp_2018_vega,
+			     sizeof(fwrev_mbp_2018_vega)))) {
+			link->reported_link_cap.link_rate = LINK_RATE_RBR2;
+		}
+	}
+
 	memset(&link->dpcd_caps.dsc_caps, '\0',
 			sizeof(link->dpcd_caps.dsc_caps));
 	memset(&link->dpcd_caps.fec_cap, '\0', sizeof(link->dpcd_caps.fec_cap));


