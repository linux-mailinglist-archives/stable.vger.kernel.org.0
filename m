Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B681B18B464
	for <lists+stable@lfdr.de>; Thu, 19 Mar 2020 14:09:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728304AbgCSNJ1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Mar 2020 09:09:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:53928 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728331AbgCSNJ1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Mar 2020 09:09:27 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 42C1820789;
        Thu, 19 Mar 2020 13:09:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584623366;
        bh=afazES3LJUgiIS1Fm0X0rEFWfns6OqumedveuowKv8Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ys0XafyJ5AFEKHg4YTImEwUdB9IvEzhZ5PD88aGeHVdWwwTAqJO7rgDXjIpDx4upc
         Fy/x+n0iGOQfbar3lcFgEP3ILbN/CFLzLjKOX51NDS6pVYAJYHoG+oscWIw0pN+L60
         EFhYBoqT2fg9wk4t4Nj439em34C/Wmlsl8wVBeW0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sven Eckelmann <sven@narfation.org>,
        Simon Wunderlich <sw@simonwunderlich.de>
Subject: [PATCH 4.4 79/93] batman-adv: Prevent duplicated tvlv handler
Date:   Thu, 19 Mar 2020 14:00:23 +0100
Message-Id: <20200319123949.663710173@linuxfoundation.org>
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

commit ae3cdc97dc10c7a3b31f297dab429bfb774c9ccb upstream.

The function batadv_tvlv_handler_register is responsible for adding new
tvlv_handler to the handler_list. It first checks whether the entry
already is in the list or not. If it is, then the creation of a new entry
is aborted.

But the lock for the list is only held when the list is really modified.
This could lead to duplicated entries because another context could create
an entry with the same key between the check and the list manipulation.

The check and the manipulation of the list must therefore be in the same
locked code section.

Fixes: ef26157747d4 ("batman-adv: tvlv - basic infrastructure")
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Simon Wunderlich <sw@simonwunderlich.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/batman-adv/main.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/net/batman-adv/main.c
+++ b/net/batman-adv/main.c
@@ -1079,15 +1079,20 @@ void batadv_tvlv_handler_register(struct
 {
 	struct batadv_tvlv_handler *tvlv_handler;
 
+	spin_lock_bh(&bat_priv->tvlv.handler_list_lock);
+
 	tvlv_handler = batadv_tvlv_handler_get(bat_priv, type, version);
 	if (tvlv_handler) {
+		spin_unlock_bh(&bat_priv->tvlv.handler_list_lock);
 		batadv_tvlv_handler_free_ref(tvlv_handler);
 		return;
 	}
 
 	tvlv_handler = kzalloc(sizeof(*tvlv_handler), GFP_ATOMIC);
-	if (!tvlv_handler)
+	if (!tvlv_handler) {
+		spin_unlock_bh(&bat_priv->tvlv.handler_list_lock);
 		return;
+	}
 
 	tvlv_handler->ogm_handler = optr;
 	tvlv_handler->unicast_handler = uptr;
@@ -1097,7 +1102,6 @@ void batadv_tvlv_handler_register(struct
 	atomic_set(&tvlv_handler->refcount, 1);
 	INIT_HLIST_NODE(&tvlv_handler->list);
 
-	spin_lock_bh(&bat_priv->tvlv.handler_list_lock);
 	hlist_add_head_rcu(&tvlv_handler->list, &bat_priv->tvlv.handler_list);
 	spin_unlock_bh(&bat_priv->tvlv.handler_list_lock);
 }


