Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 969FC2FA312
	for <lists+stable@lfdr.de>; Mon, 18 Jan 2021 15:32:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390713AbhARObw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Jan 2021 09:31:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:37938 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390675AbhARLoE (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Jan 2021 06:44:04 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8EB5622CA2;
        Mon, 18 Jan 2021 11:43:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610970213;
        bh=CsQndEsie5njlaPw7SSSQtZoRkZoiOZBqeW7sQW2Zgk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R4RElnUyYbRKHyxY2bxcGqIxGhXafrte/THLcKY5So9LV7Oq3YYmGKaOMpwPhGcFn
         Ne5WeF179c177UVRR2AHuUZATb0fbWChDObUWDzq9AFC72KaJ1Kw9xggabpnN1RxT2
         gKyAqjmScb/6f6XNArcaA0whTjBll+pPf+EBPQ3I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Gopal Tiwari <gtiwari@redhat.com>,
        Christoph Hellwig <hch@lst.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 085/152] nvme-pci: mark Samsung PM1725a as IGNORE_DEV_SUBNQN
Date:   Mon, 18 Jan 2021 12:34:20 +0100
Message-Id: <20210118113356.833556252@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210118113352.764293297@linuxfoundation.org>
References: <20210118113352.764293297@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 3be352403839a..143f16a9f8d7e 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -3201,7 +3201,8 @@ static const struct pci_device_id nvme_id_table[] = {
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



