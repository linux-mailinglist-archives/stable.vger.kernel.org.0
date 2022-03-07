Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5896E4CF82E
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 10:52:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238109AbiCGJwJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 04:52:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239163AbiCGJtM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 04:49:12 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1474E1263E;
        Mon,  7 Mar 2022 01:42:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1816C612C9;
        Mon,  7 Mar 2022 09:42:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0721FC340E9;
        Mon,  7 Mar 2022 09:42:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646646162;
        bh=mIi0ftgoyhG5Jooo5lJFGHFsSsXEAO9j8HzxjxH7GQA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=w6jDicDu4FTguHhr/WUdp6XLu1cLTKEzVzUHqfbw36aijHg8Ym4t2+95Z/sQS7WrP
         EUqjNOOM+PEJ0+wJMTUiW4xm+2rkMwxPFaVP0siUElZkYKf5vyU7vADrIW0aBNUZa5
         FULnNDVLeV/xDJX6RN5IQ21+/RpSIXozAVrOdnfs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiri Bohac <jbohac@suse.cz>,
        Steffen Klassert <steffen.klassert@secunet.com>
Subject: [PATCH 5.15 153/262] xfrm: fix MTU regression
Date:   Mon,  7 Mar 2022 10:18:17 +0100
Message-Id: <20220307091706.756694448@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220307091702.378509770@linuxfoundation.org>
References: <20220307091702.378509770@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
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
@@ -1408,8 +1408,6 @@ static int ip6_setup_cork(struct sock *s
 		if (np->frag_size)
 			mtu = np->frag_size;
 	}
-	if (mtu < IPV6_MIN_MTU)
-		return -EINVAL;
 	cork->base.fragsize = mtu;
 	cork->base.gso_size = ipc6->gso_size;
 	cork->base.tx_flags = 0;
@@ -1471,8 +1469,6 @@ static int __ip6_append_data(struct sock
 
 	fragheaderlen = sizeof(struct ipv6hdr) + rt->rt6i_nfheader_len +
 			(opt ? opt->opt_nflen : 0);
-	maxfraglen = ((mtu - fragheaderlen) & ~7) + fragheaderlen -
-		     sizeof(struct frag_hdr);
 
 	headersize = sizeof(struct ipv6hdr) +
 		     (opt ? opt->opt_flen + opt->opt_nflen : 0) +
@@ -1480,6 +1476,13 @@ static int __ip6_append_data(struct sock
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


