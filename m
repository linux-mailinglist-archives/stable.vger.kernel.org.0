Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 76E9AF5590
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 21:02:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390724AbfKHTDO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 14:03:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:32856 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390717AbfKHTDN (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Nov 2019 14:03:13 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C1B802067B;
        Fri,  8 Nov 2019 19:03:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573239793;
        bh=BW5LGtpYsgo3Aw65GJewEZVruUL09Go2QLUOlLxvtdo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sZK2IZw0qbVMy0nYUpR1fPhJ66ZBqtUylB/Mxy72kAF+B/GT5n85nXYJa2KJas+e2
         YMA1dXZYnymyuAvAEH/4CP9r+G70UgZwRH3g9+usPAJMsFnQ8iV9ve0ekwv1nhdV/L
         sbS3HZeaASVwGRw7lAy+vVzDXX7RNlXUSngXpGzw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.19 62/79] r8169: fix wrong PHY ID issue with RTL8168dp
Date:   Fri,  8 Nov 2019 19:50:42 +0100
Message-Id: <20191108174820.977499466@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191108174745.495640141@linuxfoundation.org>
References: <20191108174745.495640141@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Heiner Kallweit <hkallweit1@gmail.com>

[ Upstream commit 62bdc8fd1c21d4263ebd18bec57f82532d09249f ]

As reported in [0] at least one RTL8168dp version has problems
establishing a link. This chip version has an integrated RTL8211b PHY,
however the chip seems to report a wrong PHY ID, resulting in a wrong
PHY driver (for Generic Realtek PHY) being loaded.
Work around this issue by adding a hook to r8168dp_2_mdio_read()
for returning the correct PHY ID.

[0] https://bbs.archlinux.org/viewtopic.php?id=246508

Fixes: 242cd9b5866a ("r8169: use phy_resume/phy_suspend")
Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/realtek/r8169.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/net/ethernet/realtek/r8169.c
+++ b/drivers/net/ethernet/realtek/r8169.c
@@ -1010,6 +1010,10 @@ static int r8168dp_2_mdio_read(struct rt
 {
 	int value;
 
+	/* Work around issue with chip reporting wrong PHY ID */
+	if (reg == MII_PHYSID2)
+		return 0xc912;
+
 	r8168dp_2_mdio_start(tp);
 
 	value = r8169_mdio_read(tp, reg);


