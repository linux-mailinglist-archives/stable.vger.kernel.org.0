Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB3DC45E5C1
	for <lists+stable@lfdr.de>; Fri, 26 Nov 2021 04:00:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358887AbhKZCpM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Nov 2021 21:45:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:50236 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1358622AbhKZCnM (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Nov 2021 21:43:12 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1F8706124D;
        Fri, 26 Nov 2021 02:35:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637894111;
        bh=TUTJvnF4QyGr5TJwtZsUXH6nSvmCGZ4wTVONDSK+NZw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pSTicwiRnpRdKQBftYSCH7Z29xD72JL8hiCZNry7AOHQeoxO0i/HQX+qZ8EXJi0bk
         1K+WO0Wz/ZuDsph9tkvLB2YN3b6pOxrFFX22jFSsE3J53dq6SMpDn0eyRBt4NLGnPf
         utGU5CYqaNEw+0RlFx2zhZFoyOI5MqFfzLsv0iVD9Sffi/qIidMw4TJ1VfcL5V45IW
         8ryuG6u5T7YEKCkUt2cZwwfflsutT12iMG6P3+5O4BSMbClRD9o3Q3An5ejWm0NQJ8
         A2cR6xtjg1pQ229zW3quHkjsF/CpDOfU/ZIIlBM5DiR1EMsMRkaDWpx7vdnQam7kkr
         C9HzAmMkTyhOQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mario Limonciello <mario.limonciello@amd.com>,
        Nehal-bakulchandra Shah <Nehal-bakulchandra.Shah@amd.com>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Sasha Levin <sashal@kernel.org>, linux-ide@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 14/19] ata: ahci: Add Green Sardine vendor ID as board_ahci_mobile
Date:   Thu, 25 Nov 2021 21:34:43 -0500
Message-Id: <20211126023448.442529-14-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211126023448.442529-1-sashal@kernel.org>
References: <20211126023448.442529-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mario Limonciello <mario.limonciello@amd.com>

[ Upstream commit 1527f69204fe35f341cb599f1cb01bd02daf4374 ]

AMD requires that the SATA controller be configured for devsleep in order
for S0i3 entry to work properly.

commit b1a9585cc396 ("ata: ahci: Enable DEVSLP by default on x86 with
SLP_S0") sets up a kernel policy to enable devsleep on Intel mobile
platforms that are using s0ix.  Add the PCI ID for the SATA controller in
Green Sardine platforms to extend this policy by default for AMD based
systems using s0i3 as well.

Cc: Nehal-bakulchandra Shah <Nehal-bakulchandra.Shah@amd.com>
BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=214091
Signed-off-by: Mario Limonciello <mario.limonciello@amd.com>
Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ata/ahci.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/ata/ahci.c b/drivers/ata/ahci.c
index 8beb418ce167b..6f572967b5552 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -420,6 +420,7 @@ static const struct pci_device_id ahci_pci_tbl[] = {
 	/* AMD */
 	{ PCI_VDEVICE(AMD, 0x7800), board_ahci }, /* AMD Hudson-2 */
 	{ PCI_VDEVICE(AMD, 0x7900), board_ahci }, /* AMD CZ */
+	{ PCI_VDEVICE(AMD, 0x7901), board_ahci_mobile }, /* AMD Green Sardine */
 	/* AMD is using RAID class only for ahci controllers */
 	{ PCI_VENDOR_ID_AMD, PCI_ANY_ID, PCI_ANY_ID, PCI_ANY_ID,
 	  PCI_CLASS_STORAGE_RAID << 8, 0xffffff, board_ahci },
-- 
2.33.0

