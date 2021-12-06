Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9658E469BFA
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 16:16:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345468AbhLFPTO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 10:19:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358480AbhLFPQj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 10:16:39 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0017AC061D5E;
        Mon,  6 Dec 2021 07:09:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BF64CB8111F;
        Mon,  6 Dec 2021 15:09:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14451C341C1;
        Mon,  6 Dec 2021 15:09:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638803353;
        bh=Y/aMfI/u6HPzLgwpCSxDxrK5kYFbVC6ohyEyOEWm0zE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=m3ruBxZWOX4w9U7Z7QWufDxixAd/8pczYLLtkW16tIOUWansDDfz/kJ5/b60Y/Lxo
         g6dtXBk1QUDczDzI+AusS055xUFgVkZltw968Jdwk1WuQfWvxtW797ZmQS0+UbgF/z
         xZds+vomC7h5lz3mNVW5zbgX+NRz+osZfOmXgVNY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Nehal-bakulchandra Shah <Nehal-bakulchandra.Shah@amd.com>,
        Mario Limonciello <mario.limonciello@amd.com>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 12/48] ata: ahci: Add Green Sardine vendor ID as board_ahci_mobile
Date:   Mon,  6 Dec 2021 15:56:29 +0100
Message-Id: <20211206145549.272503744@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211206145548.859182340@linuxfoundation.org>
References: <20211206145548.859182340@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 8df0ec85cc7b9..505920d4530f8 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -436,6 +436,7 @@ static const struct pci_device_id ahci_pci_tbl[] = {
 	/* AMD */
 	{ PCI_VDEVICE(AMD, 0x7800), board_ahci }, /* AMD Hudson-2 */
 	{ PCI_VDEVICE(AMD, 0x7900), board_ahci }, /* AMD CZ */
+	{ PCI_VDEVICE(AMD, 0x7901), board_ahci_mobile }, /* AMD Green Sardine */
 	/* AMD is using RAID class only for ahci controllers */
 	{ PCI_VENDOR_ID_AMD, PCI_ANY_ID, PCI_ANY_ID, PCI_ANY_ID,
 	  PCI_CLASS_STORAGE_RAID << 8, 0xffffff, board_ahci },
-- 
2.33.0



