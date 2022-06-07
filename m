Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3FA6E5417F5
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 23:07:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378662AbiFGVHJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 17:07:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378838AbiFGVEc (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 17:04:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71C7BB2EAB;
        Tue,  7 Jun 2022 11:48:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0CA916156D;
        Tue,  7 Jun 2022 18:48:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 142C4C36B0C;
        Tue,  7 Jun 2022 18:48:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654627738;
        bh=cz7EaM8E2HHkUwPlijx0Xy7QFc9ala/dWiZQqSjozhk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R0hYTOhIkPRpolN+KjXM/JowZCtGVpu9vam4TcjRAnsMLXUYW3UhSk2k4GiE2onPJ
         CM1/xjri7hrGi87tzk4G5UJGPfIFpC3MWG62Ds2I3PCPwigaZxLR/ofWZKJMlRvtjr
         3nxEEgxX1LqRsGNCYRWy6QUZzF0ih8sHUn+z13BI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Yang <Eric.Yang2@amd.com>,
        Pavle Kotarac <Pavle.Kotarac@amd.com>,
        Saaem Rizvi <syerizvi@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 076/879] drm/amd/display: Disabling Z10 on DCN31
Date:   Tue,  7 Jun 2022 18:53:14 +0200
Message-Id: <20220607165004.896958794@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607165002.659942637@linuxfoundation.org>
References: <20220607165002.659942637@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Saaem Rizvi <syerizvi@amd.com>

[ Upstream commit 5d5af34072c8b11f60960c3bea57ff9de5877791 ]

[WHY]
Z10 is should not be enabled by default on DCN31.

[HOW]
Using DC debug flags to disable Z10 by default on DCN31.

Reviewed-by: Eric Yang <Eric.Yang2@amd.com>
Acked-by: Pavle Kotarac <Pavle.Kotarac@amd.com>
Signed-off-by: Saaem Rizvi <syerizvi@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dcn31/dcn31_resource.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/amd/display/dc/dcn31/dcn31_resource.c b/drivers/gpu/drm/amd/display/dc/dcn31/dcn31_resource.c
index 63934ecf6be8..d71e625cc476 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn31/dcn31_resource.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn31/dcn31_resource.c
@@ -1030,6 +1030,7 @@ static const struct dc_debug_options debug_defaults_drv = {
 			.afmt = true,
 		}
 	},
+	.disable_z10 = true,
 	.optimize_edp_link_rate = true,
 	.enable_sw_cntl_psr = true,
 	.apply_vendor_specific_lttpr_wa = true,
-- 
2.35.1



