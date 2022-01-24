Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9924649A509
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 03:11:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2370538AbiAYAFX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 19:05:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1850578AbiAXXaS (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 18:30:18 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1EF6C0A893D;
        Mon, 24 Jan 2022 13:34:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8FFFB614CB;
        Mon, 24 Jan 2022 21:34:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57864C340E4;
        Mon, 24 Jan 2022 21:34:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643060083;
        bh=Tv4PxFP5LAWncL+Y1W8hwk/yXQ3k+Pf7N6zUzlrRQMU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qOgfOYSlA4By0zrl+pCiS1P3qkKDnEZkS+k2WQ5t7jOLfly4Gwz3QM2DOcLpPFSxZ
         iMpTY2sq5uKGn2Hu3ECg2rfB3rVXMFQovVXlfFp9t2uKoAhmjtqfhOJ5frc3VzNgX4
         0v8LGM7MAAQbf32+RKwOlx5Po6+CPW7GxAxruNMU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Pali=20Roh=C3=A1r?= <pali@kernel.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0800/1039] PCI: mvebu: Do not modify PCI IO type bits in conf_write
Date:   Mon, 24 Jan 2022 19:43:09 +0100
Message-Id: <20220124184152.190339459@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pali Rohár <pali@kernel.org>

[ Upstream commit 2cf150216e5b5619d7c25180ccf2cc8ac7bebc13 ]

PCI IO type bits are already initialized in mvebu_pci_bridge_emul_init()
function and only when IO support is enabled. These type bits are read-only
and pci-bridge-emul.c code already does not allow to modify them from upper
layers.

When IO support is disabled then all IO registers should be read-only and
return zeros. Therefore do not modify PCI IO type bits in
mvebu_pci_bridge_emul_base_conf_write() callback.

Link: https://lore.kernel.org/r/20211125124605.25915-8-pali@kernel.org
Fixes: 1f08673eef12 ("PCI: mvebu: Convert to PCI emulated bridge config space")
Signed-off-by: Pali Rohár <pali@kernel.org>
Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/pci-mvebu.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/drivers/pci/controller/pci-mvebu.c b/drivers/pci/controller/pci-mvebu.c
index e6d63ad4d23b8..beae555b06bbc 100644
--- a/drivers/pci/controller/pci-mvebu.c
+++ b/drivers/pci/controller/pci-mvebu.c
@@ -497,13 +497,6 @@ mvebu_pci_bridge_emul_base_conf_write(struct pci_bridge_emul *bridge,
 	}
 
 	case PCI_IO_BASE:
-		/*
-		 * We keep bit 1 set, it is a read-only bit that
-		 * indicates we support 32 bits addressing for the
-		 * I/O
-		 */
-		conf->iobase |= PCI_IO_RANGE_TYPE_32;
-		conf->iolimit |= PCI_IO_RANGE_TYPE_32;
 		mvebu_pcie_handle_iobase_change(port);
 		break;
 
-- 
2.34.1



