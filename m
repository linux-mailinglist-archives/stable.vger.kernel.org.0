Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BC6D2F797D
	for <lists+stable@lfdr.de>; Fri, 15 Jan 2021 13:38:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387920AbhAOMhK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jan 2021 07:37:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:44410 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732641AbhAOMhJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 15 Jan 2021 07:37:09 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B9A4A207C4;
        Fri, 15 Jan 2021 12:36:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610714189;
        bh=UWNYTAwPLeQZQRwdYZlc5rsHmDakLpWWE+cRKvJCyOM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fFW1Y0gvOoB3v4flMCa3PoxLQ57z9MziCPl6Vwk+gF0mI24uIxifElkWEwT4gq2Uq
         3W6aUSa+zBnd8HwFGhIrVYTrO8eS8PgVbgcCyrEhS7ovM2PT5wZS4846YmGQ5M7m5D
         dBAgxgCiie0FZysU/INNbbN2CLE+BHv/GsuUULLE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 023/103] net: bareudp: add missing error handling for bareudp_link_config()
Date:   Fri, 15 Jan 2021 13:27:16 +0100
Message-Id: <20210115122007.174053342@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210115122006.047132306@linuxfoundation.org>
References: <20210115122006.047132306@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit 94bcfdbff0c210b17b27615f4952cc6ece7d5f5f ]

.dellink does not get called after .newlink fails,
bareudp_newlink() must undo what bareudp_configure()
has done if bareudp_link_config() fails.

v2: call bareudp_dellink(), like bareudp_dev_create() does

Fixes: 571912c69f0e ("net: UDP tunnel encapsulation module for tunnelling different protocols like MPLS, IP, NSH etc.")
Link: https://lore.kernel.org/r/20210105190725.1736246-1-kuba@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/bareudp.c |   22 ++++++++++++++--------
 1 file changed, 14 insertions(+), 8 deletions(-)

--- a/drivers/net/bareudp.c
+++ b/drivers/net/bareudp.c
@@ -645,11 +645,20 @@ static int bareudp_link_config(struct ne
 	return 0;
 }
 
+static void bareudp_dellink(struct net_device *dev, struct list_head *head)
+{
+	struct bareudp_dev *bareudp = netdev_priv(dev);
+
+	list_del(&bareudp->next);
+	unregister_netdevice_queue(dev, head);
+}
+
 static int bareudp_newlink(struct net *net, struct net_device *dev,
 			   struct nlattr *tb[], struct nlattr *data[],
 			   struct netlink_ext_ack *extack)
 {
 	struct bareudp_conf conf;
+	LIST_HEAD(list_kill);
 	int err;
 
 	err = bareudp2info(data, &conf, extack);
@@ -662,17 +671,14 @@ static int bareudp_newlink(struct net *n
 
 	err = bareudp_link_config(dev, tb);
 	if (err)
-		return err;
+		goto err_unconfig;
 
 	return 0;
-}
-
-static void bareudp_dellink(struct net_device *dev, struct list_head *head)
-{
-	struct bareudp_dev *bareudp = netdev_priv(dev);
 
-	list_del(&bareudp->next);
-	unregister_netdevice_queue(dev, head);
+err_unconfig:
+	bareudp_dellink(dev, &list_kill);
+	unregister_netdevice_many(&list_kill);
+	return err;
 }
 
 static size_t bareudp_get_size(const struct net_device *dev)


