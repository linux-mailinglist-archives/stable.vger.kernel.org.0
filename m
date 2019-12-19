Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 663B9126BCA
	for <lists+stable@lfdr.de>; Thu, 19 Dec 2019 19:59:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729827AbfLSSxn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Dec 2019 13:53:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:48776 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728094AbfLSSxh (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Dec 2019 13:53:37 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E4CAE227BF;
        Thu, 19 Dec 2019 18:53:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576781617;
        bh=ucJ+V5glhCXln4MzXaYgFohgfHJ6uLS0a44tUYdw7TI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=T+XvGvuEzLtB7ShkVX31oOeOWg/Fgl4mlxHmVmJ+p7xHvH1cFyRFfuDxvl33GZco0
         sZ/GuSfrw2irprA7QS2rPYLprHHsH6hPz0kTpIWx531D8vlKw9q2h5ypPMgJDtRYX2
         8SYjO/V24ryVRCxpRUhe03Dl0G2fE65xBfie5RmE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Subbaraya Sundeep <sbhatta@marvell.com>,
        Bjorn Helgaas <bhelgaas@google.com>
Subject: [PATCH 5.4 11/80] PCI: Do not use bus number zero from EA capability
Date:   Thu, 19 Dec 2019 19:34:03 +0100
Message-Id: <20191219183046.533695967@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191219183031.278083125@linuxfoundation.org>
References: <20191219183031.278083125@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Subbaraya Sundeep <sbhatta@marvell.com>

commit 73884a7082f466ce6686bb8dd7e6571dd42313b4 upstream.

As per PCIe r5.0, sec 7.8.5.2, fixed bus numbers of a bridge must be zero
when no function that uses EA is located behind it.  Hence, if EA supplies
bus numbers of zero, assign bus numbers normally.  A secondary bus can
never have a bus number of zero, so setting a bridge's Secondary Bus Number
to zero makes downstream devices unreachable.

[bhelgaas: retain bool return value so "zero is invalid" logic is local]
Fixes: 2dbce5901179 ("PCI: Assign bus numbers present in EA capability for bridges")
Link: https://lore.kernel.org/r/1572850664-9861-1-git-send-email-sundeep.lkml@gmail.com
Signed-off-by: Subbaraya Sundeep <sbhatta@marvell.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Cc: stable@vger.kernel.org	# v5.2+
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/pci/probe.c |   16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

--- a/drivers/pci/probe.c
+++ b/drivers/pci/probe.c
@@ -1089,14 +1089,15 @@ static unsigned int pci_scan_child_bus_e
  * @sec: updated with secondary bus number from EA
  * @sub: updated with subordinate bus number from EA
  *
- * If @dev is a bridge with EA capability, update @sec and @sub with
- * fixed bus numbers from the capability and return true.  Otherwise,
- * return false.
+ * If @dev is a bridge with EA capability that specifies valid secondary
+ * and subordinate bus numbers, return true with the bus numbers in @sec
+ * and @sub.  Otherwise return false.
  */
 static bool pci_ea_fixed_busnrs(struct pci_dev *dev, u8 *sec, u8 *sub)
 {
 	int ea, offset;
 	u32 dw;
+	u8 ea_sec, ea_sub;
 
 	if (dev->hdr_type != PCI_HEADER_TYPE_BRIDGE)
 		return false;
@@ -1108,8 +1109,13 @@ static bool pci_ea_fixed_busnrs(struct p
 
 	offset = ea + PCI_EA_FIRST_ENT;
 	pci_read_config_dword(dev, offset, &dw);
-	*sec =  dw & PCI_EA_SEC_BUS_MASK;
-	*sub = (dw & PCI_EA_SUB_BUS_MASK) >> PCI_EA_SUB_BUS_SHIFT;
+	ea_sec =  dw & PCI_EA_SEC_BUS_MASK;
+	ea_sub = (dw & PCI_EA_SUB_BUS_MASK) >> PCI_EA_SUB_BUS_SHIFT;
+	if (ea_sec  == 0 || ea_sub < ea_sec)
+		return false;
+
+	*sec = ea_sec;
+	*sub = ea_sub;
 	return true;
 }
 


