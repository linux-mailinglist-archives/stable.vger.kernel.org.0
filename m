Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 70CB2138D6
	for <lists+stable@lfdr.de>; Sat,  4 May 2019 12:28:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727314AbfEDK1A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 4 May 2019 06:27:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:36764 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727958AbfEDK05 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 4 May 2019 06:26:57 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1E90E20859;
        Sat,  4 May 2019 10:26:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556965616;
        bh=T3+TvoQx00KlNtioV5SS/qLaMlZYWs8rRDnJUY8hdfw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=L3FICoi0XcTGoVA7uq0e1GSNi63P+7WHBcwev3pi8NmwYTsUxoSRF3/WCNT7pDWej
         7Mbzrry1l3g1DSVFO1oVEtvgdcufBc6R7ZisFyvCWb8605tAWb+97YVAaoAdzjEzVZ
         PQ6NQEDlsDcC+EQYHhyBLS3xkl+KU9Hdi+qp6UYU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.0 09/32] net: phy: marvell: Fix buffer overrun with stats counters
Date:   Sat,  4 May 2019 12:24:54 +0200
Message-Id: <20190504102452.823647104@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190504102452.523724210@linuxfoundation.org>
References: <20190504102452.523724210@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrew Lunn <andrew@lunn.ch>

[ Upstream commit fdfdf86720a34527f777cbe0d8599bf0528fa146 ]

marvell_get_sset_count() returns how many statistics counters there
are. If the PHY supports fibre, there are 3, otherwise two.

marvell_get_strings() does not make this distinction, and always
returns 3 strings. This then often results in writing past the end
of the buffer for the strings.

Fixes: 2170fef78a40 ("Marvell phy: add field to get errors from fiber link.")
Signed-off-by: Andrew Lunn <andrew@lunn.ch>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/phy/marvell.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/net/phy/marvell.c
+++ b/drivers/net/phy/marvell.c
@@ -1494,9 +1494,10 @@ static int marvell_get_sset_count(struct
 
 static void marvell_get_strings(struct phy_device *phydev, u8 *data)
 {
+	int count = marvell_get_sset_count(phydev);
 	int i;
 
-	for (i = 0; i < ARRAY_SIZE(marvell_hw_stats); i++) {
+	for (i = 0; i < count; i++) {
 		strlcpy(data + i * ETH_GSTRING_LEN,
 			marvell_hw_stats[i].string, ETH_GSTRING_LEN);
 	}
@@ -1524,9 +1525,10 @@ static u64 marvell_get_stat(struct phy_d
 static void marvell_get_stats(struct phy_device *phydev,
 			      struct ethtool_stats *stats, u64 *data)
 {
+	int count = marvell_get_sset_count(phydev);
 	int i;
 
-	for (i = 0; i < ARRAY_SIZE(marvell_hw_stats); i++)
+	for (i = 0; i < count; i++)
 		data[i] = marvell_get_stat(phydev, i);
 }
 


