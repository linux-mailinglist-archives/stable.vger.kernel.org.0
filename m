Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6C0563588D
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 11:00:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237010AbiKWKAa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 05:00:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237015AbiKWJ7e (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 04:59:34 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B932011A70D
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 01:52:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5997A61B95
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 09:52:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46EACC433D6;
        Wed, 23 Nov 2022 09:52:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669197162;
        bh=WO33uot3OR3TvqZxOp92NKrN7EgmYPBU7TzJwPjhVyk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=h8wE1mMDLABN9rXm7A8aC3yrqZcOnNWmvyo+rNsiMnOKl8wnEheh2TcfKyJ07A+zg
         fLRW7f21lWNWaASg+joa94RPHPhfHukqkRmRu8QNhy7JULlIGRMGXLMzxlRJRxYWk+
         7btc5yv+d5XMfa9FQ/8TNgPrfZFcMC0lE2cRj+bU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Wayne Lin <Wayne.Lin@amd.com>,
        Tom Chung <chiahsuan.chung@amd.com>,
        Stylon Wang <stylon.wang@amd.com>,
        Daniel Wheeler <daniel.wheeler@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.0 216/314] drm/amd/display: Fix access timeout to DPIA AUX at boot time
Date:   Wed, 23 Nov 2022 09:51:01 +0100
Message-Id: <20221123084635.331988949@linuxfoundation.org>
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

From: Stylon Wang <stylon.wang@amd.com>

commit 0d502ef8898b3983eef9e40f50dfe100a0de5d93 upstream.

[Why]
Since introduction of patch "Query DPIA HPD status.", link detection at
boot could be accessing DPIA AUX, which will not succeed until
DMUB outbox messaging is enabled and results in below dmesg logs:

[  160.840227] [drm:amdgpu_dm_process_dmub_aux_transfer_sync [amdgpu]] *ERROR* wait_for_completion_timeout timeout!

[How]
Enable DMUB outbox messaging before link detection at boot time.

Reviewed-by: Wayne Lin <Wayne.Lin@amd.com>
Acked-by: Tom Chung <chiahsuan.chung@amd.com>
Signed-off-by: Stylon Wang <stylon.wang@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org # 6.0.x
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -1645,12 +1645,6 @@ static int amdgpu_dm_init(struct amdgpu_
 		}
 	}
 
-	if (amdgpu_dm_initialize_drm_device(adev)) {
-		DRM_ERROR(
-		"amdgpu: failed to initialize sw for display support.\n");
-		goto error;
-	}
-
 	/* Enable outbox notification only after IRQ handlers are registered and DMUB is alive.
 	 * It is expected that DMUB will resend any pending notifications at this point, for
 	 * example HPD from DPIA.
@@ -1658,6 +1652,12 @@ static int amdgpu_dm_init(struct amdgpu_
 	if (dc_is_dmub_outbox_supported(adev->dm.dc))
 		dc_enable_dmub_outbox(adev->dm.dc);
 
+	if (amdgpu_dm_initialize_drm_device(adev)) {
+		DRM_ERROR(
+		"amdgpu: failed to initialize sw for display support.\n");
+		goto error;
+	}
+
 	/* create fake encoders for MST */
 	dm_dp_create_fake_mst_encoders(adev);
 


