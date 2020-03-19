Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2493218B44D
	for <lists+stable@lfdr.de>; Thu, 19 Mar 2020 14:08:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728142AbgCSNI1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Mar 2020 09:08:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:52550 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727103AbgCSNIY (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Mar 2020 09:08:24 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4FC05208D5;
        Thu, 19 Mar 2020 13:08:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584623303;
        bh=CsQT18CPjTjTSx68+Br9l53FvcOFAGgFl8ji2Gx8FMI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TzrI35XuZsmEumHF7docExG3onYQfYwJLOO8Km6DWEGntn8DOk8payA71RKf16Yq3
         o8XDG0s3On+OQK2JDyVM+Qjrzqdc+Wtr/5OAQh8BYLI7kaDMuUKhAimzgsAm8BSpEO
         Wi8zzcRQk0+SyV/5mRJAWZjryoSD9MmOJdunTJh4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sven Eckelmann <sven@narfation.org>,
        Antonio Quartulli <a@unstable.cc>,
        Marek Lindner <mareklindner@neomailbox.ch>,
        Simon Wunderlich <sw@simonwunderlich.de>
Subject: [PATCH 4.4 60/93] batman-adv: Fix speedy join in gateway client mode
Date:   Thu, 19 Mar 2020 14:00:04 +0100
Message-Id: <20200319123943.958803953@linuxfoundation.org>
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

commit d1fe176ca51fa3cb35f70c1d876d9a090e9befce upstream.

Speedy join only works when the received packet is either broadcast or an
4addr unicast packet. Thus packets converted from broadcast to unicast via
the gateway handling code have to be converted to 4addr packets to allow
the receiving gateway server to add the sender address as temporary entry
to the translation table.

Not doing it will make the batman-adv gateway server drop the DHCP response
in many situations because it doesn't yet have the TT entry for the
destination of the DHCP response.

Fixes: 371351731e9c ("batman-adv: change interface_rx to get orig node")
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Acked-by: Antonio Quartulli <a@unstable.cc>
Signed-off-by: Marek Lindner <mareklindner@neomailbox.ch>
Signed-off-by: Simon Wunderlich <sw@simonwunderlich.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/batman-adv/send.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/net/batman-adv/send.c
+++ b/net/batman-adv/send.c
@@ -381,8 +381,8 @@ int batadv_send_skb_via_gw(struct batadv
 	struct batadv_orig_node *orig_node;
 
 	orig_node = batadv_gw_get_selected_orig(bat_priv);
-	return batadv_send_skb_unicast(bat_priv, skb, BATADV_UNICAST, 0,
-				       orig_node, vid);
+	return batadv_send_skb_unicast(bat_priv, skb, BATADV_UNICAST_4ADDR,
+				       BATADV_P_DATA, orig_node, vid);
 }
 
 void batadv_schedule_bat_ogm(struct batadv_hard_iface *hard_iface)


