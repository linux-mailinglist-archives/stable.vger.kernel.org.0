Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7F51C18B579
	for <lists+stable@lfdr.de>; Thu, 19 Mar 2020 14:19:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727749AbgCSNSy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Mar 2020 09:18:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:41642 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728696AbgCSNSw (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Mar 2020 09:18:52 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 19D2C214D8;
        Thu, 19 Mar 2020 13:18:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584623931;
        bh=UVIq3kfmmMt4OxRi/iwoPRHANQQVObbhqUMTpEQTYOo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qduhFeHIhiUHTwo1frGI8+IRuQM/eBYQaiW2bNUUMLRKi0jl9UCaKo/EI8jYsOv7k
         +xvOq1iENFlIkyE6TDNr7pZbQiM6zuREMh76WI1ZYPYExPYyoQmgZ8PsqQ7yEYpgnE
         Oqz1XIrChCfrJvd1oTa3V9eUm8v2jxwetXeFvvsw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Marek Lindner <mareklindner@neomailbox.ch>,
        Sven Eckelmann <sven@narfation.org>,
        Simon Wunderlich <sw@simonwunderlich.de>
Subject: [PATCH 4.14 75/99] batman-adv: prevent TT request storms by not sending inconsistent TT TLVLs
Date:   Thu, 19 Mar 2020 14:03:53 +0100
Message-Id: <20200319124003.828460399@linuxfoundation.org>
X-Mailer: git-send-email 2.25.2
In-Reply-To: <20200319123941.630731708@linuxfoundation.org>
References: <20200319123941.630731708@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marek Lindner <mareklindner@neomailbox.ch>

commit 16116dac23396e73c01eeee97b102e4833a4b205 upstream.

A translation table TVLV changset sent with an OGM consists
of a number of headers (one per VLAN) plus the changeset
itself (addition and/or deletion of entries).

The per-VLAN headers are used by OGM recipients for consistency
checks. Said consistency check might determine that a full
translation table request is needed to restore consistency. If
the TT sender adds per-VLAN headers of empty VLANs into the OGM,
recipients are led to believe to have reached an inconsistent
state and thus request a full table update. The full table does
not contain empty VLANs (due to missing entries) the cycle
restarts when the next OGM is issued.

Consequently, when the translation table TVLV headers are
composed, empty VLANs are to be excluded.

Fixes: 21a57f6e7a3b ("batman-adv: make the TT CRC logic VLAN specific")
Signed-off-by: Marek Lindner <mareklindner@neomailbox.ch>
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Simon Wunderlich <sw@simonwunderlich.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/batman-adv/translation-table.c |   15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

--- a/net/batman-adv/translation-table.c
+++ b/net/batman-adv/translation-table.c
@@ -941,15 +941,20 @@ batadv_tt_prepare_tvlv_local_data(struct
 	struct batadv_tvlv_tt_vlan_data *tt_vlan;
 	struct batadv_softif_vlan *vlan;
 	u16 num_vlan = 0;
-	u16 num_entries = 0;
+	u16 vlan_entries = 0;
+	u16 total_entries = 0;
 	u16 tvlv_len;
 	u8 *tt_change_ptr;
 	int change_offset;
 
 	spin_lock_bh(&bat_priv->softif_vlan_list_lock);
 	hlist_for_each_entry_rcu(vlan, &bat_priv->softif_vlan_list, list) {
+		vlan_entries = atomic_read(&vlan->tt.num_entries);
+		if (vlan_entries < 1)
+			continue;
+
 		num_vlan++;
-		num_entries += atomic_read(&vlan->tt.num_entries);
+		total_entries += vlan_entries;
 	}
 
 	change_offset = sizeof(**tt_data);
@@ -957,7 +962,7 @@ batadv_tt_prepare_tvlv_local_data(struct
 
 	/* if tt_len is negative, allocate the space needed by the full table */
 	if (*tt_len < 0)
-		*tt_len = batadv_tt_len(num_entries);
+		*tt_len = batadv_tt_len(total_entries);
 
 	tvlv_len = *tt_len;
 	tvlv_len += change_offset;
@@ -974,6 +979,10 @@ batadv_tt_prepare_tvlv_local_data(struct
 
 	tt_vlan = (struct batadv_tvlv_tt_vlan_data *)(*tt_data + 1);
 	hlist_for_each_entry_rcu(vlan, &bat_priv->softif_vlan_list, list) {
+		vlan_entries = atomic_read(&vlan->tt.num_entries);
+		if (vlan_entries < 1)
+			continue;
+
 		tt_vlan->vid = htons(vlan->vid);
 		tt_vlan->crc = htonl(vlan->tt.crc);
 


