Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D69C06649B6
	for <lists+stable@lfdr.de>; Tue, 10 Jan 2023 19:24:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239144AbjAJSX7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Jan 2023 13:23:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239377AbjAJSXB (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Jan 2023 13:23:01 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8212B7EC
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 10:21:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D04D3B81903
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 18:21:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DEEFC433F0;
        Tue, 10 Jan 2023 18:20:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673374859;
        bh=blPbxiJS8xaEfUuPdOJp/iP2vaDLqlAVnfXRSlY6OHY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kXWbCJk7QfMzhj0rqTZ1uwD2xBYw/+QkkLx1EfNZyYpP5KbhOpQkW5hvF3Ox/i5vJ
         N0JeRU73U2XbeFLmLINCowP3aWQVNbJ0EGfBifPydx64rEoJhjN2qWCkN02rH9iXKO
         Edoeii1f2xQh0ixlAeblFWVTXbU5U1GrSlLK4UsA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
        <ville.syrjala@linux.intel.com>,
        Jani Nikula <jani.nikula@intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>
Subject: [PATCH 6.1 157/159] drm/i915/dsi: fix MIPI_BKLT_EN_1 native GPIO index
Date:   Tue, 10 Jan 2023 19:05:05 +0100
Message-Id: <20230110180023.569812671@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230110180018.288460217@linuxfoundation.org>
References: <20230110180018.288460217@linuxfoundation.org>
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

From: Jani Nikula <jani.nikula@intel.com>

commit 6217e9f05a74df48c77ee68993d587cdfdb1feb7 upstream.

Due to copy-paste fail, MIPI_BKLT_EN_1 would always use PPS index 1,
never 0. Fix the sloppiest commit in recent memory.

Fixes: 963bbdb32b47 ("drm/i915/dsi: add support for ICL+ native MIPI GPIO sequence")
Reported-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Reviewed-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20221220140105.313333-1-jani.nikula@intel.com
(cherry picked from commit a561933c571798868b5fa42198427a7e6df56c09)
Cc: stable@vger.kernel.org # 6.1
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/display/intel_dsi_vbt.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/i915/display/intel_dsi_vbt.c
+++ b/drivers/gpu/drm/i915/display/intel_dsi_vbt.c
@@ -430,7 +430,7 @@ static void icl_native_gpio_set_value(st
 		break;
 	case MIPI_BKLT_EN_1:
 	case MIPI_BKLT_EN_2:
-		index = gpio == MIPI_AVDD_EN_1 ? 0 : 1;
+		index = gpio == MIPI_BKLT_EN_1 ? 0 : 1;
 
 		intel_de_rmw(dev_priv, PP_CONTROL(index), EDP_BLC_ENABLE,
 			     value ? EDP_BLC_ENABLE : 0);


