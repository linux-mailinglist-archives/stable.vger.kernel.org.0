Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BAFC1CAFD9
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 15:23:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728610AbgEHNUy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 09:20:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:34640 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728647AbgEHMkn (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 May 2020 08:40:43 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 956EC2495C;
        Fri,  8 May 2020 12:40:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588941643;
        bh=bPJQOBYFz72cyScOmZGaPjhKKwZqNevqPmf1/x101CU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mn4lAjX/YUjs92MAvuflDwtTSesWgp4lPCBNyBFGgzq85puSV4PtprqCGA9/Hsfyr
         senRW5TMeluEU8tID850nVXnpveb9QtSkx0CPjpnfLjeHcev2/1Gtl1GM6pAEOOtFa
         0vD/Oqt38Y4B1aVHWc6LvcX4cEqW2wYeN848tKwc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Simon Wunderlich <sw@simonwunderlich.de>,
        Marek Lindner <mareklindner@neomailbox.ch>,
        Sven Eckelmann <sven@narfation.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.4 115/312] batman-adv: replace WARN with rate limited output on non-existing VLAN
Date:   Fri,  8 May 2020 14:31:46 +0200
Message-Id: <20200508123132.563259344@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200508123124.574959822@linuxfoundation.org>
References: <20200508123124.574959822@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Simon Wunderlich <sw@simonwunderlich.de>

commit 0b3dd7dfb81ad8af53791ea2bb64b83bac1b7d32 upstream.

If a VLAN tagged frame is received and the corresponding VLAN is not
configured on the soft interface, it will splat a WARN on every packet
received. This is a quite annoying behaviour for some scenarios, e.g. if
bat0 is bridged with eth0, and there are arbitrary VLAN tagged frames
from Ethernet coming in without having any VLAN configuration on bat0.

The code should probably create vlan objects on the fly and
transparently transport these VLAN-tagged Ethernet frames, but until
this is done, at least the WARN splat should be replaced by a rate
limited output.

Fixes: 354136bcc3c4 ("batman-adv: fix kernel crash due to missing NULL checks")
Signed-off-by: Simon Wunderlich <sw@simonwunderlich.de>
Signed-off-by: Marek Lindner <mareklindner@neomailbox.ch>
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/batman-adv/translation-table.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/net/batman-adv/translation-table.c
+++ b/net/batman-adv/translation-table.c
@@ -614,8 +614,10 @@ bool batadv_tt_local_add(struct net_devi
 
 	/* increase the refcounter of the related vlan */
 	vlan = batadv_softif_vlan_get(bat_priv, vid);
-	if (WARN(!vlan, "adding TT local entry %pM to non-existent VLAN %d",
-		 addr, BATADV_PRINT_VID(vid))) {
+	if (!vlan) {
+		net_ratelimited_function(batadv_info, soft_iface,
+					 "adding TT local entry %pM to non-existent VLAN %d\n",
+					 addr, BATADV_PRINT_VID(vid));
 		kfree(tt_local);
 		tt_local = NULL;
 		goto out;


