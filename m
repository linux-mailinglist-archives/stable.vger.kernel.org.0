Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E0CC586A68
	for <lists+stable@lfdr.de>; Mon,  1 Aug 2022 14:16:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233763AbiHAMQV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Aug 2022 08:16:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233283AbiHAMPf (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Aug 2022 08:15:35 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE4FA7AB08;
        Mon,  1 Aug 2022 04:58:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 590B0B8117B;
        Mon,  1 Aug 2022 11:58:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA11BC433D6;
        Mon,  1 Aug 2022 11:58:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1659355105;
        bh=FAVsQMKM+xWsrgh2OtFVs4D7ZSSDfn563TOdSHFaIPA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WjuWALTGNy7naGHN/kx8H1TlxzWyeXs2YG3cUX9LD3RCqOoVOLXEciogAeny2Y9cU
         /o4mIFnFZ/Uny7Comd23SaVYYCIQrn48EFkis556JqMHfaD0wjPzqx6172iD5fPMJ5
         iHdvNUgD5l4ypyabs9K/1IeXewjpnEPF0DWD1+lk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Brian Vazquez <brianvv@google.com>,
        Eric Dumazet <edumazet@google.com>,
        David Ahern <dsahern@kernel.org>,
        Dmitry Safonov <dima@arista.com>,
        Leonard Crestez <cdleonard@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.18 34/88] tcp: md5: fix IPv4-mapped support
Date:   Mon,  1 Aug 2022 13:46:48 +0200
Message-Id: <20220801114139.588702628@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220801114138.041018499@linuxfoundation.org>
References: <20220801114138.041018499@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

commit e62d2e110356093c034998e093675df83057e511 upstream.

After the blamed commit, IPv4 SYN packets handled
by a dual stack IPv6 socket are dropped, even if
perfectly valid.

$ nstat | grep MD5
TcpExtTCPMD5Failure             5                  0.0

For a dual stack listener, an incoming IPv4 SYN packet
would call tcp_inbound_md5_hash() with @family == AF_INET,
while tp->af_specific is pointing to tcp_sock_ipv6_specific.

Only later when an IPv4-mapped child is created, tp->af_specific
is changed to tcp_sock_ipv6_mapped_specific.

Fixes: 7bbb765b7349 ("net/tcp: Merge TCP-MD5 inbound callbacks")
Reported-by: Brian Vazquez <brianvv@google.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
Reviewed-by: Dmitry Safonov <dima@arista.com>
Tested-by: Leonard Crestez <cdleonard@gmail.com>
Link: https://lore.kernel.org/r/20220726115743.2759832-1-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/tcp.c |   15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

--- a/net/ipv4/tcp.c
+++ b/net/ipv4/tcp.c
@@ -4481,9 +4481,18 @@ tcp_inbound_md5_hash(const struct sock *
 		return SKB_DROP_REASON_TCP_MD5UNEXPECTED;
 	}
 
-	/* check the signature */
-	genhash = tp->af_specific->calc_md5_hash(newhash, hash_expected,
-						 NULL, skb);
+	/* Check the signature.
+	 * To support dual stack listeners, we need to handle
+	 * IPv4-mapped case.
+	 */
+	if (family == AF_INET)
+		genhash = tcp_v4_md5_hash_skb(newhash,
+					      hash_expected,
+					      NULL, skb);
+	else
+		genhash = tp->af_specific->calc_md5_hash(newhash,
+							 hash_expected,
+							 NULL, skb);
 
 	if (genhash || memcmp(hash_location, newhash, 16) != 0) {
 		NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPMD5FAILURE);


