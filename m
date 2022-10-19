Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7FC2603CD9
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 10:53:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231646AbiJSIxE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 04:53:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231631AbiJSIwf (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 04:52:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF8D510DD;
        Wed, 19 Oct 2022 01:50:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AE38C6174E;
        Wed, 19 Oct 2022 08:48:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0EBBC433C1;
        Wed, 19 Oct 2022 08:48:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666169326;
        bh=E8K2O0dMkobnDwehst82URM/QgRsMeOSGBHxTus3uzE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=flTulYrbVbounvjNRF/mCmx6vwaeF8XK334nPaB8J6gBhcRSYxxIU2TFj9FfRoyfu
         06++ixfvDsReX0iGMMlH97/+bLS9QhoqcrrSC8BigzDqxeAStG9yD3q5FB7Tv6bR5G
         tOKsOaxcyXOwgr2P6Owd/o8Gk3PB+om5cAcQXfpA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Shirish S <shirish.s@amd.com>,
        Leo Li <sunpeng.li@amd.com>,
        Mario Limonciello <mario.limonciello@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.0 198/862] drm/amd/display: explicitly disable psr_feature_enable appropriately
Date:   Wed, 19 Oct 2022 10:24:45 +0200
Message-Id: <20221019083258.748901590@linuxfoundation.org>
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

From: Shirish S <shirish.s@amd.com>

commit 6094b9136ca9038b61e9c4b5d25cd5512ce50b34 upstream.

[Why]
If psr_feature_enable is set to true by default, it continues to be enabled
for non capable links.

[How]
explicitly disable the feature on links that are not capable of the same.

Fixes: 8c322309e48e9 ("drm/amd/display: Enable PSR")
Signed-off-by: Shirish S <shirish.s@amd.com>
Reviewed-by: Leo Li <sunpeng.li@amd.com>
Reviewed-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org # 5.15+
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_psr.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_psr.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_psr.c
@@ -60,11 +60,15 @@ static bool link_supports_psrsu(struct d
  */
 void amdgpu_dm_set_psr_caps(struct dc_link *link)
 {
-	if (!(link->connector_signal & SIGNAL_TYPE_EDP))
+	if (!(link->connector_signal & SIGNAL_TYPE_EDP)) {
+		link->psr_settings.psr_feature_enabled = false;
 		return;
+	}
 
-	if (link->type == dc_connection_none)
+	if (link->type == dc_connection_none) {
+		link->psr_settings.psr_feature_enabled = false;
 		return;
+	}
 
 	if (link->dpcd_caps.psr_info.psr_version == 0) {
 		link->psr_settings.psr_version = DC_PSR_VERSION_UNSUPPORTED;


