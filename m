Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 29B495F9989
	for <lists+stable@lfdr.de>; Mon, 10 Oct 2022 09:14:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232388AbiJJHOG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Oct 2022 03:14:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232152AbiJJHNe (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Oct 2022 03:13:34 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF5A15EDD1;
        Mon, 10 Oct 2022 00:09:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E4F81B80E5D;
        Mon, 10 Oct 2022 07:08:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F4B9C433D6;
        Mon, 10 Oct 2022 07:08:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1665385738;
        bh=CI2x29Kh96i4pZ8HOsJ5fJRoVt7QxvZwLaxm9zV61KA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G51x2CyiQ5JJSczSOclEJ/2fbSeSt6UTeJ3IwWXpGiOvfH6gEi43tTF751/60c2Tm
         cq/UKXIOlUFDKsnyUJmpsydilDNe+5vz98xsHsyR1WnOwRTBaxMQZRJAP6bXogCa+S
         kj9I/2b3w4Frm0Eg0SdXfyyrDs2agK5xamg+WG2M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Dmytro Laktyushkin <Dmytro.Laktyushkin@amd.com>,
        Wayne Lin <wayne.lin@amd.com>, Hugo Hu <hugo.hu@amd.com>,
        Daniel Wheeler <daniel.wheeler@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 26/37] drm/amd/display: update gamut remap if plane has changed
Date:   Mon, 10 Oct 2022 09:05:45 +0200
Message-Id: <20221010070331.970858371@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221010070331.211113813@linuxfoundation.org>
References: <20221010070331.211113813@linuxfoundation.org>
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

From: Hugo Hu <hugo.hu@amd.com>

[ Upstream commit 52bb21499cf54fa65b56d97cd0d68579c90207dd ]

[Why]
The desktop plane and full-screen game plane may have different
gamut remap coefficients, if switching between desktop and
full-screen game without updating the gamut remap will cause
incorrect color.

[How]
Update gamut remap if planes change.

Reviewed-by: Dmytro Laktyushkin <Dmytro.Laktyushkin@amd.com>
Acked-by: Wayne Lin <wayne.lin@amd.com>
Signed-off-by: Hugo Hu <hugo.hu@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c b/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c
index 9f8d7f92300b..0de1bbbabf9a 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c
@@ -1513,6 +1513,7 @@ static void dcn20_update_dchubp_dpp(
 	/* Any updates are handled in dc interface, just need
 	 * to apply existing for plane enable / opp change */
 	if (pipe_ctx->update_flags.bits.enable || pipe_ctx->update_flags.bits.opp_changed
+			|| pipe_ctx->update_flags.bits.plane_changed
 			|| pipe_ctx->stream->update_flags.bits.gamut_remap
 			|| pipe_ctx->stream->update_flags.bits.out_csc) {
 		/* dpp/cm gamut remap*/
-- 
2.35.1



