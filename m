Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1964F3AF0BF
	for <lists+stable@lfdr.de>; Mon, 21 Jun 2021 18:50:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233114AbhFUQwD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Jun 2021 12:52:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:41424 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233598AbhFUQt7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Jun 2021 12:49:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DF9F2613EE;
        Mon, 21 Jun 2021 16:34:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1624293297;
        bh=De1de2B3RLNPWpxenOfIaw+pqfLOFaRv7d6OKCyX/ZU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=H6n8vYxHB2aIpUDXZFXssdjZAiyd6npsoI8IlgmHw02rTugW4wDvMdLFOmE6j8UXt
         QkJgPlVilOrQi2armFoRYo6dhO5tjDe8aGOv0ccsFhGllq3a4AMH2i6//VgMAGBpof
         s+K2fFAWVhpWVQPRCTxPtGeNqqZaLr9UHtX9aoew=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alex Deucher <alexander.deucher@amd.com>,
        Evan Quan <evan.quan@amd.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        =?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kw@linux.com>
Subject: [PATCH 5.12 128/178] PCI: Mark AMD Navi14 GPU ATS as broken
Date:   Mon, 21 Jun 2021 18:15:42 +0200
Message-Id: <20210621154927.133990459@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210621154921.212599475@linuxfoundation.org>
References: <20210621154921.212599475@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Evan Quan <evan.quan@amd.com>

commit e8946a53e2a698c148b3b3ed732f43c7747fbeb6 upstream.

Observed unexpected GPU hang during runpm stress test on 0x7341 rev 0x00.
Further debugging shows broken ATS is related.

Disable ATS on this part.  Similar issues on other devices:

  a2da5d8cc0b0 ("PCI: Mark AMD Raven iGPU ATS as broken in some platforms")
  45beb31d3afb ("PCI: Mark AMD Navi10 GPU rev 0x00 ATS as broken")
  5e89cd303e3a ("PCI: Mark AMD Navi14 GPU rev 0xc5 ATS as broken")

Suggested-by: Alex Deucher <alexander.deucher@amd.com>
Link: https://lore.kernel.org/r/20210602021255.939090-1-evan.quan@amd.com
Signed-off-by: Evan Quan <evan.quan@amd.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Reviewed-by: Krzysztof Wilczyński <kw@linux.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pci/quirks.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -5187,7 +5187,8 @@ DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_SE
 static void quirk_amd_harvest_no_ats(struct pci_dev *pdev)
 {
 	if ((pdev->device == 0x7312 && pdev->revision != 0x00) ||
-	    (pdev->device == 0x7340 && pdev->revision != 0xc5))
+	    (pdev->device == 0x7340 && pdev->revision != 0xc5) ||
+	    (pdev->device == 0x7341 && pdev->revision != 0x00))
 		return;
 
 	if (pdev->device == 0x15d8) {
@@ -5214,6 +5215,7 @@ DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_AT
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_ATI, 0x7312, quirk_amd_harvest_no_ats);
 /* AMD Navi14 dGPU */
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_ATI, 0x7340, quirk_amd_harvest_no_ats);
+DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_ATI, 0x7341, quirk_amd_harvest_no_ats);
 /* AMD Raven platform iGPU */
 DECLARE_PCI_FIXUP_FINAL(PCI_VENDOR_ID_ATI, 0x15d8, quirk_amd_harvest_no_ats);
 #endif /* CONFIG_PCI_ATS */


