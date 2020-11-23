Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE6F72C0849
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 14:16:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732817AbgKWMrX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 07:47:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:32790 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732811AbgKWMrU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Nov 2020 07:47:20 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3A88C20732;
        Mon, 23 Nov 2020 12:47:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606135639;
        bh=8VlL8wXys/FUVKU0xshPjPqgDI98Hm+FeoxhuntYsIQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2KNdOFcQOenIrlQxuJkgQVjpiY+cCZVOAEMN9Bm9TXn7g5iZlMr9c57fI14IWkOmx
         BvtVMqxb/rmBSHDWihvae+HmYhWn86WVYPghAdOWDr283ynzVQHXd3aa5PwW1Xbxey
         lgyUgFklrCl9RzCpCNYcZWPXLLnpHYsnyeMI1ie8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marc Kleine-Budde <mkl@pengutronix.de>,
        Dan Murphy <dmurphy@ti.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 140/252] can: m_can: m_can_class_free_dev(): introduce new function
Date:   Mon, 23 Nov 2020 13:21:30 +0100
Message-Id: <20201123121842.355071524@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201123121835.580259631@linuxfoundation.org>
References: <20201123121835.580259631@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Murphy <dmurphy@ti.com>

[ Upstream commit a8c22f5b0c689a29f45ef4a110d09fd391debcbc ]

This patch creates a common function that peripherials can call to free the
netdev device when failures occur.

Fixes: f524f829b75a ("can: m_can: Create a m_can platform framework")
Reported-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Dan Murphy <dmurphy@ti.com>
Link: http://lore.kernel.org/r/20200227183829.21854-2-dmurphy@ti.com
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/can/m_can/m_can.c | 6 ++++++
 drivers/net/can/m_can/m_can.h | 1 +
 2 files changed, 7 insertions(+)

diff --git a/drivers/net/can/m_can/m_can.c b/drivers/net/can/m_can/m_can.c
index 63887e23d89c0..f2c87b76e5692 100644
--- a/drivers/net/can/m_can/m_can.c
+++ b/drivers/net/can/m_can/m_can.c
@@ -1812,6 +1812,12 @@ out:
 }
 EXPORT_SYMBOL_GPL(m_can_class_allocate_dev);
 
+void m_can_class_free_dev(struct net_device *net)
+{
+	free_candev(net);
+}
+EXPORT_SYMBOL_GPL(m_can_class_free_dev);
+
 int m_can_class_register(struct m_can_classdev *m_can_dev)
 {
 	int ret;
diff --git a/drivers/net/can/m_can/m_can.h b/drivers/net/can/m_can/m_can.h
index 49f42b50627a1..b2699a7c99973 100644
--- a/drivers/net/can/m_can/m_can.h
+++ b/drivers/net/can/m_can/m_can.h
@@ -99,6 +99,7 @@ struct m_can_classdev {
 };
 
 struct m_can_classdev *m_can_class_allocate_dev(struct device *dev);
+void m_can_class_free_dev(struct net_device *net);
 int m_can_class_register(struct m_can_classdev *cdev);
 void m_can_class_unregister(struct m_can_classdev *cdev);
 int m_can_class_get_clocks(struct m_can_classdev *cdev);
-- 
2.27.0



