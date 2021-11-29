Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E75D462718
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 23:59:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236482AbhK2XBD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 18:01:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237089AbhK2XAn (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 18:00:43 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55511C19AC2D;
        Mon, 29 Nov 2021 10:36:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id A1507CE140F;
        Mon, 29 Nov 2021 18:35:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F727C53FCF;
        Mon, 29 Nov 2021 18:35:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638210956;
        bh=v5jZUFqVFVOKMQhLN9SZvmpfgTrZzBxNCJl37Olwrfk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mIBGQ+hgA5NSwJjM6H8ogyfDlKx5CYa6MPxArKBZcs+LjUt6Dr8hHIQht3eEh3P7V
         ytlqpUaadyR4Qft1EB74/KSq/xYhK7QZnsLWZrsZVbMjsV/oEh3Ks5RSoJgyo68MgE
         YStxMw8NSBf7eJm6luo8+GmbUMEUkCdlV2uDrFPA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Joel Stanley <joel@jms.id.au>,
        Dylan Hung <dylan_hung@aspeedtech.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.15 052/179] mdio: aspeed: Fix "Link is Down" issue
Date:   Mon, 29 Nov 2021 19:17:26 +0100
Message-Id: <20211129181720.689294208@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211129181718.913038547@linuxfoundation.org>
References: <20211129181718.913038547@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dylan Hung <dylan_hung@aspeedtech.com>

commit 9dbe33cf371bd70330858370bdbc35c7668f00c3 upstream.

The issue happened randomly in runtime.  The message "Link is Down" is
popped but soon it recovered to "Link is Up".

The "Link is Down" results from the incorrect read data for reading the
PHY register via MDIO bus.  The correct sequence for reading the data
shall be:
1. fire the command
2. wait for command done (this step was missing)
3. wait for data idle
4. read data from data register

Cc: stable@vger.kernel.org
Fixes: f160e99462c6 ("net: phy: Add mdio-aspeed")
Reviewed-by: Joel Stanley <joel@jms.id.au>
Signed-off-by: Dylan Hung <dylan_hung@aspeedtech.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Link: https://lore.kernel.org/r/20211125024432.15809-1-dylan_hung@aspeedtech.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/mdio/mdio-aspeed.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/net/mdio/mdio-aspeed.c
+++ b/drivers/net/mdio/mdio-aspeed.c
@@ -61,6 +61,13 @@ static int aspeed_mdio_read(struct mii_b
 
 	iowrite32(ctrl, ctx->base + ASPEED_MDIO_CTRL);
 
+	rc = readl_poll_timeout(ctx->base + ASPEED_MDIO_CTRL, ctrl,
+				!(ctrl & ASPEED_MDIO_CTRL_FIRE),
+				ASPEED_MDIO_INTERVAL_US,
+				ASPEED_MDIO_TIMEOUT_US);
+	if (rc < 0)
+		return rc;
+
 	rc = readl_poll_timeout(ctx->base + ASPEED_MDIO_DATA, data,
 				data & ASPEED_MDIO_DATA_IDLE,
 				ASPEED_MDIO_INTERVAL_US,


