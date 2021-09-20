Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1364541233D
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 20:21:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236921AbhITSWa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 14:22:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:40566 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1377714AbhITSUZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 14:20:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0341C632B0;
        Mon, 20 Sep 2021 17:23:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632158617;
        bh=NJqq6v/ZSiJFgHNyuGmhk4djZzWzmkKOy5QImzh5YvA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pThzj25ZwEUUVu/ywaoMtQg1HXLRkXQUwKZHvYXy96YJYDmHRd6xwwLvCDUspPQpj
         WRkOnRgpSkQLtjhp8H+aug4n17pbBBZKK7ury3tfnDFldL0WZ4N8QfrDfpT7buLfKX
         P+Fl++LgSc058Wx4FhPz+aMkOXp5kB9cZRLhe35A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        George Cherian <george.cherian@marvell.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 239/260] PCI: Add ACS quirks for Cavium multi-function devices
Date:   Mon, 20 Sep 2021 18:44:17 +0200
Message-Id: <20210920163939.252266166@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163931.123590023@linuxfoundation.org>
References: <20210920163931.123590023@linuxfoundation.org>
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
index e230a7b5e70a..686298c0f6cd 100644
--- a/drivers/pci/quirks.c
+++ b/drivers/pci/quirks.c
@@ -4922,6 +4922,10 @@ static const struct pci_dev_acs_enabled {
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



