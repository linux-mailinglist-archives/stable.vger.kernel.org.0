Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34CE1411E93
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 19:31:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351163AbhITRcZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 13:32:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:33732 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347544AbhITRaZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 13:30:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 970B261502;
        Mon, 20 Sep 2021 17:04:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632157453;
        bh=34jJ84jhdG63AOvVSyLrvJxscMOwE5fWOo9WVCYniA0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OcV2OL06YvQqfh5TI6K9l4EtKK5DOkRj5o7jdKlFrrzX8oP0BNbkIoF7TBRreZgM5
         wtwl+XGppG4oQBhIZ5L3E2U7BzuoA+ogoWkFwhQzl0AsaXgfr8PxOV8gOvTeoieGWA
         nD3nzuPz1+GtOgqfP81+4e3lG4gghu4CfTEBgUhE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        George Cherian <george.cherian@marvell.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 208/217] PCI: Add ACS quirks for Cavium multi-function devices
Date:   Mon, 20 Sep 2021 18:43:49 +0200
Message-Id: <20210920163931.674482719@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163924.591371269@linuxfoundation.org>
References: <20210920163924.591371269@linuxfoundation.org>
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
index d2164b88111e..eff361af792a 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -4739,6 +4739,10 @@ static const struct pci_dev_acs_enabled {
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



