Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACAA53C5587
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:55:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230374AbhGLIKp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 04:10:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:55108 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1353729AbhGLICs (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 04:02:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 245F761CF2;
        Mon, 12 Jul 2021 07:56:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626076619;
        bh=J0QRumCZXbXENKYb9qBhmLG0pX6eRUnOrmshvKZnMfU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CLWmNqbwglVCQA+ChNkviaMyTs+0wPD8YvpTulveu6XWLio6FP22PRO3GVbEnK31l
         zeua8KqUA5r1wj9EPc+RbprJJjyLTnHy8cnEEGZyb0+ajKSzwtJmDDrQZqIB324I2U
         0FqF5GGqZ3RigTNrOwuINMjZBm+6dgcFi4oEHmIY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sergio Paracuellos <sergio.paracuellos@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 721/800] staging: mt7621-dts: fix pci address for PCI memory range
Date:   Mon, 12 Jul 2021 08:12:24 +0200
Message-Id: <20210712061043.452025890@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
References: <20210712060912.995381202@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sergio Paracuellos <sergio.paracuellos@gmail.com>

[ Upstream commit 5b4f167ef3555ec4c334a8dc89c1b44bb2c6bff5 ]

Driver code call 'devm_of_pci_get_host_bridge_resources'
to get resources and properly fill 'bridge->windows' and
'bridge->dma_ranges'. After parsing the ranges and store
as resources, at the end it makes a call to pci function
'pci_add_resource_offset' to set the offset for the
memory resource. To calculate offset, resource start address
subtracts pci address of the range. MT7621 does not need
any offset for the memory resource. Moreover, setting an
offset got into 'WARN_ON' calls from pci devices driver code.
Until now memory range pci_addr was being '0x00000000' and
res->start is '0x60000000' but becase pci controller driver
was manually setting resources and adding them using pci function
'pci_add_resource' where a zero is passed as offset, things
was properly working. Since PCI_IOBASE is defined now for
ralink we don't set nothing manually anymore so we have to
properly fix PCI address for this range to make things work
and the new pci address must be set to '0x60000000'. Doing
in this way the subtract result obtain zero as offset
and pci device driver code properly works.

Fixes: d59578da2bb8 ("staging: mt7621-dts: add dts files")
Signed-off-by: Sergio Paracuellos <sergio.paracuellos@gmail.com>
Link: https://lore.kernel.org/r/20210614100617.28753-4-sergio.paracuellos@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/mt7621-dts/mt7621.dtsi | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/mt7621-dts/mt7621.dtsi b/drivers/staging/mt7621-dts/mt7621.dtsi
index f0c9ae757bcd..d6628e5f4f66 100644
--- a/drivers/staging/mt7621-dts/mt7621.dtsi
+++ b/drivers/staging/mt7621-dts/mt7621.dtsi
@@ -498,7 +498,7 @@
 
 		bus-range = <0 255>;
 		ranges = <
-			0x02000000 0 0x00000000 0x60000000 0 0x10000000 /* pci memory */
+			0x02000000 0 0x60000000 0x60000000 0 0x10000000 /* pci memory */
 			0x01000000 0 0x00000000 0x1e160000 0 0x00010000 /* io space */
 		>;
 
-- 
2.30.2



