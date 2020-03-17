Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A304C1891F7
	for <lists+stable@lfdr.de>; Wed, 18 Mar 2020 00:27:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727023AbgCQX1v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Mar 2020 19:27:51 -0400
Received: from dvalin.narfation.org ([213.160.73.56]:53462 "EHLO
        dvalin.narfation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726965AbgCQX1v (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 Mar 2020 19:27:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=narfation.org;
        s=20121; t=1584487669;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=loelqplKyfhJi/AtwjAU48Bw2x2Kse1COrVqRB/J8sU=;
        b=qJTzMOezVDL9wBR7sAvUAmrR4/5V+fP5wFINHiAe54Max2d1wWwBRrZrFr2vSlQ8VK7ZFA
        FeVE7KVRgQpL/yJTHnf21WdW8r4UZq/PUd4oo/lGH1KY8idvgwYX5xHL/Fyh+67YRLXF2n
        vBHjF2DBFrhYLX8EuX8YUIzzQLmnIEU=
From:   Sven Eckelmann <sven@narfation.org>
To:     stable@vger.kernel.org
Cc:     Sven Eckelmann <sven@narfation.org>,
        Matthias Schiffer <mschiffer@universe-factory.net>,
        Marek Lindner <mareklindner@neomailbox.ch>,
        Antonio Quartulli <a@unstable.cc>
Subject: [PATCH 4.4 08/48] batman-adv: Deactivate TO_BE_ACTIVATED hardif on shutdown
Date:   Wed, 18 Mar 2020 00:26:54 +0100
Message-Id: <20200317232734.6127-9-sven@narfation.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200317232734.6127-1-sven@narfation.org>
References: <20200317232734.6127-1-sven@narfation.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
---
 net/batman-adv/hard-interface.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/batman-adv/hard-interface.c b/net/batman-adv/hard-interface.c
index 933f36012ae6..ecaa68ae62f5 100644
--- a/net/batman-adv/hard-interface.c
+++ b/net/batman-adv/hard-interface.c
@@ -562,8 +562,7 @@ void batadv_hardif_disable_interface(struct batadv_hard_iface *hard_iface,
 	struct batadv_priv *bat_priv = netdev_priv(hard_iface->soft_iface);
 	struct batadv_hard_iface *primary_if = NULL;
 
-	if (hard_iface->if_status == BATADV_IF_ACTIVE)
-		batadv_hardif_deactivate_interface(hard_iface);
+	batadv_hardif_deactivate_interface(hard_iface);
 
 	if (hard_iface->if_status != BATADV_IF_INACTIVE)
 		goto out;
-- 
2.20.1

