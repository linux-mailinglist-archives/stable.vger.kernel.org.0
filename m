Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB7834ABA70
	for <lists+stable@lfdr.de>; Mon,  7 Feb 2022 12:28:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383726AbiBGLX2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Feb 2022 06:23:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237122AbiBGLKI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Feb 2022 06:10:08 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72065C043181;
        Mon,  7 Feb 2022 03:10:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2AFFAB811A6;
        Mon,  7 Feb 2022 11:10:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DC4EC004E1;
        Mon,  7 Feb 2022 11:10:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644232204;
        bh=YQyYSuGuWt3SdnnDFdfIDNJ2uhshhzRjYo2rsuRjqWQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MfHwGCt0kUkyK6kUkxG+XpgfKbQyeXfwW3JJoVtciGf4fsWb/XqUA5Fio6CRmFezB
         8Vf9AUqvsIcQCh43N0b2O0Tv/9cWco/epjgDHBQbRHWuyhJiU6CuuMlGuSOcdmxx/p
         OMTg43ldy6iRRO/3AeN1ENQ9tfZLJnGC309PRX/U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        David Ahern <dsahern@kernel.org>, Ray Che <xijiache@gmail.com>,
        Willy Tarreau <w@1wt.eu>, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 4.9 18/48] ipv4: avoid using shared IP generator for connected sockets
Date:   Mon,  7 Feb 2022 12:05:51 +0100
Message-Id: <20220207103752.937750248@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220207103752.341184175@linuxfoundation.org>
References: <20220207103752.341184175@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Eric Dumazet <edumazet@google.com>

commit 23f57406b82de51809d5812afd96f210f8b627f3 upstream.

ip_select_ident_segs() has been very conservative about using
the connected socket private generator only for packets with IP_DF
set, claiming it was needed for some VJ compression implementations.

As mentioned in this referenced document, this can be abused.
(Ref: Off-Path TCP Exploits of the Mixed IPID Assignment)

Before switching to pure random IPID generation and possibly hurt
some workloads, lets use the private inet socket generator.

Not only this will remove one vulnerability, this will also
improve performance of TCP flows using pmtudisc==IP_PMTUDISC_DONT

Fixes: 73f156a6e8c1 ("inetpeer: get rid of ip_id_count")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
Reported-by: Ray Che <xijiache@gmail.com>
Cc: Willy Tarreau <w@1wt.eu>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/ip.h |   21 ++++++++++-----------
 1 file changed, 10 insertions(+), 11 deletions(-)

--- a/include/net/ip.h
+++ b/include/net/ip.h
@@ -377,19 +377,18 @@ static inline void ip_select_ident_segs(
 {
 	struct iphdr *iph = ip_hdr(skb);
 
+	/* We had many attacks based on IPID, use the private
+	 * generator as much as we can.
+	 */
+	if (sk && inet_sk(sk)->inet_daddr) {
+		iph->id = htons(inet_sk(sk)->inet_id);
+		inet_sk(sk)->inet_id += segs;
+		return;
+	}
 	if ((iph->frag_off & htons(IP_DF)) && !skb->ignore_df) {
-		/* This is only to work around buggy Windows95/2000
-		 * VJ compression implementations.  If the ID field
-		 * does not change, they drop every other packet in
-		 * a TCP stream using header compression.
-		 */
-		if (sk && inet_sk(sk)->inet_daddr) {
-			iph->id = htons(inet_sk(sk)->inet_id);
-			inet_sk(sk)->inet_id += segs;
-		} else {
-			iph->id = 0;
-		}
+		iph->id = 0;
 	} else {
+		/* Unfortunately we need the big hammer to get a suitable IPID */
 		__ip_select_ident(net, iph, segs);
 	}
 }


