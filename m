Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23EDA469D27
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 16:25:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232821AbhLFP21 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 10:28:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376432AbhLFPXw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 10:23:52 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44D2DC08EAE0;
        Mon,  6 Dec 2021 07:15:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D5EFA6132B;
        Mon,  6 Dec 2021 15:15:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5ECAC341C2;
        Mon,  6 Dec 2021 15:15:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638803717;
        bh=TRl5ES+ctB8KaUS9A7hDwPSiYaR4V6+QNvLL2WFt7wk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NcZg5mDi2rgHuNbH4LTjyuvqC6rYGPxxSUc3iAsEr8mJAqX+4pRB5JxTdhcC0/G0g
         1bl70fwtCRd1SGBhuOPLY/DIA1KGIPxIUghmBst+wTBb0Ut4bljX5uYhp3h2gjIqTF
         cxiriXPU+hEwPqFnhKBRYl2yze77xFe7cbkJCUA4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Nehal-bakulchandra Shah <Nehal-bakulchandra.Shah@amd.com>,
        Mario Limonciello <mario.limonciello@amd.com>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 021/130] ata: ahci: Add Green Sardine vendor ID as board_ahci_mobile
Date:   Mon,  6 Dec 2021 15:55:38 +0100
Message-Id: <20211206145600.364878056@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211206145559.607158688@linuxfoundation.org>
References: <20211206145559.607158688@linuxfoundation.org>
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
index 33192a8f687d6..ff2add0101fe5 100644
--- a/drivers/ata/ahci.c
+++ b/drivers/ata/ahci.c
@@ -442,6 +442,7 @@ static const struct pci_device_id ahci_pci_tbl[] = {
 	/* AMD */
 	{ PCI_VDEVICE(AMD, 0x7800), board_ahci }, /* AMD Hudson-2 */
 	{ PCI_VDEVICE(AMD, 0x7900), board_ahci }, /* AMD CZ */
+	{ PCI_VDEVICE(AMD, 0x7901), board_ahci_mobile }, /* AMD Green Sardine */
 	/* AMD is using RAID class only for ahci controllers */
 	{ PCI_VENDOR_ID_AMD, PCI_ANY_ID, PCI_ANY_ID, PCI_ANY_ID,
 	  PCI_CLASS_STORAGE_RAID << 8, 0xffffff, board_ahci },
-- 
2.33.0



