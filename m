Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C186C18B424
	for <lists+stable@lfdr.de>; Thu, 19 Mar 2020 14:08:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727774AbgCSNGw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Mar 2020 09:06:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:50260 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727770AbgCSNGv (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Mar 2020 09:06:51 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4DB8C20732;
        Thu, 19 Mar 2020 13:06:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584623210;
        bh=ybMxabZn+LAHW5r0IG3LlRQP9yHidLzv795RMLLHfhA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KeEY22qDnh/DdvSoqftFCFkoMbtpdmZwWlRgf3o29WN/TnF25oJF4DbaU7JkzPYjj
         OnGzRSU5maN7eY41HcfFzAXOjVLAJ+UoDZU2FwwHsbIyLLmyJr1+7b4xX8P0HgobER
         g2eq7JkctGlxBqWwWhJrXvrJ7X7leodKVCl/6ZgU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Matthias Schiffer <mschiffer@universe-factory.net>,
        Sven Eckelmann <sven@narfation.org>,
        Marek Lindner <mareklindner@neomailbox.ch>,
        Antonio Quartulli <a@unstable.cc>
Subject: [PATCH 4.4 45/93] batman-adv: Deactivate TO_BE_ACTIVATED hardif on shutdown
Date:   Thu, 19 Mar 2020 13:59:49 +0100
Message-Id: <20200319123939.275764946@linuxfoundation.org>
X-Mailer: git-send-email 2.25.2
In-Reply-To: <20200319123924.795019515@linuxfoundation.org>
References: <20200319123924.795019515@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sven Eckelmann <sven@narfation.org>

commit f2d23861b818d08bcd15cc1612ae94aa33b3931c upstream.

The shutdown of an batman-adv interface can happen with one of its slave
interfaces still being in the BATADV_IF_TO_BE_ACTIVATED state. A possible
reason for it is that the routing algorithm BATMAN_V was selected and
batadv_schedule_bat_ogm was not yet called for this interface. This slave
interface still has to be set to BATADV_IF_INACTIVE or the batman-adv
interface will never reduce its usage counter and thus never gets shutdown.

This problem can be simulated via:

    $ modprobe dummy
    $ modprobe batman-adv routing_algo=BATMAN_V
    $ ip link add bat0 type batadv
    $ ip link set dummy0 master bat0
    $ ip link set dummy0 up
    $ ip link del bat0
    unregister_netdevice: waiting for bat0 to become free. Usage count = 3

Reported-by: Matthias Schiffer <mschiffer@universe-factory.net>
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Marek Lindner <mareklindner@neomailbox.ch>
Signed-off-by: Antonio Quartulli <a@unstable.cc>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/batman-adv/hard-interface.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/net/batman-adv/hard-interface.c
+++ b/net/batman-adv/hard-interface.c
@@ -562,8 +562,7 @@ void batadv_hardif_disable_interface(str
 	struct batadv_priv *bat_priv = netdev_priv(hard_iface->soft_iface);
 	struct batadv_hard_iface *primary_if = NULL;
 
-	if (hard_iface->if_status == BATADV_IF_ACTIVE)
-		batadv_hardif_deactivate_interface(hard_iface);
+	batadv_hardif_deactivate_interface(hard_iface);
 
 	if (hard_iface->if_status != BATADV_IF_INACTIVE)
 		goto out;


