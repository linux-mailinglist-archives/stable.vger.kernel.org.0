Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E0224B20BA
	for <lists+stable@lfdr.de>; Fri, 11 Feb 2022 09:55:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348218AbiBKIxh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Feb 2022 03:53:37 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:42004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348276AbiBKIxg (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 11 Feb 2022 03:53:36 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B88C1026;
        Fri, 11 Feb 2022 00:53:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1683261E42;
        Fri, 11 Feb 2022 08:53:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB431C340E9;
        Fri, 11 Feb 2022 08:53:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644569611;
        bh=G6trzJLrWKVrpeJgBQZkBzn1CKppFzqrklNrQI7FeVU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rqtW8T5VZ96q4glFcQDDohowGXG3aWEalwNWQfE8Pyw03G1zsPYJfUWu0ogySk6zX
         AZY/sCYu8kak8HjUhjLUUKNApP5lQTT9FLnxSEnEPQ+Ant3wWDpPDkfRnacIcI0DDe
         KNJ4Yz688gunaQwaiWm4rOb4MzgW8JhhJYQ7EZzU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Linux 5.4.179
Date:   Fri, 11 Feb 2022 09:53:17 +0100
Message-Id: <164456959716514@kroah.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <1644569597160132@kroah.com>
References: <1644569597160132@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

diff --git a/Makefile b/Makefile
index 6d33284664fe..5688e17a4436 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 VERSION = 5
 PATCHLEVEL = 4
-SUBLEVEL = 178
+SUBLEVEL = 179
 EXTRAVERSION =
 NAME = Kleptomaniac Octopus
 
diff --git a/drivers/mmc/host/moxart-mmc.c b/drivers/mmc/host/moxart-mmc.c
index 5553a5643f40..5c81dc7371db 100644
--- a/drivers/mmc/host/moxart-mmc.c
+++ b/drivers/mmc/host/moxart-mmc.c
@@ -696,12 +696,12 @@ static int moxart_remove(struct platform_device *pdev)
 		if (!IS_ERR(host->dma_chan_rx))
 			dma_release_channel(host->dma_chan_rx);
 		mmc_remove_host(mmc);
-		mmc_free_host(mmc);
 
 		writel(0, host->base + REG_INTERRUPT_MASK);
 		writel(0, host->base + REG_POWER_CONTROL);
 		writel(readl(host->base + REG_CLOCK_CONTROL) | CLK_OFF,
 		       host->base + REG_CLOCK_CONTROL);
+		mmc_free_host(mmc);
 	}
 	return 0;
 }
diff --git a/net/tipc/link.c b/net/tipc/link.c
index f25010261a9e..8f2ee71c63c6 100644
--- a/net/tipc/link.c
+++ b/net/tipc/link.c
@@ -1953,15 +1953,18 @@ static int tipc_link_proto_rcv(struct tipc_link *l, struct sk_buff *skb,
 	u16 peers_tol = msg_link_tolerance(hdr);
 	u16 peers_prio = msg_linkprio(hdr);
 	u16 rcv_nxt = l->rcv_nxt;
-	u16 dlen = msg_data_sz(hdr);
+	u32 dlen = msg_data_sz(hdr), glen = 0;
 	int mtyp = msg_type(hdr);
 	bool reply = msg_probe(hdr);
-	u16 glen = 0;
 	void *data;
 	char *if_name;
 	int rc = 0;
 
 	trace_tipc_proto_rcv(skb, false, l->name);
+
+	if (dlen > U16_MAX)
+		goto exit;
+
 	if (tipc_link_is_blocked(l) || !xmitq)
 		goto exit;
 
@@ -2063,7 +2066,8 @@ static int tipc_link_proto_rcv(struct tipc_link *l, struct sk_buff *skb,
 			if (glen != tipc_gap_ack_blks_sz(ga->gack_cnt))
 				ga = NULL;
 		}
-
+		if(glen > dlen)
+			break;
 		tipc_mon_rcv(l->net, data + glen, dlen - glen, l->addr,
 			     &l->mon_state, l->bearer_id);
 
diff --git a/net/tipc/monitor.c b/net/tipc/monitor.c
index 58708b4c7719..e7155a774300 100644
--- a/net/tipc/monitor.c
+++ b/net/tipc/monitor.c
@@ -457,6 +457,8 @@ void tipc_mon_rcv(struct net *net, void *data, u16 dlen, u32 addr,
 	state->probing = false;
 
 	/* Sanity check received domain record */
+	if (new_member_cnt > MAX_MON_DOMAIN)
+		return;
 	if (dlen < dom_rec_len(arrv_dom, 0))
 		return;
 	if (dlen != dom_rec_len(arrv_dom, new_member_cnt))
