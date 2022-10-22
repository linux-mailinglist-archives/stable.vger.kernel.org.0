Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E3CA9608AC9
	for <lists+stable@lfdr.de>; Sat, 22 Oct 2022 11:07:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232762AbiJVJHC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Oct 2022 05:07:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232428AbiJVJGr (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Oct 2022 05:06:47 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03C71158D6E;
        Sat, 22 Oct 2022 01:20:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 39A2FB82DF9;
        Sat, 22 Oct 2022 08:03:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F9F5C433C1;
        Sat, 22 Oct 2022 08:03:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666425823;
        bh=/qVHldP64B5xa9jg2xsijaphwXXl0NsLnQSVOzxEN8M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cz/sK5rVf+IRaMiroYqeXqcwJC4AdjoZjz77L/CuzdEc4tvYpxbbh7riYW19lEWoO
         l5Gtpb2hu1d1mUh1Fkq3aZZ97LOVPrDqeCW+cs6eq+3f/OXfamAbAmXCx5DBEwFQ5K
         FGV8hVSlTLn8pmVQlSOyrp09HBTxF5aJRatQINwc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Charlene Liu <Charlene.Liu@amd.com>,
        Wayne Lin <wayne.lin@amd.com>, Sherry Wang <Yao.Wang1@amd.com>,
        Daniel Wheeler <daniel.wheeler@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 620/717] drm/amd/display: correct hostvm flag
Date:   Sat, 22 Oct 2022 09:28:19 +0200
Message-Id: <20221022072525.887022856@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221022072415.034382448@linuxfoundation.org>
References: <20221022072415.034382448@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
index 3d9f07d4770b..8a0de6bfc716 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn31/dcn31_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn31/dcn31_resource.c
@@ -892,7 +892,7 @@ static const struct dc_debug_options debug_defaults_drv = {
 	.enable_sw_cntl_psr = true,
 	.apply_vendor_specific_lttpr_wa = true,
 	.enable_z9_disable_interface = true, /* Allow support for the PMFW interface for disable Z9*/
-	.dml_hostvm_override = DML_HOSTVM_OVERRIDE_FALSE,
+	.dml_hostvm_override = DML_HOSTVM_NO_OVERRIDE,
 };
 
 static const struct dc_debug_options debug_defaults_diags = {
-- 
2.35.1



