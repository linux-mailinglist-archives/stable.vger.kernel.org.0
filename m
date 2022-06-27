Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A310155CBBF
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 15:00:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237919AbiF0LtR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 07:49:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238062AbiF0Lro (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 07:47:44 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B1ADE0B2;
        Mon, 27 Jun 2022 04:39:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 39EFBB8111B;
        Mon, 27 Jun 2022 11:39:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5460EC3411D;
        Mon, 27 Jun 2022 11:39:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656329962;
        bh=kOUE1GaFmUXYJlFUj3PmG1QXwgQjmYX0e9h9HgKSy/k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cN+OGfTVrzeLUu+4XsHEceD4A9m5sOIBMBwbQDmTsxKgw5DoqGu3pa+UcHEy/PtRU
         2/KFLkixHrPYcUYDn9rzyLQ3IYhAqkstCqjyX9gJx4pUk79rYI2vK0hGl4Xhz4cmEV
         6BoaoQbr8Sti9MzHN5v1i7IINVs3tULN1eRhwrpI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Joshua Ashton <joshua@froggi.es>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.18 036/181] amd/display/dc: Fix COLOR_ENCODING and COLOR_RANGE doing nothing for DCN20+
Date:   Mon, 27 Jun 2022 13:20:09 +0200
Message-Id: <20220627111945.609264051@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220627111944.553492442@linuxfoundation.org>
References: <20220627111944.553492442@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Joshua Ashton <joshua@froggi.es>

commit e84131a88a8cdcd6fe9f234ed98e3f8ca049142b upstream.

For DCN20 and above, the code that actually hooks up the provided
input_color_space got lost at some point.

Fixes COLOR_ENCODING and COLOR_RANGE doing nothing on DCN20+.
Tested using Steam Remote Play Together + gamescope.

Update other DCNs the same wasy DCN1.x was updates in
commit a1e07ba89d49 ("drm/amd/display: Use plane->color_space for dpp if specified")

Fixes: a1e07ba89d49 ("drm/amd/display: Use plane->color_space for dpp if specified")
Signed-off-by: Joshua Ashton <joshua@froggi.es>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/dcn20/dcn20_dpp.c   |    3 +++
 drivers/gpu/drm/amd/display/dc/dcn201/dcn201_dpp.c |    3 +++
 drivers/gpu/drm/amd/display/dc/dcn30/dcn30_dpp.c   |    3 +++
 3 files changed, 9 insertions(+)

--- a/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_dpp.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_dpp.c
@@ -212,6 +212,9 @@ static void dpp2_cnv_setup (
 		break;
 	}
 
+	/* Set default color space based on format if none is given. */
+	color_space = input_color_space ? input_color_space : color_space;
+
 	if (is_2bit == 1 && alpha_2bit_lut != NULL) {
 		REG_UPDATE(ALPHA_2BIT_LUT, ALPHA_2BIT_LUT0, alpha_2bit_lut->lut0);
 		REG_UPDATE(ALPHA_2BIT_LUT, ALPHA_2BIT_LUT1, alpha_2bit_lut->lut1);
--- a/drivers/gpu/drm/amd/display/dc/dcn201/dcn201_dpp.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn201/dcn201_dpp.c
@@ -153,6 +153,9 @@ static void dpp201_cnv_setup(
 		break;
 	}
 
+	/* Set default color space based on format if none is given. */
+	color_space = input_color_space ? input_color_space : color_space;
+
 	if (is_2bit == 1 && alpha_2bit_lut != NULL) {
 		REG_UPDATE(ALPHA_2BIT_LUT, ALPHA_2BIT_LUT0, alpha_2bit_lut->lut0);
 		REG_UPDATE(ALPHA_2BIT_LUT, ALPHA_2BIT_LUT1, alpha_2bit_lut->lut1);
--- a/drivers/gpu/drm/amd/display/dc/dcn30/dcn30_dpp.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn30/dcn30_dpp.c
@@ -294,6 +294,9 @@ static void dpp3_cnv_setup (
 		break;
 	}
 
+	/* Set default color space based on format if none is given. */
+	color_space = input_color_space ? input_color_space : color_space;
+
 	if (is_2bit == 1 && alpha_2bit_lut != NULL) {
 		REG_UPDATE(ALPHA_2BIT_LUT, ALPHA_2BIT_LUT0, alpha_2bit_lut->lut0);
 		REG_UPDATE(ALPHA_2BIT_LUT, ALPHA_2BIT_LUT1, alpha_2bit_lut->lut1);


