Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D3942F7E3B
	for <lists+stable@lfdr.de>; Mon, 11 Nov 2019 20:02:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729030AbfKKSt0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Nov 2019 13:49:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:42742 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729712AbfKKStZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Nov 2019 13:49:25 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 75DFB204FD;
        Mon, 11 Nov 2019 18:49:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573498165;
        bh=2u78YOH1CKUD4oplC5AJbBt7K9sYVMHVctpMzgvfTek=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0ufAT8mt+n0QZXKMzj++ZwfdBKp2H9LlwWEzgFuslvmWQqk5+qO52Ifnm9oELgnQK
         W5M2ZqGMLAslzpDvCtTEolyEN1o+ENNzvGFzKYuY1bifN8JFsFgni8S68kecmJSGMB
         qPZzQeYVQhF5x2uST6YEYe9lEz8sf8Ezmx49aJpE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.3 024/193] r8169: fix page read in r8168g_mdio_read
Date:   Mon, 11 Nov 2019 19:26:46 +0100
Message-Id: <20191111181502.003357086@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191111181459.850623879@linuxfoundation.org>
References: <20191111181459.850623879@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Heiner Kallweit <hkallweit1@gmail.com>

[ Upstream commit 9c6850fea3edefef6e7153b2c466f09155399882 ]

Functions like phy_modify_paged() read the current page, on Realtek
PHY's this means reading the value of register 0x1f. Add special
handling for reading this register, similar to what we do already
in r8168g_mdio_write(). Currently we read a random value that by
chance seems to be 0 always.

Fixes: a2928d28643e ("r8169: use paged versions of phylib MDIO access functions")
Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/realtek/r8169_main.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -863,6 +863,9 @@ static void r8168g_mdio_write(struct rtl
 
 static int r8168g_mdio_read(struct rtl8169_private *tp, int reg)
 {
+	if (reg == 0x1f)
+		return tp->ocp_base == OCP_STD_PHY_BASE ? 0 : tp->ocp_base >> 4;
+
 	if (tp->ocp_base != OCP_STD_PHY_BASE)
 		reg -= 0x10;
 


