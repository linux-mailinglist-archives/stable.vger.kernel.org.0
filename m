Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 74CB618B43E
	for <lists+stable@lfdr.de>; Thu, 19 Mar 2020 14:08:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728031AbgCSNHy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Mar 2020 09:07:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:51912 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728025AbgCSNHx (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Mar 2020 09:07:53 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EA38E2145D;
        Thu, 19 Mar 2020 13:07:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584623273;
        bh=AatKssUZRQ8LJvwUo44bHNF3GlMsy2YIDL9IpnLzi0E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fLPqom1Wwv7lYF5p/UeqJt87JDFZR2sBM5L2dY6ffRiH9LKbL0pxzzDF78z3TftnS
         hsxmnl76QbwXuXp8WZR4elMETgxI36bRIUbwUmM1uhHIeTX0i/xsoEUn+WDcle3cFR
         oQgyoNtjcoP7RX3q4I+ao+aPJVHI4Sjuu52vfIZw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sven Eckelmann <sven@narfation.org>,
        Simon Wunderlich <sw@simonwunderlich.de>
Subject: [PATCH 4.4 66/93] batman-adv: Fix lock for ogm cnt access in batadv_iv_ogm_calc_tq
Date:   Thu, 19 Mar 2020 14:00:10 +0100
Message-Id: <20200319123945.951833090@linuxfoundation.org>
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

commit 5ba7dcfe77037b67016263ea597a8b431692ecab upstream.

The originator node object orig_neigh_node is used to when accessing the
bcast_own(_sum) and real_packet_count information. The access to them has
to be protected with the spinlock in orig_neigh_node.

But the function uses the lock in orig_node instead. This is incorrect
because they could be two different originator node objects.

Fixes: 0ede9f41b217 ("batman-adv: protect bit operations to count OGMs with spinlock")
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Simon Wunderlich <sw@simonwunderlich.de>
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/batman-adv/bat_iv_ogm.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/net/batman-adv/bat_iv_ogm.c
+++ b/net/batman-adv/bat_iv_ogm.c
@@ -1180,7 +1180,7 @@ static int batadv_iv_ogm_calc_tq(struct
 	orig_node->last_seen = jiffies;
 
 	/* find packet count of corresponding one hop neighbor */
-	spin_lock_bh(&orig_node->bat_iv.ogm_cnt_lock);
+	spin_lock_bh(&orig_neigh_node->bat_iv.ogm_cnt_lock);
 	if_num = if_incoming->if_num;
 	orig_eq_count = orig_neigh_node->bat_iv.bcast_own_sum[if_num];
 	neigh_ifinfo = batadv_neigh_ifinfo_new(neigh_node, if_outgoing);
@@ -1190,7 +1190,7 @@ static int batadv_iv_ogm_calc_tq(struct
 	} else {
 		neigh_rq_count = 0;
 	}
-	spin_unlock_bh(&orig_node->bat_iv.ogm_cnt_lock);
+	spin_unlock_bh(&orig_neigh_node->bat_iv.ogm_cnt_lock);
 
 	/* pay attention to not get a value bigger than 100 % */
 	if (orig_eq_count > neigh_rq_count)


