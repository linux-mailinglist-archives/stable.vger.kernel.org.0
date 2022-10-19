Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5EF9A603F36
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 11:30:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230484AbiJSJaw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 05:30:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229979AbiJSJ1f (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 05:27:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0191EE8C41;
        Wed, 19 Oct 2022 02:12:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 77FB061803;
        Wed, 19 Oct 2022 09:11:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88200C433D7;
        Wed, 19 Oct 2022 09:11:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666170703;
        bh=mX24O1vGgImFyw9AlQ1u4BG7+ZHlcMrj6aWT8XAWarE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=puHbRf9Vrhtb1K1EHUhP+zLBx1GOwtLquqfRVo0FF9yPedRb25V6HZa1vXb9t8483
         IgBWM+0MzA0DNqO9cEoKnG1JSxDA22TR+OWhQumjZStmRFehmKVKgbbHRsaNHvgdby
         lynbFnGimAE3swvVVCT3c0vvpXUwZ+Fa/lHcFIDM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Charlene Liu <Charlene.Liu@amd.com>,
        Wayne Lin <wayne.lin@amd.com>, Sherry Wang <Yao.Wang1@amd.com>,
        Daniel Wheeler <daniel.wheeler@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 756/862] drm/amd/display: correct hostvm flag
Date:   Wed, 19 Oct 2022 10:34:03 +0200
Message-Id: <20221019083323.316707365@linuxfoundation.org>
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

From: Sherry Wang <Yao.Wang1@amd.com>

[ Upstream commit 796d6a37ff5ffaf9f2dc0f3f4bf9f4a1034c00de ]

[Why]
Hostvm should be enabled/disabled accordding to
the status of riommu_active, but hostvm always
be disabled on DCN31 which causes underflow

[How]
Set correct hostvm flag on DCN31

Reviewed-by: Charlene Liu <Charlene.Liu@amd.com>
Acked-by: Wayne Lin <wayne.lin@amd.com>
Signed-off-by: Sherry Wang <Yao.Wang1@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dcn31/dcn31_resource.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dcn31/dcn31_resource.c b/drivers/gpu/drm/amd/display/dc/dcn31/dcn31_resource.c
index aedff18aff56..2e5a21856eee 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn31/dcn31_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn31/dcn31_resource.c
@@ -891,7 +891,7 @@ static const struct dc_debug_options debug_defaults_drv = {
 	.optimize_edp_link_rate = true,
 	.enable_sw_cntl_psr = true,
 	.enable_z9_disable_interface = true, /* Allow support for the PMFW interface for disable Z9*/
-	.dml_hostvm_override = DML_HOSTVM_OVERRIDE_FALSE,
+	.dml_hostvm_override = DML_HOSTVM_NO_OVERRIDE,
 };
 
 static const struct dc_debug_options debug_defaults_diags = {
-- 
2.35.1



