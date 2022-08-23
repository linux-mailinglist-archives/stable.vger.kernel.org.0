Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1028659D58A
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 11:09:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347156AbiHWInl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 04:43:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345004AbiHWImN (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 04:42:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09D0161722;
        Tue, 23 Aug 2022 01:20:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5C27C61212;
        Tue, 23 Aug 2022 08:19:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C3DCC433C1;
        Tue, 23 Aug 2022 08:19:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661242776;
        bh=KUI2cN9pa6NkqKzcH5G8VxQkrWLwmBFwrdOxH167Smo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ifXsTVpBdqOD/x62nbeL59BfCRuDBOmCMDdJLXNzz7H4Y+sAA9rhTfPsdpnGDzusF
         GMr0glUW7Sh2N6lasBHL3dKmYtGHN6/UDlFVYBwZaD0/9+7gvvvayJIZNfYh6hC57N
         UoMPI+5HbPoTwTPhdqZc9LJDcshZQ8AA/D5AmhJQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 5.19 195/365] netfilter: nf_ct_irc: cap packet search space to 4k
Date:   Tue, 23 Aug 2022 10:01:36 +0200
Message-Id: <20220823080126.378613262@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080118.128342613@linuxfoundation.org>
References: <20220823080118.128342613@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Florian Westphal <fw@strlen.de>

commit 976bf59c69cd2e2c17f0ab20a14c0e700cba0f15 upstream.

This uses a pseudo-linearization scheme with a 64k global buffer,
but BIG TCP arrival means IPv6 TCP stack can generate skbs
that exceed this size.

In practice, IRC commands are not expected to exceed 512 bytes, plus
this is interactive protocol, so we should not see large packets
in practice.

Given most IRC connections nowadays use TLS so this helper could also be
removed in the near future.

Fixes: 7c4e983c4f3c ("net: allow gso_max_size to exceed 65536")
Fixes: 0fe79f28bfaf ("net: allow gro_max_size to exceed 65536")
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/netfilter/nf_conntrack_irc.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/nf_conntrack_irc.c b/net/netfilter/nf_conntrack_irc.c
index 08ee4e760a3d..1796c456ac98 100644
--- a/net/netfilter/nf_conntrack_irc.c
+++ b/net/netfilter/nf_conntrack_irc.c
@@ -39,6 +39,7 @@ unsigned int (*nf_nat_irc_hook)(struct sk_buff *skb,
 EXPORT_SYMBOL_GPL(nf_nat_irc_hook);
 
 #define HELPER_NAME "irc"
+#define MAX_SEARCH_SIZE	4095
 
 MODULE_AUTHOR("Harald Welte <laforge@netfilter.org>");
 MODULE_DESCRIPTION("IRC (DCC) connection tracking helper");
@@ -121,6 +122,7 @@ static int help(struct sk_buff *skb, unsigned int protoff,
 	int i, ret = NF_ACCEPT;
 	char *addr_beg_p, *addr_end_p;
 	typeof(nf_nat_irc_hook) nf_nat_irc;
+	unsigned int datalen;
 
 	/* If packet is coming from IRC server */
 	if (dir == IP_CT_DIR_REPLY)
@@ -140,8 +142,12 @@ static int help(struct sk_buff *skb, unsigned int protoff,
 	if (dataoff >= skb->len)
 		return NF_ACCEPT;
 
+	datalen = skb->len - dataoff;
+	if (datalen > MAX_SEARCH_SIZE)
+		datalen = MAX_SEARCH_SIZE;
+
 	spin_lock_bh(&irc_buffer_lock);
-	ib_ptr = skb_header_pointer(skb, dataoff, skb->len - dataoff,
+	ib_ptr = skb_header_pointer(skb, dataoff, datalen,
 				    irc_buffer);
 	if (!ib_ptr) {
 		spin_unlock_bh(&irc_buffer_lock);
@@ -149,7 +155,7 @@ static int help(struct sk_buff *skb, unsigned int protoff,
 	}
 
 	data = ib_ptr;
-	data_limit = ib_ptr + skb->len - dataoff;
+	data_limit = ib_ptr + datalen;
 
 	/* strlen("\1DCC SENT t AAAAAAAA P\1\n")=24
 	 * 5+MINMATCHLEN+strlen("t AAAAAAAA P\1\n")=14 */
@@ -251,7 +257,7 @@ static int __init nf_conntrack_irc_init(void)
 	irc_exp_policy.max_expected = max_dcc_channels;
 	irc_exp_policy.timeout = dcc_timeout;
 
-	irc_buffer = kmalloc(65536, GFP_KERNEL);
+	irc_buffer = kmalloc(MAX_SEARCH_SIZE + 1, GFP_KERNEL);
 	if (!irc_buffer)
 		return -ENOMEM;
 
-- 
2.37.2



