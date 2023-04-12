Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE8876DEFE3
	for <lists+stable@lfdr.de>; Wed, 12 Apr 2023 10:55:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231467AbjDLIzI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Apr 2023 04:55:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231474AbjDLIzE (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Apr 2023 04:55:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0A0BA24C
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 01:54:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6EC0363161
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 08:54:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F883C433D2;
        Wed, 12 Apr 2023 08:54:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681289647;
        bh=O8oipHqa4SLp2zO5euLxaYWIw4kYIte7nZpnI8gAgdw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TZ64KkGT2TvxQnarOh074gG5RgH3LuQg2n3a1ikrUDXxt8ORtlOCAEcEAl+K3ivrp
         cMpKe5Ef3GssPetV62q0rYTH8hC77u66Hz464BGwg35eSttR7tWUyibWwIrFjh0Pyo
         3SbajQsmm34PKjEyCQM7malRI1ntTsR5K6Xk07uI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Tim Huang <tim.huang@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Mario Limonciello <mario.limonciello@amd.com>
Subject: [PATCH 6.2 158/173] drm/amdgpu: skip psp suspend for IMU enabled ASICs mode2 reset
Date:   Wed, 12 Apr 2023 10:34:44 +0200
Message-Id: <20230412082844.505619976@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230412082838.125271466@linuxfoundation.org>
References: <20230412082838.125271466@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tim Huang <tim.huang@amd.com>

commit e11c775030c5585370fda43035204bb5fa23b139 upstream.

The psp suspend & resume should be skipped to avoid destroy
the TMR and reload FWs again for IMU enabled APU ASICs.

Signed-off-by: Tim Huang <tim.huang@amd.com>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Reviewed-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -3051,6 +3051,18 @@ static int amdgpu_device_ip_suspend_phas
 		    (adev->ip_blocks[i].version->type == AMD_IP_BLOCK_TYPE_SDMA))
 			continue;
 
+		/* Once swPSP provides the IMU, RLC FW binaries to TOS during cold-boot.
+		 * These are in TMR, hence are expected to be reused by PSP-TOS to reload
+		 * from this location and RLC Autoload automatically also gets loaded
+		 * from here based on PMFW -> PSP message during re-init sequence.
+		 * Therefore, the psp suspend & resume should be skipped to avoid destroy
+		 * the TMR and reload FWs again for IMU enabled APU ASICs.
+		 */
+		if (amdgpu_in_reset(adev) &&
+		    (adev->flags & AMD_IS_APU) && adev->gfx.imu.funcs &&
+		    adev->ip_blocks[i].version->type == AMD_IP_BLOCK_TYPE_PSP)
+			continue;
+
 		/* XXX handle errors */
 		r = adev->ip_blocks[i].version->funcs->suspend(adev);
 		/* XXX handle errors */


