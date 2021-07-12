Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6FDF3C470A
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:26:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237414AbhGLGbF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:31:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:52288 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236012AbhGLG3l (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:29:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5C44260238;
        Mon, 12 Jul 2021 06:26:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626071202;
        bh=0F/rq31OCCk7x9qfmJ/SKEHpQ1AaCMN4jJlM0SQv6rY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rBSQhvzlHiJKHMBFJLgF1VhZhD5Ze0O6yQSZMIS2P3dNQxMP6dlejzbA+kEsL3b6z
         dtll9mAWYM4SAHhuQuC0IjSsCrSuTsDlyNZDUR89V+rCdJ4YV5etMBIpI/L+VtN26x
         0zwaU/cI1P/WmuyqrNLUDmiX1Vq6TKtElLwmfy24=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sergio Paracuellos <sergio.paracuellos@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 318/348] staging: mt7621-dts: fix pci address for PCI memory range
Date:   Mon, 12 Jul 2021 08:11:42 +0200
Message-Id: <20210712060746.150888276@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060659.886176320@linuxfoundation.org>
References: <20210712060659.886176320@linuxfoundation.org>
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
index a4c08110094b..5ca8607c5dbb 100644
--- a/drivers/staging/mt7621-dts/mt7621.dtsi
+++ b/drivers/staging/mt7621-dts/mt7621.dtsi
@@ -520,7 +520,7 @@
 
 		bus-range = <0 255>;
 		ranges = <
-			0x02000000 0 0x00000000 0x60000000 0 0x10000000 /* pci memory */
+			0x02000000 0 0x60000000 0x60000000 0 0x10000000 /* pci memory */
 			0x01000000 0 0x00000000 0x1e160000 0 0x00010000 /* io space */
 		>;
 
-- 
2.30.2



