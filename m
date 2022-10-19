Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 15DF2603DCC
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 11:06:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232292AbiJSJGo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 05:06:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232304AbiJSJFa (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 05:05:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9305B274B;
        Wed, 19 Oct 2022 01:59:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E969661750;
        Wed, 19 Oct 2022 08:48:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F3AFC43143;
        Wed, 19 Oct 2022 08:48:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666169331;
        bh=5gG5OYn6m9YYIFvq/8qqrUumeeDPEJAt9vcV/QsLf18=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xcJd+epDVYm2QGBxRMOO+JF2x05YHCCY7zGOLDKc6AqoqL4TR/+03WPgO5yH/kMTY
         vt6xDzmoJdLSJywj2SwfaA2lF/nF5uNIwWDKrXMuO6AjYzdyaOvQyB6g9QvFtvKWEJ
         U0hoTiVF/d3SONDTQ5m9NwjROryXa6LhcThJZFMM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Wheeler <daniel.wheeler@amd.com>,
        Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>,
        Qingqing Zhuo <qingqing.zhuo@amd.com>,
        Alvin Lee <Alvin.Lee2@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.0 190/862] drm/amd/display: Fix watermark calculation
Date:   Wed, 19 Oct 2022 10:24:37 +0200
Message-Id: <20221019083258.376837892@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alvin Lee <Alvin.Lee2@amd.com>

commit 9799702360d51a714e888fef4ab5fb9123dfb41f upstream.

Watermark calculation was incorrect due to missing brackets.

Fixes: 85f4bc0c333c ("drm/amd/display: Add SubVP required code")
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Reviewed-by: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
Acked-by: Qingqing Zhuo <qingqing.zhuo@amd.com>
Signed-off-by: Alvin Lee <Alvin.Lee2@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org # 6.0
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/dc_dmub_srv.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/display/dc/dc_dmub_srv.c
+++ b/drivers/gpu/drm/amd/display/dc/dc_dmub_srv.c
@@ -719,7 +719,7 @@ void dc_dmub_setup_subvp_dmub_command(st
 		// Store the original watermark value for this SubVP config so we can lower it when the
 		// MCLK switch starts
 		wm_val_refclk = context->bw_ctx.bw.dcn.watermarks.a.cstate_pstate.pstate_change_ns *
-				dc->res_pool->ref_clocks.dchub_ref_clock_inKhz / 1000 / 1000;
+				(dc->res_pool->ref_clocks.dchub_ref_clock_inKhz / 1000) / 1000;
 
 		cmd.fw_assisted_mclk_switch_v2.config_data.watermark_a_cache = wm_val_refclk < 0xFFFF ? wm_val_refclk : 0xFFFF;
 	}


