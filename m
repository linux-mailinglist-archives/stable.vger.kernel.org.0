Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BAB064D8447
	for <lists+stable@lfdr.de>; Mon, 14 Mar 2022 13:23:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241109AbiCNMWq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Mar 2022 08:22:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243459AbiCNMUk (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Mar 2022 08:20:40 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9B305468B;
        Mon, 14 Mar 2022 05:16:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 10565CE1232;
        Mon, 14 Mar 2022 12:16:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BDC0C36AE3;
        Mon, 14 Mar 2022 12:16:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647260162;
        bh=jakVvKjtUdQUJVcNt9eTW1GmyK7Gj6ycAC5BLjlTLr0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hJSvxLervxN3a8tczXM/qCVd2m5RMiKjjCY+rJZxzNPXzCI0Yo20vGu6XK4h3j+gF
         KWO2jWp7osLH10khNJSGMcLhzVlgqFIo78EfvMyclusPhdlDs4j5Cq7wtrzELrWxSZ
         UyufoeI/5dBhBvlVvi6ed60Apn62Iv6yW1REiLF0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alex Deucher <alexander.deucher@amd.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Guchun Chen <guchun.chen@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 075/121] PCI: Mark all AMD Navi10 and Navi14 GPU ATS as broken
Date:   Mon, 14 Mar 2022 12:54:18 +0100
Message-Id: <20220314112746.214869174@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220314112744.120491875@linuxfoundation.org>
References: <20220314112744.120491875@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
index 20a932690738..db864bf634a3 100644
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



