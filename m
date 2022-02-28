Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 446E04C74D0
	for <lists+stable@lfdr.de>; Mon, 28 Feb 2022 18:48:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236944AbiB1Rsi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Feb 2022 12:48:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238858AbiB1Rrq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Feb 2022 12:47:46 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08D329F3BD;
        Mon, 28 Feb 2022 09:38:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9D83DB815BE;
        Mon, 28 Feb 2022 17:38:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8EFCC340E7;
        Mon, 28 Feb 2022 17:38:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646069891;
        bh=H4bCPBLG7fxRFwWOWxzj2fIKxJazT6R4qsz8GJmb+dM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2YXX8ZKZfkFYIZ+JmwuBmJuGYJ2kKJB/EvXKW1m4YVj0KNRxixZYP/GdZG/UOgyZt
         RO8CDc5vXzYlER5eYxAICipDc8rX02d2elcb/l9MAmEcdfQevBj1PjBxY1Z8rvQzFv
         bPDs6h4bWml2CJaO4Jw4TjSuCrHeJ7hypT6hsT4E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Evan Quan <evan.quan@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.15 016/139] drm/amd/pm: fix some OEM SKU specific stability issues
Date:   Mon, 28 Feb 2022 18:23:10 +0100
Message-Id: <20220228172349.397553169@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220228172347.614588246@linuxfoundation.org>
References: <20220228172347.614588246@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Evan Quan <evan.quan@amd.com>

commit e3f3824874da78db5775a5cb9c0970cd1c6978bc upstream.

Add a quirk in sienna_cichlid_ppt.c to fix some OEM SKU
specific stability issues.

Signed-off-by: Evan Quan <evan.quan@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/pm/swsmu/smu11/sienna_cichlid_ppt.c |   32 +++++++++++++++-
 1 file changed, 31 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/pm/swsmu/smu11/sienna_cichlid_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu11/sienna_cichlid_ppt.c
@@ -418,6 +418,36 @@ static int sienna_cichlid_store_powerpla
 	return 0;
 }
 
+static int sienna_cichlid_patch_pptable_quirk(struct smu_context *smu)
+{
+	struct amdgpu_device *adev = smu->adev;
+	uint32_t *board_reserved;
+	uint16_t *freq_table_gfx;
+	uint32_t i;
+
+	/* Fix some OEM SKU specific stability issues */
+	GET_PPTABLE_MEMBER(BoardReserved, &board_reserved);
+	if ((adev->pdev->device == 0x73DF) &&
+	    (adev->pdev->revision == 0XC3) &&
+	    (adev->pdev->subsystem_device == 0x16C2) &&
+	    (adev->pdev->subsystem_vendor == 0x1043))
+		board_reserved[0] = 1387;
+
+	GET_PPTABLE_MEMBER(FreqTableGfx, &freq_table_gfx);
+	if ((adev->pdev->device == 0x73DF) &&
+	    (adev->pdev->revision == 0XC3) &&
+	    ((adev->pdev->subsystem_device == 0x16C2) ||
+	    (adev->pdev->subsystem_device == 0x133C)) &&
+	    (adev->pdev->subsystem_vendor == 0x1043)) {
+		for (i = 0; i < NUM_GFXCLK_DPM_LEVELS; i++) {
+			if (freq_table_gfx[i] > 2500)
+				freq_table_gfx[i] = 2500;
+		}
+	}
+
+	return 0;
+}
+
 static int sienna_cichlid_setup_pptable(struct smu_context *smu)
 {
 	int ret = 0;
@@ -438,7 +468,7 @@ static int sienna_cichlid_setup_pptable(
 	if (ret)
 		return ret;
 
-	return ret;
+	return sienna_cichlid_patch_pptable_quirk(smu);
 }
 
 static int sienna_cichlid_tables_init(struct smu_context *smu)


