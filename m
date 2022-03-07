Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 09F564CF65B
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 10:35:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237548AbiCGJgM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 04:36:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237550AbiCGJfW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 04:35:22 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D66116D3BB;
        Mon,  7 Mar 2022 01:31:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1A11CB810C2;
        Mon,  7 Mar 2022 09:30:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8303DC340E9;
        Mon,  7 Mar 2022 09:30:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646645451;
        bh=VhGi8MFyHuo28m+9+2Z+7/z5004SCo//JCYm45CBOqA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JcRtprgGIYhHg2OVmlo73sa1+5Srfl88H2eMc2SZyDsNPQKNri6RmiG/6QfgJtuZs
         iess1sY2CUp/VC2f/f+pRMlYfZ4gQLx7sxnkyCM1JZoezUyk8mK40AwLsA7oAFcs6a
         FPplc9edVZ8Bobfsq5I9pVAQ4R/rO3DlDkHtUf2M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiri Bohac <jbohac@suse.cz>,
        Steffen Klassert <steffen.klassert@secunet.com>
Subject: [PATCH 5.10 036/105] xfrm: fix MTU regression
Date:   Mon,  7 Mar 2022 10:18:39 +0100
Message-Id: <20220307091645.201437369@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220307091644.179885033@linuxfoundation.org>
References: <20220307091644.179885033@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jiri Bohac <jbohac@suse.cz>

commit 6596a0229541270fb8d38d989f91b78838e5e9da upstream.

Commit 749439bfac6e1a2932c582e2699f91d329658196 ("ipv6: fix udpv6
sendmsg crash caused by too small MTU") breaks PMTU for xfrm.

A Packet Too Big ICMPv6 message received in response to an ESP
packet will prevent all further communication through the tunnel
if the reported MTU minus the ESP overhead is smaller than 1280.

E.g. in a case of a tunnel-mode ESP with sha256/aes the overhead
is 92 bytes. Receiving a PTB with MTU of 1371 or less will result
in all further packets in the tunnel dropped. A ping through the
tunnel fails with "ping: sendmsg: Invalid argument".

Apparently the MTU on the xfrm route is smaller than 1280 and
fails the check inside ip6_setup_cork() added by 749439bf.

We found this by debugging USGv6/ipv6ready failures. Failing
tests are: "Phase-2 Interoperability Test Scenario IPsec" /
5.3.11 and 5.4.11 (Tunnel Mode: Fragmentation).

Commit b515d2637276a3810d6595e10ab02c13bfd0b63a ("xfrm:
xfrm_state_mtu should return at least 1280 for ipv6") attempted
to fix this but caused another regression in TCP MSS calculations
and had to be reverted.

The patch below fixes the situation by dropping the MTU
check and instead checking for the underflows described in the
749439bf commit message.

Signed-off-by: Jiri Bohac <jbohac@suse.cz>
Fixes: 749439bfac6e ("ipv6: fix udpv6 sendmsg crash caused by too small MTU")
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv6/ip6_output.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -1432,8 +1432,6 @@ static int ip6_setup_cork(struct sock *s
 		if (np->frag_size)
 			mtu = np->frag_size;
 	}
-	if (mtu < IPV6_MIN_MTU)
-		return -EINVAL;
 	cork->base.fragsize = mtu;
 	cork->base.gso_size = ipc6->gso_size;
 	cork->base.tx_flags = 0;
@@ -1495,8 +1493,6 @@ static int __ip6_append_data(struct sock
 
 	fragheaderlen = sizeof(struct ipv6hdr) + rt->rt6i_nfheader_len +
 			(opt ? opt->opt_nflen : 0);
-	maxfraglen = ((mtu - fragheaderlen) & ~7) + fragheaderlen -
-		     sizeof(struct frag_hdr);
 
 	headersize = sizeof(struct ipv6hdr) +
 		     (opt ? opt->opt_flen + opt->opt_nflen : 0) +
@@ -1504,6 +1500,13 @@ static int __ip6_append_data(struct sock
 		      sizeof(struct frag_hdr) : 0) +
 		     rt->rt6i_nfheader_len;
 
+	if (mtu < fragheaderlen ||
+	    ((mtu - fragheaderlen) & ~7) + fragheaderlen < sizeof(struct frag_hdr))
+		goto emsgsize;
+
+	maxfraglen = ((mtu - fragheaderlen) & ~7) + fragheaderlen -
+		     sizeof(struct frag_hdr);
+
 	/* as per RFC 7112 section 5, the entire IPv6 Header Chain must fit
 	 * the first fragment
 	 */


