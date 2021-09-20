Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBD104120DD
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 19:59:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356244AbhITR7B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 13:59:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:54992 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1355883AbhITR47 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 13:56:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 34D6D6320F;
        Mon, 20 Sep 2021 17:14:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632158077;
        bh=3DvMnxOJwNlDwQm0Ehk0Wu9nPg2w9XgqSll7I2O3/5s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tQwlbKsxeIo/cckC5PVJUZcEPQZCd65/dpiNldmi9WURTIMhfIlcm9lQkSWZCmpjc
         NM8GPC5SpEuqbDtJFWgQ4R+D0koGl4HNhD4/aUPxBGKiBFLC2M/3XTI1dskkseP+41
         BbyIRpbaAwP89KZ0FDhqDxzXSuGG1qnCXy1M4qiY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        George Cherian <george.cherian@marvell.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 277/293] PCI: Add ACS quirks for Cavium multi-function devices
Date:   Mon, 20 Sep 2021 18:43:59 +0200
Message-Id: <20210920163942.899934332@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163933.258815435@linuxfoundation.org>
References: <20210920163933.258815435@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: George Cherian <george.cherian@marvell.com>

[ Upstream commit 32837d8a8f63eb95dcb9cd005524a27f06478832 ]

Some Cavium endpoints are implemented as multi-function devices without ACS
capability, but they actually don't support peer-to-peer transactions.

Add ACS quirks to declare DMA isolation for the following devices:

  - BGX device found on Octeon-TX (8xxx)
  - CGX device found on Octeon-TX2 (9xxx)
  - RPM device found on Octeon-TX3 (10xxx)

Link: https://lore.kernel.org/r/20210810122425.1115156-1-george.cherian@marvell.com
Signed-off-by: George Cherian <george.cherian@marvell.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/quirks.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/pci/quirks.c b/drivers/pci/quirks.c
index 48c1fbb17e40..4eb8900b9a5c 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -4778,6 +4778,10 @@ static const struct pci_dev_acs_enabled {
 	{ 0x10df, 0x720, pci_quirk_mf_endpoint_acs }, /* Emulex Skyhawk-R */
 	/* Cavium ThunderX */
 	{ PCI_VENDOR_ID_CAVIUM, PCI_ANY_ID, pci_quirk_cavium_acs },
+	/* Cavium multi-function devices */
+	{ PCI_VENDOR_ID_CAVIUM, 0xA026, pci_quirk_mf_endpoint_acs },
+	{ PCI_VENDOR_ID_CAVIUM, 0xA059, pci_quirk_mf_endpoint_acs },
+	{ PCI_VENDOR_ID_CAVIUM, 0xA060, pci_quirk_mf_endpoint_acs },
 	/* APM X-Gene */
 	{ PCI_VENDOR_ID_AMCC, 0xE004, pci_quirk_xgene_acs },
 	/* Ampere Computing */
-- 
2.30.2



