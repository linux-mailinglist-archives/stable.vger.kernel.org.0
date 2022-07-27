Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A84F582F4F
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 19:23:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241726AbiG0RXH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 13:23:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241932AbiG0RVt (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 13:21:49 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7935D5F119;
        Wed, 27 Jul 2022 09:45:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D7FFFB821C6;
        Wed, 27 Jul 2022 16:45:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 484F7C433D7;
        Wed, 27 Jul 2022 16:45:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658940316;
        bh=q+ehiNDbz3MqQd5JBHu7bhdKpk+g3BTj6YabfJtgHlM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qL6x2LW/UjwPKIFOBPddvTiYv2Nk8eIz0LPwy7L7OquYuOSSIgCUzeCEJcmmTCFIv
         Ekv7uvpn5p3jfDfaU3fhkdGQ8QZiQabUFGtN5Cd9mBWzrrmZS7+To8MX15K8ajG57K
         aTupOSs6W+cGzu966wF2YOt8OOWykT+6EAgeLe80=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Aurabindo Jayamohanan Pillai <Aurabindo.Pillai@amd.com>,
        Pavle Kotarac <Pavle.Kotarac@amd.com>,
        Daniel Wheeler <daniel.wheeler@amd.com>,
        Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        "Limonciello, Mario" <Mario.Limonciello@amd.com>
Subject: [PATCH 5.15 182/201] drm/amd/display: Reset DMCUB before HW init
Date:   Wed, 27 Jul 2022 18:11:26 +0200
Message-Id: <20220727161035.332980447@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220727161026.977588183@linuxfoundation.org>
References: <20220727161026.977588183@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>

commit 791255ca9fbe38042cfd55df5deb116dc11fef18 upstream.

[Why]
If the firmware wasn't reset by PSP or HW and is currently running
then the firmware will hang or perform underfined behavior when we
modify its firmware state underneath it.

[How]
Reset DMCUB before setting up cache windows and performing HW init.

Reviewed-by: Aurabindo Jayamohanan Pillai <Aurabindo.Pillai@amd.com>
Acked-by: Pavle Kotarac <Pavle.Kotarac@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: "Limonciello, Mario" <Mario.Limonciello@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -1028,6 +1028,11 @@ static int dm_dmub_hw_init(struct amdgpu
 		return 0;
 	}
 
+	/* Reset DMCUB if it was previously running - before we overwrite its memory. */
+	status = dmub_srv_hw_reset(dmub_srv);
+	if (status != DMUB_STATUS_OK)
+		DRM_WARN("Error resetting DMUB HW: %d\n", status);
+
 	hdr = (const struct dmcub_firmware_header_v1_0 *)dmub_fw->data;
 
 	fw_inst_const = dmub_fw->data +


