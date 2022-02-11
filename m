Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD18A4B20B8
	for <lists+stable@lfdr.de>; Fri, 11 Feb 2022 09:55:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348234AbiBKIxi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Feb 2022 03:53:38 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:41990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347070AbiBKIxh (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 11 Feb 2022 03:53:37 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80352E6C;
        Fri, 11 Feb 2022 00:53:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1D8A261DD5;
        Fri, 11 Feb 2022 08:53:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E252DC340E9;
        Fri, 11 Feb 2022 08:53:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644569615;
        bh=3JmaMJQ7x5qrifRwP9DmE7/i+50liqGTZkgtHlR2dTw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MQ8LEDUVLYp/se0g1Z7ms1HEOFSmIkTKwsvS4tikXKvbxe621vDfaLYjTCfoWmUeY
         THE2V9cU3EjclkFE1MgBrwLXUwsYILzFqZ/hnFUYenC8y3cH3VZFDd7Dz6jr0zhNnp
         ChRV6448ssyNexIPHPwV8N7Mi2sbQmAuJzrwD/8U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: Linux 5.10.100
Date:   Fri, 11 Feb 2022 09:53:26 +0100
Message-Id: <164456960699172@kroah.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <16445696062149@kroah.com>
References: <16445696062149@kroah.com>
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
index 593638785d29..fb96cca42ddb 100644
--- a/Makefile
+++ b/Makefile
@@ -1,7 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
 VERSION = 5
 PATCHLEVEL = 10
-SUBLEVEL = 99
+SUBLEVEL = 100
 EXTRAVERSION =
 NAME = Dare mighty things
 
diff --git a/arch/s390/kvm/kvm-s390.c b/arch/s390/kvm/kvm-s390.c
index 07a04f392600..d8e9239c24ff 100644
--- a/arch/s390/kvm/kvm-s390.c
+++ b/arch/s390/kvm/kvm-s390.c
@@ -4654,6 +4654,8 @@ static long kvm_s390_guest_sida_op(struct kvm_vcpu *vcpu,
 		return -EINVAL;
 	if (mop->size + mop->sida_offset > sida_size(vcpu->arch.sie_block))
 		return -E2BIG;
+	if (!kvm_s390_pv_cpu_is_protected(vcpu))
+		return -EINVAL;
 
 	switch (mop->op) {
 	case KVM_S390_MEMOP_SIDA_READ:
diff --git a/crypto/algapi.c b/crypto/algapi.c
index fdabf2675b63..9de27daa98b4 100644
--- a/crypto/algapi.c
+++ b/crypto/algapi.c
@@ -1295,3 +1295,4 @@ module_exit(crypto_algapi_exit);
 
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("Cryptographic algorithms API");
+MODULE_SOFTDEP("pre: cryptomgr");
diff --git a/crypto/api.c b/crypto/api.c
index c4eda56cff89..5ffcd3ab4a75 100644
--- a/crypto/api.c
+++ b/crypto/api.c
@@ -603,4 +603,3 @@ EXPORT_SYMBOL_GPL(crypto_req_done);
 
 MODULE_DESCRIPTION("Cryptographic core API");
 MODULE_LICENSE("GPL");
-MODULE_SOFTDEP("pre: cryptomgr");
diff --git a/drivers/mmc/host/moxart-mmc.c b/drivers/mmc/host/moxart-mmc.c
index 7697068ad969..ea67a7ef2390 100644
--- a/drivers/mmc/host/moxart-mmc.c
+++ b/drivers/mmc/host/moxart-mmc.c
@@ -708,12 +708,12 @@ static int moxart_remove(struct platform_device *pdev)
 	if (!IS_ERR_OR_NULL(host->dma_chan_rx))
 		dma_release_channel(host->dma_chan_rx);
 	mmc_remove_host(mmc);
-	mmc_free_host(mmc);
 
 	writel(0, host->base + REG_INTERRUPT_MASK);
 	writel(0, host->base + REG_POWER_CONTROL);
 	writel(readl(host->base + REG_CLOCK_CONTROL) | CLK_OFF,
 	       host->base + REG_CLOCK_CONTROL);
+	mmc_free_host(mmc);
 
 	return 0;
 }
diff --git a/net/tipc/link.c b/net/tipc/link.c
index 29591955d08a..fb835a3822f4 100644
--- a/net/tipc/link.c
+++ b/net/tipc/link.c
@@ -2159,7 +2159,7 @@ static int tipc_link_proto_rcv(struct tipc_link *l, struct sk_buff *skb,
 	struct tipc_msg *hdr = buf_msg(skb);
 	struct tipc_gap_ack_blks *ga = NULL;
 	bool reply = msg_probe(hdr), retransmitted = false;
-	u16 dlen = msg_data_sz(hdr), glen = 0;
+	u32 dlen = msg_data_sz(hdr), glen = 0;
 	u16 peers_snd_nxt =  msg_next_sent(hdr);
 	u16 peers_tol = msg_link_tolerance(hdr);
 	u16 peers_prio = msg_linkprio(hdr);
@@ -2173,6 +2173,10 @@ static int tipc_link_proto_rcv(struct tipc_link *l, struct sk_buff *skb,
 	void *data;
 
 	trace_tipc_proto_rcv(skb, false, l->name);
+
+	if (dlen > U16_MAX)
+		goto exit;
+
 	if (tipc_link_is_blocked(l) || !xmitq)
 		goto exit;
 
@@ -2268,7 +2272,8 @@ static int tipc_link_proto_rcv(struct tipc_link *l, struct sk_buff *skb,
 
 		/* Receive Gap ACK blocks from peer if any */
 		glen = tipc_get_gap_ack_blks(&ga, l, hdr, true);
-
+		if(glen > dlen)
+			break;
 		tipc_mon_rcv(l->net, data + glen, dlen - glen, l->addr,
 			     &l->mon_state, l->bearer_id);
 
diff --git a/net/tipc/monitor.c b/net/tipc/monitor.c
index 6dce2abf436e..a37190da5a50 100644
--- a/net/tipc/monitor.c
+++ b/net/tipc/monitor.c
@@ -465,6 +465,8 @@ void tipc_mon_rcv(struct net *net, void *data, u16 dlen, u32 addr,
 	state->probing = false;
 
 	/* Sanity check received domain record */
+	if (new_member_cnt > MAX_MON_DOMAIN)
+		return;
 	if (dlen < dom_rec_len(arrv_dom, 0))
 		return;
 	if (dlen != dom_rec_len(arrv_dom, new_member_cnt))
