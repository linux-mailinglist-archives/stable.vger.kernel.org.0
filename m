Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 64B21657CE2
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:37:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233907AbiL1PhG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:37:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233910AbiL1PhF (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:37:05 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36B9C15F0F
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:37:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 869D9B81647
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:37:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC4F3C433EF;
        Wed, 28 Dec 2022 15:37:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672241821;
        bh=R5w2tSuKQPyFFf2DN8pOguaXsraKwUDvKIpjTuHbwp8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jUDOL7bui7yow5ihWomefyDDxLdspNA0Vkkcyz4eIuCUMdb4oexqpSHL5uMNpoYas
         nl9LyA4F7zHNVgzZvftskoyxt72RJWcszCS/2K0pqCcioXb4QbqpGITIZv23iSNA1P
         PbL2LRInduln2a2eejRJLXLKuYF0KOfLBVR6li4c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Hanjun Guo <guohanjun@huawei.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0307/1073] drm/radeon: Add the missed acpi_put_table() to fix memory leak
Date:   Wed, 28 Dec 2022 15:31:35 +0100
Message-Id: <20221228144336.347718170@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
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

From: Hanjun Guo <guohanjun@huawei.com>

[ Upstream commit 10276a20be1115e1f76c189330da2992df980eee ]

When the radeon driver reads the bios information from ACPI
table in radeon_acpi_vfct_bios(), it misses to call acpi_put_table()
to release the ACPI memory after the init, so add acpi_put_table()
properly to fix the memory leak.

v2: fix text formatting (Alex)

Fixes: 268ba0a99f89 ("drm/radeon: implement ACPI VFCT vbios fetch (v3)")
Signed-off-by: Hanjun Guo <guohanjun@huawei.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/radeon/radeon_bios.c | 18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff --git a/drivers/gpu/drm/radeon/radeon_bios.c b/drivers/gpu/drm/radeon/radeon_bios.c
index 33121655d50b..1d99c9a2b56e 100644
--- a/drivers/gpu/drm/radeon/radeon_bios.c
+++ b/drivers/gpu/drm/radeon/radeon_bios.c
@@ -612,13 +612,14 @@ static bool radeon_acpi_vfct_bios(struct radeon_device *rdev)
 	acpi_size tbl_size;
 	UEFI_ACPI_VFCT *vfct;
 	unsigned offset;
+	bool r = false;
 
 	if (!ACPI_SUCCESS(acpi_get_table("VFCT", 1, &hdr)))
 		return false;
 	tbl_size = hdr->length;
 	if (tbl_size < sizeof(UEFI_ACPI_VFCT)) {
 		DRM_ERROR("ACPI VFCT table present but broken (too short #1)\n");
-		return false;
+		goto out;
 	}
 
 	vfct = (UEFI_ACPI_VFCT *)hdr;
@@ -631,13 +632,13 @@ static bool radeon_acpi_vfct_bios(struct radeon_device *rdev)
 		offset += sizeof(VFCT_IMAGE_HEADER);
 		if (offset > tbl_size) {
 			DRM_ERROR("ACPI VFCT image header truncated\n");
-			return false;
+			goto out;
 		}
 
 		offset += vhdr->ImageLength;
 		if (offset > tbl_size) {
 			DRM_ERROR("ACPI VFCT image truncated\n");
-			return false;
+			goto out;
 		}
 
 		if (vhdr->ImageLength &&
@@ -649,15 +650,18 @@ static bool radeon_acpi_vfct_bios(struct radeon_device *rdev)
 			rdev->bios = kmemdup(&vbios->VbiosContent,
 					     vhdr->ImageLength,
 					     GFP_KERNEL);
+			if (rdev->bios)
+				r = true;
 
-			if (!rdev->bios)
-				return false;
-			return true;
+			goto out;
 		}
 	}
 
 	DRM_ERROR("ACPI VFCT table present but broken (too short #2)\n");
-	return false;
+
+out:
+	acpi_put_table(hdr);
+	return r;
 }
 #else
 static inline bool radeon_acpi_vfct_bios(struct radeon_device *rdev)
-- 
2.35.1



