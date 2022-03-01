Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 15C454C95C8
	for <lists+stable@lfdr.de>; Tue,  1 Mar 2022 21:16:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237807AbiCAUQs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Mar 2022 15:16:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237805AbiCAUQk (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Mar 2022 15:16:40 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A07077C17C;
        Tue,  1 Mar 2022 12:15:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 60855B81CB6;
        Tue,  1 Mar 2022 20:15:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35CE4C340EE;
        Tue,  1 Mar 2022 20:15:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646165731;
        bh=B7Sf5GkD2tyWuAmA1HqunawV+D52WUkCHK5kFSXHqi0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UZ2LnFGUF882P6+Ia640App/fZmyzrM5RqVaB2zML4x9fOiSuOvD3wPB/vz9l6ht7
         O01xDzzIUfbdbejUagPT4NHuuJb065c/Qh84Rr5o4fB/MnkneHOTNtqazic5q6R6JK
         UiGdsKyyRNlfr30UcAcsGRCrvxpnp13Zy5d6couGm8MbveKuumqFkqhanNg0Lvex8U
         MYQgLCOjfYvgQJF+ggcknK0cwFm/Z3VBVuullQ7X34i1vGWDbntNqyCN7N9jyNL6ha
         472UBWnF/D4YOXX59bTjzFymcNE/MdGJQexBHtLnj5sdhDu9dmN2n1pk6y52bbYHRw
         bs1DDGmgFyYZg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alex Deucher <alexander.deucher@amd.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Guchun Chen <guchun.chen@amd.com>,
        Sasha Levin <sashal@kernel.org>, linux-pci@vger.kernel.org
Subject: [PATCH AUTOSEL 5.16 18/28] PCI: Mark all AMD Navi10 and Navi14 GPU ATS as broken
Date:   Tue,  1 Mar 2022 15:13:23 -0500
Message-Id: <20220301201344.18191-18-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220301201344.18191-1-sashal@kernel.org>
References: <20220301201344.18191-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
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

From: Alex Deucher <alexander.deucher@amd.com>

[ Upstream commit 3f1271b54edcc692da5a3663f2aa2a64781f9bc3 ]

There are enough VBIOS escapes without the proper workaround that some
users still hit this.  Microsoft never productized ATS on Windows so OEM
platforms that were Windows-only didn't always validate ATS.

The advantages of ATS are not worth it compared to the potential
instabilities on harvested boards.  Disable ATS on all Navi10 and Navi14
boards.

Symptoms include:

  amdgpu 0000:07:00.0: AMD-Vi: Event logged [IO_PAGE_FAULT domain=0x0007 address=0xffffc02000 flags=0x0000]
  AMD-Vi: Event logged [IO_PAGE_FAULT device=07:00.0 domain=0x0007 address=0xffffc02000 flags=0x0000]
  [drm:amdgpu_job_timedout [amdgpu]] *ERROR* ring sdma0 timeout, signaled seq=6047, emitted seq=6049
  amdgpu 0000:07:00.0: amdgpu: GPU reset begin!
  amdgpu 0000:07:00.0: amdgpu: GPU reset succeeded, trying to resume
  amdgpu 0000:07:00.0: [drm:amdgpu_ring_test_helper [amdgpu]] *ERROR* ring sdma0 test failed (-110)
  [drm:amdgpu_device_ip_resume_phase2 [amdgpu]] *ERROR* resume of IP block <sdma_v4_0> failed -110
  amdgpu 0000:07:00.0: amdgpu: GPU reset(1) failed

Related commits:

  e8946a53e2a6 ("PCI: Mark AMD Navi14 GPU ATS as broken")
  a2da5d8cc0b0 ("PCI: Mark AMD Raven iGPU ATS as broken in some platforms")
  45beb31d3afb ("PCI: Mark AMD Navi10 GPU rev 0x00 ATS as broken")
  5e89cd303e3a ("PCI: Mark AMD Navi14 GPU rev 0xc5 ATS as broken")
  d28ca864c493 ("PCI: Mark AMD Stoney Radeon R7 GPU ATS as broken")
  9b44b0b09dec ("PCI: Mark AMD Stoney GPU ATS as broken")

[bhelgaas: add symptoms and related commits]
Bug: https://gitlab.freedesktop.org/drm/amd/-/issues/1760
Link: https://lore.kernel.org/r/20220222160801.841643-1-alexander.deucher@amd.com
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Acked-by: Christian König <christian.koenig@amd.com>
Acked-by: Guchun Chen <guchun.chen@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/quirks.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index 20a9326907384..db864bf634a3e 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -5344,11 +5344,6 @@ DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_SERVERWORKS, 0x0422, quirk_no_ext_tags);
  */
 static void quirk_amd_harvest_no_ats(struct pci_dev *pdev)
 {
-	if ((pdev->device == 0x7312 && pdev->revision != 0x00) ||
-	    (pdev->device == 0x7340 && pdev->revision != 0xc5) ||
-	    (pdev->device == 0x7341 && pdev->revision != 0x00))
-		return;
-
 	if (pdev->device == 0x15d8) {
 		if (pdev->revision == 0xcf &&
 		    pdev->subsystem_vendor == 0xea50 &&
@@ -5370,10 +5365,19 @@ DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_ATI, 0x98e4, quirk_amd_harvest_no_ats);
 /* AMD Iceland dGPU */
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_ATI, 0x6900, quirk_amd_harvest_no_ats);
 /* AMD Navi10 dGPU */
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_ATI, 0x7310, quirk_amd_harvest_no_ats);
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_ATI, 0x7312, quirk_amd_harvest_no_ats);
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_ATI, 0x7318, quirk_amd_harvest_no_ats);
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_ATI, 0x7319, quirk_amd_harvest_no_ats);
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_ATI, 0x731a, quirk_amd_harvest_no_ats);
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_ATI, 0x731b, quirk_amd_harvest_no_ats);
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_ATI, 0x731e, quirk_amd_harvest_no_ats);
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_ATI, 0x731f, quirk_amd_harvest_no_ats);
 /* AMD Navi14 dGPU */
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_ATI, 0x7340, quirk_amd_harvest_no_ats);
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_ATI, 0x7341, quirk_amd_harvest_no_ats);
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_ATI, 0x7347, quirk_amd_harvest_no_ats);
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_ATI, 0x734f, quirk_amd_harvest_no_ats);
 /* AMD Raven platform iGPU */
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_ATI, 0x15d8, quirk_amd_harvest_no_ats);
 #endif /* CONFIG_PCI_ATS */
-- 
2.34.1

