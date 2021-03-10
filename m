Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68A68333E26
	for <lists+stable@lfdr.de>; Wed, 10 Mar 2021 14:36:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233429AbhCJNZg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Mar 2021 08:25:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:46494 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233157AbhCJNY7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 10 Mar 2021 08:24:59 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 331A264FDA;
        Wed, 10 Mar 2021 13:24:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615382699;
        bh=QVQ0krjUOVVBoQk6LSMToA6UhcLSm7Th9wTI+qxiJBU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zrg8HlHPOcVsDjFAc/4zdEdrOgKfjx7XmLBYvVq76mfsTrGuVmb7/wqNxT7RttRwn
         7HTI/2V2RjFSNnZo2nE1mZtMv40VuvZXsZ3yySSCKhdiuEXCa5ODeVaH2xbpVHd1Pb
         jhy5COVqG4z/6fy3BJ1I5aH2GQ/8bB5MVzdLt3Ds=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pascal Terjan <pterjan@google.com>,
        Christoph Hellwig <hch@lst.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 36/36] nvme-pci: add quirks for Lexar 256GB SSD
Date:   Wed, 10 Mar 2021 14:23:49 +0100
Message-Id: <20210310132321.662840130@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210310132320.510840709@linuxfoundation.org>
References: <20210310132320.510840709@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Pascal Terjan <pterjan@google.com>

[ Upstream commit 6e6a6828c517fb6819479bf5187df5f39084eb9e ]

Add the NVME_QUIRK_NO_NS_DESC_LIST and NVME_QUIRK_IGNORE_DEV_SUBNQN
quirks for this buggy device.

Reported and tested in https://bugs.mageia.org/show_bug.cgi?id=28417

Signed-off-by: Pascal Terjan <pterjan@google.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/pci.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index 14c5b52400ef..806a5d071ef6 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -3245,6 +3245,9 @@ static const struct pci_device_id nvme_id_table[] = {
 				NVME_QUIRK_IGNORE_DEV_SUBNQN, },
 	{ PCI_DEVICE(0x1987, 0x5016),	/* Phison E16 */
 		.driver_data = NVME_QUIRK_IGNORE_DEV_SUBNQN, },
+	{ PCI_DEVICE(0x1b4b, 0x1092),	/* Lexar 256 GB SSD */
+		.driver_data = NVME_QUIRK_NO_NS_DESC_LIST |
+				NVME_QUIRK_IGNORE_DEV_SUBNQN, },
 	{ PCI_DEVICE(0x1d1d, 0x1f1f),	/* LighNVM qemu device */
 		.driver_data = NVME_QUIRK_LIGHTNVM, },
 	{ PCI_DEVICE(0x1d1d, 0x2807),	/* CNEX WL */
-- 
2.30.1



