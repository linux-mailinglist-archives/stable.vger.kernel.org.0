Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34A8E6584B1
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 18:01:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235304AbiL1RAl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 12:00:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235399AbiL1Q75 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:59:57 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67CFB1C416
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:55:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0761760D41
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:55:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F165C433F1;
        Wed, 28 Dec 2022 16:55:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672246517;
        bh=6hNtsvNtlbAmQhmIbElNYaqU9o3xYRJRWiGhNZj/Uh0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=garzJG9RKib69wClxyECbGAvJVFgPyhvCvt4h9xXI/YLvgiIobYQpKaBpYHQjmAdz
         oTJ1kN0qB5LU7AsXm29CvzFS8/R/+IrtE/Yl1iELzBp89iY3nbANOhL6GuE9t6wRy+
         DdD20b2RnQ+X2UTJlu5xyDgJasHaPNOKtw3oGdic=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Wesley Chalmers <Wesley.Chalmers@amd.com>,
        Tom Chung <chiahsuan.chung@amd.com>,
        Martin Leung <Martin.Leung@amd.com>,
        Daniel Wheeler <daniel.wheeler@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.0 1067/1073] drm/amd/display: revert Disable DRR actions during state commit
Date:   Wed, 28 Dec 2022 15:44:15 +0100
Message-Id: <20221228144357.220813341@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
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

From: Martin Leung <Martin.Leung@amd.com>

commit 6f8816261db9251f2635533572f95ab8e530266c upstream.

why and how:
causes unstable on certain surface format/mpo transitions

This reverts commit de020e5fa9ebc6fc32e82ae6ccb0282451ed937c

Reviewed-by: Wesley Chalmers <Wesley.Chalmers@amd.com>
Acked-by: Tom Chung <chiahsuan.chung@amd.com>
Signed-off-by: Martin Leung <Martin.Leung@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/dcn30/dcn30_hwseq.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/gpu/drm/amd/display/dc/dcn30/dcn30_hwseq.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn30/dcn30_hwseq.c
@@ -973,5 +973,8 @@ void dcn30_prepare_bandwidth(struct dc *
 			dc->clk_mgr->funcs->set_max_memclk(dc->clk_mgr, dc->clk_mgr->bw_params->clk_table.entries[dc->clk_mgr->bw_params->clk_table.num_entries - 1].memclk_mhz);
 
 	dcn20_prepare_bandwidth(dc, context);
+
+	dc_dmub_srv_p_state_delegate(dc,
+		context->bw_ctx.bw.dcn.clk.fw_based_mclk_switching, context);
 }
 


