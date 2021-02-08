Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1961D313C73
	for <lists+stable@lfdr.de>; Mon,  8 Feb 2021 19:08:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235178AbhBHSG4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Feb 2021 13:06:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:47388 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235283AbhBHSDA (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Feb 2021 13:03:00 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 95F6864ED3;
        Mon,  8 Feb 2021 17:59:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612807151;
        bh=5dOnDzvovKBWKay6kA4mi5Nr/o/4H+wvdKdjlKXUnwI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=H507NOJNlNtziA34YpF60mQhi9Em+g1WT0Evb6EKahdzlZ6qe5jSBq5VkkDfjUmJy
         62zUWshqoKjrelY2x4LDbxpukI1GEEThsQbzAGBKdWA0G2LF1RhnADQQXz/k6/Jssf
         Pv7kwR0NJS+HtiYkQgjOJ8q2nPoY4SyvOIrP5qV0AXz0sHiQhFrwCxxIwiR3pCdx4i
         gbqmpmY8PKIiKAVvAaZvQqjleRLuUo4/ypVv8hajL1ifY2VnIhehZTC/C304kU2wnM
         n4J5qJ69oFhaaKXGsX0tIQh9Ju5EEuKpmf1HNAa2IhfmW/GPzb2cHDfKHR95gCKTB1
         FwWLObaw4eQug==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Claus Stovgaard <claus.stovgaard@gmail.com>,
        Christoph Hellwig <hch@lst.de>,
        Sasha Levin <sashal@kernel.org>, linux-nvme@lists.infradead.org
Subject: [PATCH AUTOSEL 5.4 09/19] nvme-pci: ignore the subsysem NQN on Phison E16
Date:   Mon,  8 Feb 2021 12:58:48 -0500
Message-Id: <20210208175858.2092008-9-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210208175858.2092008-1-sashal@kernel.org>
References: <20210208175858.2092008-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Claus Stovgaard <claus.stovgaard@gmail.com>

[ Upstream commit c9e95c39280530200cdd0bbd2670e6334a81970b ]

Tested both with Corsairs firmware 11.3 and 13.0 for the Corsairs MP600
and both have the issue as reported by the kernel.

nvme nvme0: missing or invalid SUBNQN field.

Signed-off-by: Claus Stovgaard <claus.stovgaard@gmail.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/pci.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index ef93bd3ed339c..511992b86399d 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -3147,6 +3147,8 @@ static const struct pci_device_id nvme_id_table[] = {
 	{ PCI_DEVICE(0x144d, 0xa822),   /* Samsung PM1725a */
 		.driver_data = NVME_QUIRK_DELAY_BEFORE_CHK_RDY |
 				NVME_QUIRK_IGNORE_DEV_SUBNQN, },
+	{ PCI_DEVICE(0x1987, 0x5016),	/* Phison E16 */
+		.driver_data = NVME_QUIRK_IGNORE_DEV_SUBNQN, },
 	{ PCI_DEVICE(0x1d1d, 0x1f1f),	/* LighNVM qemu device */
 		.driver_data = NVME_QUIRK_LIGHTNVM, },
 	{ PCI_DEVICE(0x1d1d, 0x2807),	/* CNEX WL */
-- 
2.27.0

