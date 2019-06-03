Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0198B32C72
	for <lists+stable@lfdr.de>; Mon,  3 Jun 2019 11:17:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727963AbfFCJLg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Jun 2019 05:11:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:56688 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728418AbfFCJLd (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Jun 2019 05:11:33 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7614A27E66;
        Mon,  3 Jun 2019 09:11:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559553093;
        bh=M70iY75YB6uFHmdLogfmBSj+VIsEpj2o7JIN4Idf4uY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W8PL0J6o2z5gJ9cmOVK2OfGekSzw+HHLYUNmH2IrwQvg1AR5HL1J3zfKY67a1rt+G
         mXkOr4Q+MMulIAWls9wi7h3KwCr2V7yrmT5XO07kPFUaAPF6gvYjcPfIXcaunAf+dK
         shtA4LsJYuuuWY6rolyn7y52oE1USslu54S9KFQk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Heiner Kallweit <hkallweit1@gmail.com>,
        Albert Astals Cid <aacid@kde.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.0 18/36] r8169: fix MAC address being lost in PCI D3
Date:   Mon,  3 Jun 2019 11:09:06 +0200
Message-Id: <20190603090522.186695240@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190603090520.998342694@linuxfoundation.org>
References: <20190603090520.998342694@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Heiner Kallweit <hkallweit1@gmail.com>

[ Upstream commit 59715171fbd0172a579576f46821031800a63bc5 ]

(At least) RTL8168e forgets its MAC address in PCI D3. To fix this set
the MAC address when resuming. For resuming from runtime-suspend we
had this in place already, for resuming from S3/S5 it was missing.

The commit referenced as being fixed isn't wrong, it's just the first
one where the patch applies cleanly.

Fixes: 0f07bd850d36 ("r8169: use dev_get_drvdata where possible")
Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
Reported-by: Albert Astals Cid <aacid@kde.org>
Tested-by: Albert Astals Cid <aacid@kde.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/realtek/r8169.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/net/ethernet/realtek/r8169.c
+++ b/drivers/net/ethernet/realtek/r8169.c
@@ -6814,6 +6814,8 @@ static int rtl8169_resume(struct device
 	struct net_device *dev = dev_get_drvdata(device);
 	struct rtl8169_private *tp = netdev_priv(dev);
 
+	rtl_rar_set(tp, dev->dev_addr);
+
 	clk_prepare_enable(tp->clk);
 
 	if (netif_running(dev))
@@ -6847,6 +6849,7 @@ static int rtl8169_runtime_resume(struct
 {
 	struct net_device *dev = dev_get_drvdata(device);
 	struct rtl8169_private *tp = netdev_priv(dev);
+
 	rtl_rar_set(tp, dev->dev_addr);
 
 	if (!tp->TxDescArray)


