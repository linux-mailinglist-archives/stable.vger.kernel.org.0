Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C2A0600177
	for <lists+stable@lfdr.de>; Sun, 16 Oct 2022 18:51:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229607AbiJPQvs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 16 Oct 2022 12:51:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229577AbiJPQvs (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 16 Oct 2022 12:51:48 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95A1D2F3AF
        for <stable@vger.kernel.org>; Sun, 16 Oct 2022 09:51:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4CB22B80D2C
        for <stable@vger.kernel.org>; Sun, 16 Oct 2022 16:51:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93C21C433C1;
        Sun, 16 Oct 2022 16:51:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1665939104;
        bh=xf27z6xumqRXIMJ6FEEb6SdfxZmzfP3VsJ5L/t/gls0=;
        h=Subject:To:Cc:From:Date:From;
        b=Tu8652Ybuv5IQ3gxu/4Hmi+HjRG1zgwA1/sthoQVKSTg8TJ62dAQqIJv6SfzejdMT
         TsEcGaLI6U8KdqjH2733Sf1YH8P2tusMG2Z+NtNEIuiKe1yOzUCw3wPWSO85psBDH9
         2ewezp+WhJrugvzSvNf1s+jC5cDcye2wctqm3n84=
Subject: FAILED: patch "[PATCH] drm/amd/display: explicitly disable psr_feature_enable" failed to apply to 5.15-stable tree
To:     shirish.s@amd.com, alexander.deucher@amd.com,
        mario.limonciello@amd.com, sunpeng.li@amd.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 16 Oct 2022 18:52:30 +0200
Message-ID: <1665939150194195@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

6094b9136ca9 ("drm/amd/display: explicitly disable psr_feature_enable appropriately")
cd9a0d026baa ("drm/amd/display: parse and check PSR SU caps")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 6094b9136ca9038b61e9c4b5d25cd5512ce50b34 Mon Sep 17 00:00:00 2001
From: Shirish S <shirish.s@amd.com>
Date: Fri, 7 Oct 2022 20:31:49 +0530
Subject: [PATCH] drm/amd/display: explicitly disable psr_feature_enable
 appropriately

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

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_psr.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_psr.c
index 8ca10ab3dfc1..26291db0a3cf 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_psr.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_psr.c
@@ -60,11 +60,15 @@ static bool link_supports_psrsu(struct dc_link *link)
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

