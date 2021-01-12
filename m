Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 427692F306B
	for <lists+stable@lfdr.de>; Tue, 12 Jan 2021 14:15:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404684AbhALM6H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jan 2021 07:58:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:53894 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404614AbhALM6G (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 12 Jan 2021 07:58:06 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DD2E32311C;
        Tue, 12 Jan 2021 12:57:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610456235;
        bh=a045boHEnaS0K8/hRvOKz6pzgjbFjoxJBC37/auV5OQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=luQvROK2RZx93TiyjPw1Bpq6DG70W0BkEJhnguqxlLOrLYZQfdx3HwzWU1Xm3KL7v
         oR9aZNzE17QP93ZDyDCT8mbyw662FRzbpuweqek/1YPiD8Uq6gS2CzL49Fhtt/Tal/
         E6klJYT6sUYuiI8lzTOXdnKVdCxDBz47PWpvshtakOzXJO698Wk2g+565zO0ifWJnq
         MdoML2S9xZQ5Bk/wKaNVgsAhgi0APSGB8NeAQiZMb5S7VjxhYchNAEKZuc+clOs+pd
         vqJIZ8wBPOmg4hq6ir9bO2H/E0sYDE/E2HK8dlBT/cxYBUUVj8qwcOHsmBcsqoUFfS
         46onBxrJvHuZw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Gopal Tiwari <gtiwari@redhat.com>, Christoph Hellwig <hch@lst.de>,
        Sasha Levin <sashal@kernel.org>, linux-nvme@lists.infradead.org
Subject: [PATCH AUTOSEL 5.4 22/28] nvme-pci: mark Samsung PM1725a as IGNORE_DEV_SUBNQN
Date:   Tue, 12 Jan 2021 07:56:38 -0500
Message-Id: <20210112125645.70739-22-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210112125645.70739-1-sashal@kernel.org>
References: <20210112125645.70739-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gopal Tiwari <gtiwari@redhat.com>

[ Upstream commit 7ee5c78ca3895d44e918c38332921983ed678be0 ]

A system with more than one of these SSDs will only have one usable.
Hence the kernel fails to detect nvme devices due to duplicate cntlids.

[    6.274554] nvme nvme1: Duplicate cntlid 33 with nvme0, rejecting
[    6.274566] nvme nvme1: Removing after probe failure status: -22

Adding the NVME_QUIRK_IGNORE_DEV_SUBNQN quirk to resolves the issue.

Signed-off-by: Gopal Tiwari <gtiwari@redhat.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/pci.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index 9b1fc8633cfe1..ef93bd3ed339c 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -3145,7 +3145,8 @@ static const struct pci_device_id nvme_id_table[] = {
 	{ PCI_DEVICE(0x144d, 0xa821),   /* Samsung PM1725 */
 		.driver_data = NVME_QUIRK_DELAY_BEFORE_CHK_RDY, },
 	{ PCI_DEVICE(0x144d, 0xa822),   /* Samsung PM1725a */
-		.driver_data = NVME_QUIRK_DELAY_BEFORE_CHK_RDY, },
+		.driver_data = NVME_QUIRK_DELAY_BEFORE_CHK_RDY |
+				NVME_QUIRK_IGNORE_DEV_SUBNQN, },
 	{ PCI_DEVICE(0x1d1d, 0x1f1f),	/* LighNVM qemu device */
 		.driver_data = NVME_QUIRK_LIGHTNVM, },
 	{ PCI_DEVICE(0x1d1d, 0x2807),	/* CNEX WL */
-- 
2.27.0

