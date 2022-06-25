Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25A6655AB14
	for <lists+stable@lfdr.de>; Sat, 25 Jun 2022 16:47:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233019AbiFYOqg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 25 Jun 2022 10:46:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233020AbiFYOqf (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 25 Jun 2022 10:46:35 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BB7512773
        for <stable@vger.kernel.org>; Sat, 25 Jun 2022 07:46:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 19A7DCE0958
        for <stable@vger.kernel.org>; Sat, 25 Jun 2022 14:46:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00440C3411C;
        Sat, 25 Jun 2022 14:46:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1656168391;
        bh=NYVQs9GGXOGze7rpL+eqi2o6zwAj+Z+HmQix9o38e84=;
        h=Subject:To:Cc:From:Date:From;
        b=NdB5XyGdsYvXCVURBQPCsv0rbMnhVAOuHIQmV+f4E6NdU4V49M6dj+C8ldVQM0dzz
         PRqth8Y4HMF3ssW/ZnAxqzugT6ZVJPy4d0DGQihwpBkeB3b5M6EgNI3NKtrrfO3+7g
         RBTwmwHfKdFVvxs6LuE8wFRXkk7F22XfnVvnZFjQ=
Subject: FAILED: patch "[PATCH] amd/display/dc: Fix COLOR_ENCODING and COLOR_RANGE doing" failed to apply to 5.10-stable tree
To:     joshua@froggi.es, alexander.deucher@amd.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 25 Jun 2022 16:46:20 +0200
Message-ID: <1656168380246201@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
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


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From e84131a88a8cdcd6fe9f234ed98e3f8ca049142b Mon Sep 17 00:00:00 2001
From: Joshua Ashton <joshua@froggi.es>
Date: Thu, 16 Jun 2022 01:21:27 +0000
Subject: [PATCH] amd/display/dc: Fix COLOR_ENCODING and COLOR_RANGE doing
 nothing for DCN20+

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

diff --git a/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_dpp.c b/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_dpp.c
index 970b65efeac1..eaa7032f0f1a 100644
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
diff --git a/drivers/gpu/drm/amd/display/dc/dcn201/dcn201_dpp.c b/drivers/gpu/drm/amd/display/dc/dcn201/dcn201_dpp.c
index 8b6505b7dca8..f50ab961bc17 100644
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
diff --git a/drivers/gpu/drm/amd/display/dc/dcn30/dcn30_dpp.c b/drivers/gpu/drm/amd/display/dc/dcn30/dcn30_dpp.c
index ab3918c0a15b..0dcc07531643 100644
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

