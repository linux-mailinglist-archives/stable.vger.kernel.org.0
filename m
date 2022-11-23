Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BDF496357D4
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 10:47:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238177AbiKWJoQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 04:44:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237988AbiKWJnx (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 04:43:53 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79FD01F9E7
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 01:41:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2CCBAB81E5E
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 09:41:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55984C433C1;
        Wed, 23 Nov 2022 09:41:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669196501;
        bh=EuzErssSyHjynzOKeKg6p5l3yLMRR0f+GKAXW2NIwjY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k8qzsJzZ/b6zheghuBoSXoIeB7XIDl5xe7AElsewl56YZwfYWIvxCYKPy0l+erJEu
         E8599I+kAcSCJWaNkGk8yveTAz/ZSTDivvq0TqjLb50HU8VC6TbAdRc9H4WoxUWxi3
         /CMo0xGqOVWdTR58B8v9pn9Mfp2l6mH/8n93nUAc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Mark Broadworth <mark.broadworth@amd.com>,
        Martin Leung <Martin.Leung@amd.com>, Jun Lei <Jun.Lei@amd.com>,
        Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>,
        Alvin Lee <Alvin.Lee2@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 050/314] drm/amd/display: Enable timing sync on DCN32
Date:   Wed, 23 Nov 2022 09:48:15 +0100
Message-Id: <20221123084627.777704624@linuxfoundation.org>
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

From: Alvin Lee <Alvin.Lee2@amd.com>

[ Upstream commit c3d3f35b725bf9c93bec6d3c056f6bb7cfd27403 ]

Missed enabling timing sync on DCN32 because DCN32 has a different DML
param.

Tested-by: Mark Broadworth <mark.broadworth@amd.com>
Reviewed-by: Martin Leung <Martin.Leung@amd.com>
Reviewed-by: Jun Lei <Jun.Lei@amd.com>
Acked-by: Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
Signed-off-by: Alvin Lee <Alvin.Lee2@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dml/dcn20/dcn20_fpu.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/amd/display/dc/dml/dcn20/dcn20_fpu.c b/drivers/gpu/drm/amd/display/dc/dml/dcn20/dcn20_fpu.c
index d34e0f1314d9..bc4f48ea8d4c 100644
--- a/drivers/gpu/drm/amd/display/dc/dml/dcn20/dcn20_fpu.c
+++ b/drivers/gpu/drm/amd/display/dc/dml/dcn20/dcn20_fpu.c
@@ -1228,6 +1228,7 @@ int dcn20_populate_dml_pipes_from_context(
 		pipes[pipe_cnt].pipe.src.dcc = false;
 		pipes[pipe_cnt].pipe.src.dcc_rate = 1;
 		pipes[pipe_cnt].pipe.dest.synchronized_vblank_all_planes = synchronized_vblank;
+		pipes[pipe_cnt].pipe.dest.synchronize_timings = synchronized_vblank;
 		pipes[pipe_cnt].pipe.dest.hblank_start = timing->h_total - timing->h_front_porch;
 		pipes[pipe_cnt].pipe.dest.hblank_end = pipes[pipe_cnt].pipe.dest.hblank_start
 				- timing->h_addressable
-- 
2.35.1



