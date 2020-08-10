Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CF872409DF
	for <lists+stable@lfdr.de>; Mon, 10 Aug 2020 17:36:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728722AbgHJP1T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Aug 2020 11:27:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:33096 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728013AbgHJP1Q (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Aug 2020 11:27:16 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0D8FF22B47;
        Mon, 10 Aug 2020 15:27:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597073235;
        bh=ZbU7oW6pEniYwr+6ZrXyjc9J+OiZlRg6pK0mZPuUxI0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iknzZu6GjWkWR1CflNU8pMyiLK62gnNRdZq/9t6k2L0Pj/LPuvYwzOq3K5tliC/0h
         Z1vqCW2lJ6RoZydNbgwt0w3yslpZFGiUtaP+pUcLS2/rLBIhfd8sjglMjOS1bcIMCn
         gJIXR/n3sulNBThjJSEaT4ewYw/cJGBwe2pk8QWY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kyounghwan sohn <kyounghwan.sohn@sk.com>,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Christoph Hellwig <hch@lst.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 34/67] nvme-pci: prevent SK hynix PC400 from using Write Zeroes command
Date:   Mon, 10 Aug 2020 17:21:21 +0200
Message-Id: <20200810151811.124496132@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200810151809.438685785@linuxfoundation.org>
References: <20200810151809.438685785@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kai-Heng Feng <kai.heng.feng@canonical.com>

[ Upstream commit 5611ec2b9814bc91f7b0a8d804c1fc152e2025d9 ]

After commit 6e02318eaea5 ("nvme: add support for the Write Zeroes
command"), SK hynix PC400 becomes very slow with the following error
message:

[  224.567695] blk_update_request: operation not supported error, dev nvme1n1, sector 499384320 op 0x9:(WRITE_ZEROES) flags 0x1000000 phys_seg 0 prio class 0]

SK Hynix PC400 has a buggy firmware that treats NLB as max value instead
of a range, so the NLB passed isn't a valid value to the firmware.

According to SK hynix there are three commands are affected:
- Write Zeroes
- Compare
- Write Uncorrectable

Right now only Write Zeroes is implemented, so disable it completely on
SK hynix PC400.

BugLink: https://bugs.launchpad.net/bugs/1872383
Cc: kyounghwan sohn <kyounghwan.sohn@sk.com>
Signed-off-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/pci.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index a13cae1901962..ee7669f23cff0 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -3140,6 +3140,8 @@ static const struct pci_device_id nvme_id_table[] = {
 	{ PCI_DEVICE(0x1cc1, 0x8201),   /* ADATA SX8200PNP 512GB */
 		.driver_data = NVME_QUIRK_NO_DEEPEST_PS |
 				NVME_QUIRK_IGNORE_DEV_SUBNQN, },
+	{ PCI_DEVICE(0x1c5c, 0x1504),   /* SK Hynix PC400 */
+		.driver_data = NVME_QUIRK_DISABLE_WRITE_ZEROES, },
 	{ PCI_DEVICE_CLASS(PCI_CLASS_STORAGE_EXPRESS, 0xffffff) },
 	{ PCI_DEVICE(PCI_VENDOR_ID_APPLE, 0x2001),
 		.driver_data = NVME_QUIRK_SINGLE_VECTOR },
-- 
2.25.1



