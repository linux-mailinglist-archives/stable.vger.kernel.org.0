Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 112F34CF5F5
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 10:31:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237239AbiCGJbE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 04:31:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238077AbiCGJ2r (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 04:28:47 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D134A6D186;
        Mon,  7 Mar 2022 01:26:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9D59961052;
        Mon,  7 Mar 2022 09:26:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAC31C340E9;
        Mon,  7 Mar 2022 09:26:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646645195;
        bh=vGEorF7ZRDC5ExCYoUtecOvjQ7MZEXKKS0DTbOo26NE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i9PTX3cxhY3+GHjIdOg9ZN6aLesWpjOtGW6U1KIg4KwqwxecajAQbmJhbtreT9pWa
         nlkOcdTK4HH0H5Le1OX+kGUVKN/5B8xReCQSkPYMpOKIlgigNw1MF+PHK1FWx5b8uB
         iALn6U9VoTHfYh4PqMyTObkZ7zg3vEtz/nUxEatY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiri Bohac <jbohac@suse.cz>,
        Steffen Klassert <steffen.klassert@secunet.com>
Subject: [PATCH 5.4 17/64] xfrm: fix MTU regression
Date:   Mon,  7 Mar 2022 10:18:50 +0100
Message-Id: <20220307091639.634611209@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220307091639.136830784@linuxfoundation.org>
References: <20220307091639.136830784@linuxfoundation.org>
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
@@ -1361,8 +1361,6 @@ static int ip6_setup_cork(struct sock *s
 		if (np->frag_size)
 			mtu = np->frag_size;
 	}
-	if (mtu < IPV6_MIN_MTU)
-		return -EINVAL;
 	cork->base.fragsize = mtu;
 	cork->base.gso_size = ipc6->gso_size;
 	cork->base.tx_flags = 0;
@@ -1424,8 +1422,6 @@ static int __ip6_append_data(struct sock
 
 	fragheaderlen = sizeof(struct ipv6hdr) + rt->rt6i_nfheader_len +
 			(opt ? opt->opt_nflen : 0);
-	maxfraglen = ((mtu - fragheaderlen) & ~7) + fragheaderlen -
-		     sizeof(struct frag_hdr);
 
 	headersize = sizeof(struct ipv6hdr) +
 		     (opt ? opt->opt_flen + opt->opt_nflen : 0) +
@@ -1433,6 +1429,13 @@ static int __ip6_append_data(struct sock
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


