Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75D8E603D34
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 11:00:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232035AbiJSJAA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 05:00:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231992AbiJSI6Q (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 04:58:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E30725FAED;
        Wed, 19 Oct 2022 01:53:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0D5C261834;
        Wed, 19 Oct 2022 08:48:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F88AC433B5;
        Wed, 19 Oct 2022 08:48:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666169310;
        bh=cDOXYXPCFgwK64MHs+P8Q2nfkLntiNLPYeF7r5+rXB0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kEON4Qz2tTPJmE12babjZSEv6QaWYGJdG8WzzzgVPps7rTuvoAvrPLcrvEh6u1EZd
         yqq7jVeI/BH92mEe/8tJXx3sdOWytFSeJsCwR1bPnrDlQngKoa+Pa+y5S/shQrSbTo
         LTnqieiV6aOQyUu+6+gKPztQ95+PaQRpukn+OUmU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Roman Li <roman.li@amd.com>,
        Nicholas Kazlauskas <Nicholas.Kazlauskas@amd.com>,
        Mario Limonciello <mario.limonciello@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.0 194/862] drm/amd/display: Enable dpia support for dcn314
Date:   Wed, 19 Oct 2022 10:24:41 +0200
Message-Id: <20221019083258.555290105@linuxfoundation.org>
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

From: Roman Li <roman.li@amd.com>

commit f6aa84b83aee629fbbbc4ea16c2c142caf920d5a upstream.

[Why]
DCN 3.1.4 supports DPIA.

[How]
 - Set dpia_supported flag for dcn314 in dmub_hw_init()
 - Remove comment that becomes irrelevant after this change.

Signed-off-by: Roman Li <roman.li@amd.com>
Reviewed-by: Nicholas Kazlauskas <Nicholas.Kazlauskas@amd.com>
Reviewed-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org # 6.0.x
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -1109,7 +1109,8 @@ static int dm_dmub_hw_init(struct amdgpu
 		hw_params.fb[i] = &fb_info->fb[i];
 
 	switch (adev->ip_versions[DCE_HWIP][0]) {
-	case IP_VERSION(3, 1, 3): /* Only for this asic hw internal rev B0 */
+	case IP_VERSION(3, 1, 3):
+	case IP_VERSION(3, 1, 4):
 		hw_params.dpia_supported = true;
 		hw_params.disable_dpia = adev->dm.dc->debug.dpia_debug.bits.disable_dpia;
 		break;


