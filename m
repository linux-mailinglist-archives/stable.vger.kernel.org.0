Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1322C5947D4
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 02:04:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353895AbiHOXmx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 19:42:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354188AbiHOXlg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 19:41:36 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7052B83F33;
        Mon, 15 Aug 2022 13:11:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2016EB80EA9;
        Mon, 15 Aug 2022 20:11:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CC8FC433C1;
        Mon, 15 Aug 2022 20:11:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660594262;
        bh=iYfeC75j6U9orOtsHn0ahFpgAnuaEkZWkuIbvo+iqNg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=u64gb0jRgJoe0w7lPzZ388S6+U4QUaZQ/R13i9ixk+lIGyFmnPOFuPWGAW2EfgZeV
         yUczRPdpnMT3+rhCfZkmC8styx/pFF8AMrwjllGsmXKFGlYkOZ1CAKCFYzwwTHeSGL
         QDEz00Vd4R8p27pwkEpW0Tlo3EMBUAG00mYmRLx4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, John Sperbeck <jsperbeck@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.18 1080/1095] raw: fix a typo in raw_icmp_error()
Date:   Mon, 15 Aug 2022 20:07:59 +0200
Message-Id: <20220815180513.710889691@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
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

From: Eric Dumazet <edumazet@google.com>

commit 97a4d46b1516250d640c1ae0c9e7129d160d6a1c upstream.

I accidentally broke IPv4 traceroute, by swapping iph->saddr
and iph->daddr.

Probably because raw_icmp_error() and raw_v4_input()
use different order for iph->saddr and iph->daddr.

Fixes: ba44f8182ec2 ("raw: use more conventional iterators")
Reported-by: John Sperbeck <jsperbeck@google.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Link: https://lore.kernel.org/r/20220623193540.2851799-1-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/raw.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/net/ipv4/raw.c
+++ b/net/ipv4/raw.c
@@ -278,7 +278,7 @@ void raw_icmp_error(struct sk_buff *skb,
 	hlist_nulls_for_each_entry(sk, hnode, hlist, sk_nulls_node) {
 		iph = (const struct iphdr *)skb->data;
 		if (!raw_v4_match(net, sk, iph->protocol,
-				  iph->saddr, iph->daddr, dif, sdif))
+				  iph->daddr, iph->saddr, dif, sdif))
 			continue;
 		raw_err(sk, skb, info);
 	}


