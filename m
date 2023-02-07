Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 48F3D68D86A
	for <lists+stable@lfdr.de>; Tue,  7 Feb 2023 14:09:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232294AbjBGNJ2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Feb 2023 08:09:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232297AbjBGNJ0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Feb 2023 08:09:26 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0287739CE6
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 05:08:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4525C61358
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 13:08:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BE0FC433EF;
        Tue,  7 Feb 2023 13:08:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675775318;
        bh=BEJTXGqRbs7yCdMe6OhyYguAqRZkCHXtvdFzmUGvx7I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LcRVVc3j3U9VRGSj6mmx4pyjzokdUxgcp574h+Q6lptesE9RJYIR411VhLnO0ldgg
         zEHhuHFUQ4QLvK5y2YiJJQVyLw21jCqEOtHk44iME/Wm/rnTRghlqLWDeZ9WjQEWup
         QVLgdbDQsxNjcjj6Y3ft+QrFDB7gdjzkl0bTkicE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Natikar Basavaraj <Basavaraj.Natikar@amd.com>,
        Satyanarayana ReddyTVN <Satyanarayana.ReddyTVN@amd.com>,
        Rutvij Gajjar <Rutvij.Gajjar@amd.com>,
        Mario Limonciello <mario.limonciello@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.1 181/208] drm/amd: Fix initialization for nbio 4.3.0
Date:   Tue,  7 Feb 2023 13:57:15 +0100
Message-Id: <20230207125642.663886072@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230207125634.292109991@linuxfoundation.org>
References: <20230207125634.292109991@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mario Limonciello <mario.limonciello@amd.com>

commit 5048fa1ebf89d03cf0ceca13fab8f800399e9ee3 upstream.

A mistake has been made on some boards with NBIO 4.3.0 where some
NBIO registers aren't properly set by the hardware.

Ensure that they're set during initialization.

Cc: Natikar Basavaraj <Basavaraj.Natikar@amd.com>
Tested-by: Satyanarayana ReddyTVN <Satyanarayana.ReddyTVN@amd.com>
Tested-by: Rutvij Gajjar <Rutvij.Gajjar@amd.com>
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org # 6.1.x
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/nbio_v4_3.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/nbio_v4_3.c b/drivers/gpu/drm/amd/amdgpu/nbio_v4_3.c
index 15eb3658d70e..09fdcd20cb91 100644
--- a/drivers/gpu/drm/amd/amdgpu/nbio_v4_3.c
+++ b/drivers/gpu/drm/amd/amdgpu/nbio_v4_3.c
@@ -337,7 +337,13 @@ const struct nbio_hdp_flush_reg nbio_v4_3_hdp_flush_reg = {
 
 static void nbio_v4_3_init_registers(struct amdgpu_device *adev)
 {
-	return;
+	if (adev->ip_versions[NBIO_HWIP][0] == IP_VERSION(4, 3, 0)) {
+		uint32_t data;
+
+		data = RREG32_SOC15(NBIO, 0, regRCC_DEV0_EPF2_STRAP2);
+		data &= ~RCC_DEV0_EPF2_STRAP2__STRAP_NO_SOFT_RESET_DEV0_F2_MASK;
+		WREG32_SOC15(NBIO, 0, regRCC_DEV0_EPF2_STRAP2, data);
+	}
 }
 
 static u32 nbio_v4_3_get_rom_offset(struct amdgpu_device *adev)
-- 
2.39.1



