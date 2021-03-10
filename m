Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA104333DAF
	for <lists+stable@lfdr.de>; Wed, 10 Mar 2021 14:25:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232941AbhCJNYm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Mar 2021 08:24:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:45490 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232786AbhCJNYQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 10 Mar 2021 08:24:16 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A939664FEF;
        Wed, 10 Mar 2021 13:24:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615382656;
        bh=CHQOddw/0GSWFWKZ0kKaTQHM1P0fVm9W4Y1NyCtzEZE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rSyM8uCyjO5L9WRuI72vz57nOCcRE+Kx1J9ZTLKv1aK1I8XqWipix5Uqej9KaspR4
         gEw/pLioi5WFgNJcxji7Yj/yFf3Q4gQo4/k9kGilqGAibxh5tYlb/rc/VICryrKJCv
         Hv60qyAMkL+s1Zx5notgTuWtSPoB+FFK0VSC89UA=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Zolt=C3=A1n=20B=C3=B6sz=C3=B6rm=C3=A9nyi?= 
        <zboszor@gmail.com>, Christoph Hellwig <hch@lst.de>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Subject: [PATCH 5.11 12/36] nvme-pci: mark Kingston SKC2000 as not supporting the deepest power state
Date:   Wed, 10 Mar 2021 14:23:25 +0100
Message-Id: <20210310132320.907725709@linuxfoundation.org>
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

From: "Zoltán Böszörményi" <zboszor@gmail.com>

commit dc22c1c058b5c4fe967a20589e36f029ee42a706 upstream

My 2TB SKC2000 showed the exact same symptoms that were provided
in 538e4a8c57 ("nvme-pci: avoid the deepest sleep state on
Kingston A2000 SSDs"), i.e. a complete NVME lockup that needed
cold boot to get it back.

According to some sources, the A2000 is simply a rebadged
SKC2000 with a slightly optimized firmware.

Adding the SKC2000 PCI ID to the quirk list with the same workaround
as the A2000 made my laptop survive a 5 hours long Yocto bootstrap
buildfest which reliably triggered the SSD lockup previously.

Signed-off-by: ZoltÃ¡n BÃ¶szÃ¶rmÃ©nyi <zboszor@gmail.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/nvme/host/pci.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -3261,6 +3261,8 @@ static const struct pci_device_id nvme_i
 		.driver_data = NVME_QUIRK_DISABLE_WRITE_ZEROES, },
 	{ PCI_DEVICE(0x1d97, 0x2263),   /* SPCC */
 		.driver_data = NVME_QUIRK_DISABLE_WRITE_ZEROES, },
+	{ PCI_DEVICE(0x2646, 0x2262),   /* KINGSTON SKC2000 NVMe SSD */
+		.driver_data = NVME_QUIRK_NO_DEEPEST_PS, },
 	{ PCI_DEVICE(0x2646, 0x2263),   /* KINGSTON A2000 NVMe SSD  */
 		.driver_data = NVME_QUIRK_NO_DEEPEST_PS, },
 	{ PCI_DEVICE(PCI_VENDOR_ID_APPLE, 0x2001),


