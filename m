Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F6DB59D4E6
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 11:08:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241273AbiHWI5t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 04:57:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241489AbiHWI52 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 04:57:28 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74E5F10550;
        Tue, 23 Aug 2022 01:25:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3E6ACB81C4C;
        Tue, 23 Aug 2022 08:19:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FAECC433D7;
        Tue, 23 Aug 2022 08:19:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661242773;
        bh=keD4PPoxYhzM6PyquEBtEeIYUAl7WnMlu51eH/WuM1w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gMKtjQ+D6b4XdxhkALtiUV6BCN9Z0PsrIvA2ljJaANLY+lj/uhuRqjUlkgv2BqE81
         QnVqbsSIIGZGvXo5KJfzxfGYiYPpftv25H76KiXB2scEm34QINac4vVSPQZLXFqf90
         bj+oyJHMkbuAhiRbH45oq1ET3eCYBxVH958Lm9Pw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 5.19 194/365] netfilter: nf_ct_ftp: prefer skb_linearize
Date:   Tue, 23 Aug 2022 10:01:35 +0200
Message-Id: <20220823080126.336978835@linuxfoundation.org>
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

commit c783a29c7e5934eabac2b760571489ad83bf4fd1 upstream.

This uses a pseudo-linearization scheme with a 64k global buffer,
but BIG TCP arrival means IPv6 TCP stack can generate skbs
that exceed this size.

Use skb_linearize.  It should be possible to rewrite this to properly
deal with segmented skbs (i.e., only do small chunk-wise accesses),
but this is going to be a lot more intrusive than this because every
helper function needs to get the sk_buff instead of a pointer to a raw
data buffer.

In practice, provided we're really looking at FTP control channel packets,
there should never be a case where we deal with huge packets.

Fixes: 7c4e983c4f3c ("net: allow gso_max_size to exceed 65536")
Fixes: 0fe79f28bfaf ("net: allow gro_max_size to exceed 65536")
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/netfilter/nf_conntrack_ftp.c | 24 ++++++------------------
 1 file changed, 6 insertions(+), 18 deletions(-)

diff --git a/net/netfilter/nf_conntrack_ftp.c b/net/netfilter/nf_conntrack_ftp.c
index a414274338cf..0d9332e9cf71 100644
--- a/net/netfilter/nf_conntrack_ftp.c
+++ b/net/netfilter/nf_conntrack_ftp.c
@@ -34,11 +34,6 @@ MODULE_DESCRIPTION("ftp connection tracking helper");
 MODULE_ALIAS("ip_conntrack_ftp");
 MODULE_ALIAS_NFCT_HELPER(HELPER_NAME);
 
-/* This is slow, but it's simple. --RR */
-static char *ftp_buffer;
-
-static DEFINE_SPINLOCK(nf_ftp_lock);
-
 #define MAX_PORTS 8
 static u_int16_t ports[MAX_PORTS];
 static unsigned int ports_c;
@@ -398,6 +393,9 @@ static int help(struct sk_buff *skb,
 		return NF_ACCEPT;
 	}
 
+	if (unlikely(skb_linearize(skb)))
+		return NF_DROP;
+
 	th = skb_header_pointer(skb, protoff, sizeof(_tcph), &_tcph);
 	if (th == NULL)
 		return NF_ACCEPT;
@@ -411,12 +409,8 @@ static int help(struct sk_buff *skb,
 	}
 	datalen = skb->len - dataoff;
 
-	spin_lock_bh(&nf_ftp_lock);
-	fb_ptr = skb_header_pointer(skb, dataoff, datalen, ftp_buffer);
-	if (!fb_ptr) {
-		spin_unlock_bh(&nf_ftp_lock);
-		return NF_ACCEPT;
-	}
+	spin_lock_bh(&ct->lock);
+	fb_ptr = skb->data + dataoff;
 
 	ends_in_nl = (fb_ptr[datalen - 1] == '\n');
 	seq = ntohl(th->seq) + datalen;
@@ -544,7 +538,7 @@ static int help(struct sk_buff *skb,
 	if (ends_in_nl)
 		update_nl_seq(ct, seq, ct_ftp_info, dir, skb);
  out:
-	spin_unlock_bh(&nf_ftp_lock);
+	spin_unlock_bh(&ct->lock);
 	return ret;
 }
 
@@ -571,7 +565,6 @@ static const struct nf_conntrack_expect_policy ftp_exp_policy = {
 static void __exit nf_conntrack_ftp_fini(void)
 {
 	nf_conntrack_helpers_unregister(ftp, ports_c * 2);
-	kfree(ftp_buffer);
 }
 
 static int __init nf_conntrack_ftp_init(void)
@@ -580,10 +573,6 @@ static int __init nf_conntrack_ftp_init(void)
 
 	NF_CT_HELPER_BUILD_BUG_ON(sizeof(struct nf_ct_ftp_master));
 
-	ftp_buffer = kmalloc(65536, GFP_KERNEL);
-	if (!ftp_buffer)
-		return -ENOMEM;
-
 	if (ports_c == 0)
 		ports[ports_c++] = FTP_PORT;
 
@@ -603,7 +592,6 @@ static int __init nf_conntrack_ftp_init(void)
 	ret = nf_conntrack_helpers_register(ftp, ports_c * 2);
 	if (ret < 0) {
 		pr_err("failed to register helpers\n");
-		kfree(ftp_buffer);
 		return ret;
 	}
 
-- 
2.37.2



