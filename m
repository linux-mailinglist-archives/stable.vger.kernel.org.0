Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FC53333DAB
	for <lists+stable@lfdr.de>; Wed, 10 Mar 2021 14:25:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232916AbhCJNYl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Mar 2021 08:24:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:45430 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230477AbhCJNYM (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 10 Mar 2021 08:24:12 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7904264FDA;
        Wed, 10 Mar 2021 13:24:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615382652;
        bh=1ysddjLBcxrlM6JytO6CiDqg1Z4JwWvCFkYzUsce+wM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MBGHOrPhyPlK65ZGSG8juGpX1Wq2gDIQHq22lyg+CUjI9b2DMMKekBjvQSP7y70PW
         Cp01uGovh0gHugvH8ehhe21AKw2aKS09HvGQBp3Bl5OqX0OvK4TDlF+5petlRF84w2
         voYlucZNbGcKrMqxN2jL6kB/p1eL8Y6Kca3uByZE=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Zolt=C3=A1n=20B=C3=B6sz=C3=B6rm=C3=A9nyi?= 
        <zboszor@gmail.com>, Christoph Hellwig <hch@lst.de>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Subject: [PATCH 5.10 03/49] nvme-pci: mark Kingston SKC2000 as not supporting the deepest power state
Date:   Wed, 10 Mar 2021 14:23:14 +0100
Message-Id: <20210310132322.065236469@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210310132321.948258062@linuxfoundation.org>
References: <20210310132321.948258062@linuxfoundation.org>
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
[sudip: adjust context]
Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/nvme/host/pci.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -3264,6 +3264,8 @@ static const struct pci_device_id nvme_i
 		.driver_data = NVME_QUIRK_DISABLE_WRITE_ZEROES, },
 	{ PCI_DEVICE(0x15b7, 0x2001),   /*  Sandisk Skyhawk */
 		.driver_data = NVME_QUIRK_DISABLE_WRITE_ZEROES, },
+	{ PCI_DEVICE(0x2646, 0x2262),   /* KINGSTON SKC2000 NVMe SSD */
+		.driver_data = NVME_QUIRK_NO_DEEPEST_PS, },
 	{ PCI_DEVICE(0x2646, 0x2263),   /* KINGSTON A2000 NVMe SSD  */
 		.driver_data = NVME_QUIRK_NO_DEEPEST_PS, },
 	{ PCI_DEVICE(PCI_VENDOR_ID_APPLE, 0x2001),


