Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC0596C19CE
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 16:38:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233037AbjCTPiW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 11:38:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233225AbjCTPiB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 11:38:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD76B1ABD5
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 08:29:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8D4DA61591
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 15:29:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99612C433D2;
        Mon, 20 Mar 2023 15:29:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1679326173;
        bh=NB1Q7IulvQPniPP+4NCmMV/y61f7GD5w4fbuVKrTEzc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fkGBQX/lf1H7EzOYBtaWcaHz5alkrvjjUFZkOt8B+AOIPS3zzd+c2F8oesMiMViIb
         Pgku7HhG7i56VJzvsG5NMW4nrE3OLvlLeC1gpsEPU1gRdfCqkQ1wakwC8CvAvu26kL
         pPzRGD+b4nAgCx1BK/X3e1kRth0OeIaDB0cFlYo4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Mario Limonciello <mario.limonciello@amd.com>,
        Jun Lei <Jun.Lei@amd.com>,
        Qingqing Zhuo <qingqing.zhuo@amd.com>,
        Wesley Chalmers <Wesley.Chalmers@amd.com>,
        Daniel Wheeler <daniel.wheeler@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.2 170/211] drm/amd/display: Do not set DRR on pipe Commit
Date:   Mon, 20 Mar 2023 15:55:05 +0100
Message-Id: <20230320145520.564490628@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230320145513.305686421@linuxfoundation.org>
References: <20230320145513.305686421@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wesley Chalmers <Wesley.Chalmers@amd.com>

commit 56574f89dbd84004c3fd6485bcaafb5aa9b8be14 upstream.

[WHY]
Writing to DRR registers such as OTG_V_TOTAL_MIN on the same frame as a
pipe commit can cause underflow.

Cc: stable@vger.kernel.org
Cc: Mario Limonciello <mario.limonciello@amd.com>
Reviewed-by: Jun Lei <Jun.Lei@amd.com>
Acked-by: Qingqing Zhuo <qingqing.zhuo@amd.com>
Signed-off-by: Wesley Chalmers <Wesley.Chalmers@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/dcn30/dcn30_hwseq.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/drivers/gpu/drm/amd/display/dc/dcn30/dcn30_hwseq.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn30/dcn30_hwseq.c
@@ -992,8 +992,5 @@ void dcn30_prepare_bandwidth(struct dc *
 			dc->clk_mgr->funcs->set_max_memclk(dc->clk_mgr, dc->clk_mgr->bw_params->clk_table.entries[dc->clk_mgr->bw_params->clk_table.num_entries - 1].memclk_mhz);
 
 	dcn20_prepare_bandwidth(dc, context);
-
-	dc_dmub_srv_p_state_delegate(dc,
-		context->bw_ctx.bw.dcn.clk.fw_based_mclk_switching, context);
 }
 


