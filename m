Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 354FCF56C2
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 21:04:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391942AbfKHTKx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 14:10:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:43228 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389656AbfKHTKx (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Nov 2019 14:10:53 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 59AF721D82;
        Fri,  8 Nov 2019 19:10:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573240252;
        bh=BLtrOtnub7LSTPsUgTcVqvc3DdOlGwM06VlUWBIztuE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DHARY4Ne1c1s0QnE//qWOEqAH//ie2GCuqcHzlet9TOFKcY01puieHnDnU0Yhq6a3
         /Docxbac8EkZqmHVu2GSISoK6adusfuShUFMj1QHR1M4OnePQWzou/TPX5ZuVnbynP
         K+6fq0qmt+JYI8OgyB5bEveN/PQkX+XVJZZzo27A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.3 117/140] r8169: fix wrong PHY ID issue with RTL8168dp
Date:   Fri,  8 Nov 2019 19:50:45 +0100
Message-Id: <20191108174912.169385668@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191108174900.189064908@linuxfoundation.org>
References: <20191108174900.189064908@linuxfoundation.org>
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
 drivers/net/ethernet/realtek/r8169_main.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -976,6 +976,10 @@ static int r8168dp_2_mdio_read(struct rt
 {
 	int value;
 
+	/* Work around issue with chip reporting wrong PHY ID */
+	if (reg == MII_PHYSID2)
+		return 0xc912;
+
 	r8168dp_2_mdio_start(tp);
 
 	value = r8169_mdio_read(tp, reg);


