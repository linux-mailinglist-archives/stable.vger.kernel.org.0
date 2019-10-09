Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8C5D3D16A0
	for <lists+stable@lfdr.de>; Wed,  9 Oct 2019 19:31:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732075AbfJIRYA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Oct 2019 13:24:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:48316 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732061AbfJIRX7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 9 Oct 2019 13:23:59 -0400
Received: from sasha-vm.mshome.net (unknown [167.220.2.234])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5445821D71;
        Wed,  9 Oct 2019 17:23:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570641839;
        bh=1oXKVfkAFl97KrAILvEm5RI32+UeZ6F9r+7sJe2Yyx4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uyIpD77mU4vu19ivNVi8AN2c69NfobWjo8XEy/87iS9Dn1ATLc0u6daTCjkXMYBsd
         OjUrr/wTvkGRw9h/qtImaq9nxOIHRoUuxB9vS8ezym9nyiUl0BdhwPgirKeIMoRxVI
         nwEKyjcODgpoJm2mtmL3cdCOqNaIh//3WOBIRwlQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Gabriel Craciunescu <nix.or.die@gmail.com>,
        Sagi Grimberg <sagi@grimberg.me>,
        Sasha Levin <sashal@kernel.org>, linux-nvme@lists.infradead.org
Subject: [PATCH AUTOSEL 5.3 22/68] Added QUIRKs for ADATA XPG SX8200 Pro 512GB
Date:   Wed,  9 Oct 2019 13:05:01 -0400
Message-Id: <20191009170547.32204-22-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191009170547.32204-1-sashal@kernel.org>
References: <20191009170547.32204-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gabriel Craciunescu <nix.or.die@gmail.com>

[ Upstream commit f03e42c6af60f778a6d1ccfb857db9b2ec835279 ]

Booting with default_ps_max_latency_us >6000 makes the device fail.
Also SUBNQN is NULL and gives a warning on each boot/resume.
 $ nvme id-ctrl /dev/nvme0 | grep ^subnqn
   subnqn    : (null)

I use this device with an Acer Nitro 5 (AN515-43-R8BF) Laptop.
To be sure is not a Laptop issue only, I tested the device on
my server board  with the same results.
( with 2x,4x link on the board and 4x link on a PCI-E card ).

Signed-off-by: Gabriel Craciunescu <nix.or.die@gmail.com>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Signed-off-by: Sagi Grimberg <sagi@grimberg.me>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/pci.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index 19458e85dab34..86763969e7cb0 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -3041,6 +3041,9 @@ static const struct pci_device_id nvme_id_table[] = {
 		.driver_data = NVME_QUIRK_LIGHTNVM, },
 	{ PCI_DEVICE(0x10ec, 0x5762),   /* ADATA SX6000LNP */
 		.driver_data = NVME_QUIRK_IGNORE_DEV_SUBNQN, },
+	{ PCI_DEVICE(0x1cc1, 0x8201),   /* ADATA SX8200PNP 512GB */
+		.driver_data = NVME_QUIRK_NO_DEEPEST_PS |
+				NVME_QUIRK_IGNORE_DEV_SUBNQN, },
 	{ PCI_DEVICE_CLASS(PCI_CLASS_STORAGE_EXPRESS, 0xffffff) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_APPLE, 0x2001) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_APPLE, 0x2003) },
-- 
2.20.1

