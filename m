Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E19744ABB23
	for <lists+stable@lfdr.de>; Mon,  7 Feb 2022 12:35:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384245AbiBGL0c (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Feb 2022 06:26:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379040AbiBGLP7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Feb 2022 06:15:59 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7D7AC0401C1;
        Mon,  7 Feb 2022 03:15:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4A8756113B;
        Mon,  7 Feb 2022 11:15:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 236CEC004E1;
        Mon,  7 Feb 2022 11:15:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644232554;
        bh=LFmkYpZoYitqpsxbqK/+Yq6+QTUAR/LsvVhg5PB8eQU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=csFNy1zUdlz/y3LyPUqK9+vUBvrIb5SzykyVpvwxHut4AxlkkDU3Z30d+BVrdrfOW
         xPf5YRu4hHGXz+gY9eGRRty+RtIyVUR0ST7/32NlgPQb515vSzZ0YuIdUDnRkYBKUs
         crKEz+FX2Z7mFQX7IPpu9TgWd4TU8DoBEhecTZGo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 4.19 47/86] netfilter: nat: limit port clash resolution attempts
Date:   Mon,  7 Feb 2022 12:06:10 +0100
Message-Id: <20220207103759.092441686@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220207103757.550973048@linuxfoundation.org>
References: <20220207103757.550973048@linuxfoundation.org>
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

From: Florian Westphal <fw@strlen.de>

commit a504b703bb1da526a01593da0e4be2af9d9f5fa8 upstream.

In case almost or all available ports are taken, clash resolution can
take a very long time, resulting in soft lockup.

This can happen when many to-be-natted hosts connect to same
destination:port (e.g. a proxy) and all connections pass the same SNAT.

Pick a random offset in the acceptable range, then try ever smaller
number of adjacent port numbers, until either the limit is reached or a
useable port was found.  This results in at most 248 attempts
(128 + 64 + 32 + 16 + 8, i.e. 4 restarts with new search offset)
instead of 64000+,

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/netfilter/nf_nat_proto_common.c |   29 +++++++++++++++++++++++------
 1 file changed, 23 insertions(+), 6 deletions(-)

--- a/net/netfilter/nf_nat_proto_common.c
+++ b/net/netfilter/nf_nat_proto_common.c
@@ -40,9 +40,10 @@ void nf_nat_l4proto_unique_tuple(const s
 				 enum nf_nat_manip_type maniptype,
 				 const struct nf_conn *ct)
 {
-	unsigned int range_size, min, max, i;
+	unsigned int range_size, min, max, i, attempts;
 	__be16 *portptr;
-	u_int16_t off;
+	u16 off;
+	static const unsigned int max_attempts = 128;
 
 	if (maniptype == NF_NAT_MANIP_SRC)
 		portptr = &tuple->src.u.all;
@@ -88,12 +89,28 @@ void nf_nat_l4proto_unique_tuple(const s
 		off = prandom_u32();
 	}
 
-	for (i = 0; ; ++off) {
+	attempts = range_size;
+	if (attempts > max_attempts)
+		attempts = max_attempts;
+
+	/* We are in softirq; doing a search of the entire range risks
+	 * soft lockup when all tuples are already used.
+	 *
+	 * If we can't find any free port from first offset, pick a new
+	 * one and try again, with ever smaller search window.
+	 */
+another_round:
+	for (i = 0; i < attempts; i++, off++) {
 		*portptr = htons(min + off % range_size);
-		if (++i != range_size && nf_nat_used_tuple(tuple, ct))
-			continue;
-		return;
+		if (!nf_nat_used_tuple(tuple, ct))
+			return;
 	}
+
+	if (attempts >= range_size || attempts < 16)
+		return;
+	attempts /= 2;
+	off = prandom_u32();
+	goto another_round;
 }
 EXPORT_SYMBOL_GPL(nf_nat_l4proto_unique_tuple);
 


