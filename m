Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3536330190
	for <lists+stable@lfdr.de>; Sun,  7 Mar 2021 14:58:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231636AbhCGN6Q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Mar 2021 08:58:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:43618 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231523AbhCGN55 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 7 Mar 2021 08:57:57 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BCD8564EE6;
        Sun,  7 Mar 2021 13:57:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615125477;
        bh=1ES4PPvD+5KQp4HDC3M1PufT+RVzP3FwrXVx+11QKjk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eJR8wUIFb2tSVjuUhmZU6S8RpYDd+F+/lS2mK5fVjZkREYzDNv9cef0wPVHVKnGJ2
         mEA7V5SshkQByBGIozzECbY1aFXHNGeNwyHuZdWOSTQRjawNwuAfd9y/Dk5ZhZt7e7
         5hI/EtJo+dcBiUZ8y2EpFIDdo9nvtCMG+E5fFEkElCh0WtOYZDHOppHnBCQRQGQMfs
         08dkj5vYIqyY7wrnEkkY2hvvNcujVYyWtpiVFGeBS79bn/vnHsHkMYeNi/OPXaRUdI
         Imjysumzpm1e3t7AM+sUE3mHvg7nMNknE01O8fJL/9/TjDodksoNKdR9VgJLxkBmMx
         Jlqos+5EzJyyw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Zolt=C3=A1n=20B=C3=B6sz=C3=B6rm=C3=A9nyi?= 
        <zboszor@gmail.com>, Christoph Hellwig <hch@lst.de>,
        Sasha Levin <sashal@kernel.org>, linux-nvme@lists.infradead.org
Subject: [PATCH AUTOSEL 5.11 09/12] nvme-pci: mark Kingston SKC2000 as not supporting the deepest power state
Date:   Sun,  7 Mar 2021 08:57:43 -0500
Message-Id: <20210307135746.967418-9-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210307135746.967418-1-sashal@kernel.org>
References: <20210307135746.967418-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zoltán Böszörményi <zboszor@gmail.com>

[ Upstream commit dc22c1c058b5c4fe967a20589e36f029ee42a706 ]

My 2TB SKC2000 showed the exact same symptoms that were provided
in 538e4a8c57 ("nvme-pci: avoid the deepest sleep state on
Kingston A2000 SSDs"), i.e. a complete NVME lockup that needed
cold boot to get it back.

According to some sources, the A2000 is simply a rebadged
SKC2000 with a slightly optimized firmware.

Adding the SKC2000 PCI ID to the quirk list with the same workaround
as the A2000 made my laptop survive a 5 hours long Yocto bootstrap
buildfest which reliably triggered the SSD lockup previously.

Signed-off-by: Zoltán Böszörményi <zboszor@gmail.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/pci.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index 7a38d764b486..14c5b52400ef 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -3262,6 +3262,8 @@ static const struct pci_device_id nvme_id_table[] = {
 		.driver_data = NVME_QUIRK_DISABLE_WRITE_ZEROES, },
 	{ PCI_DEVICE(0x1d97, 0x2263),   /* SPCC */
 		.driver_data = NVME_QUIRK_DISABLE_WRITE_ZEROES, },
+	{ PCI_DEVICE(0x2646, 0x2262),   /* KINGSTON SKC2000 NVMe SSD */
+		.driver_data = NVME_QUIRK_NO_DEEPEST_PS, },
 	{ PCI_DEVICE(0x2646, 0x2263),   /* KINGSTON A2000 NVMe SSD  */
 		.driver_data = NVME_QUIRK_NO_DEEPEST_PS, },
 	{ PCI_DEVICE(PCI_VENDOR_ID_APPLE, 0x2001),
-- 
2.30.1

