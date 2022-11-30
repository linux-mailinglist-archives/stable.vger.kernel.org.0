Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7BD1463DD7C
	for <lists+stable@lfdr.de>; Wed, 30 Nov 2022 19:27:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229761AbiK3S16 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 13:27:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230077AbiK3S1p (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 13:27:45 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CA5912AD5
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 10:27:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E94ECB81C9C
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 18:27:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EF4AC433D6;
        Wed, 30 Nov 2022 18:27:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669832861;
        bh=K/u3V2OlxB5yoebDU8fARaMBepRe671yyLJ5LguK1Do=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=twnl7tYorkGKxJnY1I7zPEaOhquv3IPDzA4KmnEf85Ndrog+Wsx4ImFkwO1Cguh42
         soRy6cjTlpgqo5T/C19CB2dp+aO/oiswU7sapr4vyhXQ1JZ2T7Wfzh0dvz5m9YMd7D
         wVa8uEyqOueU4TEBnPXLXyrFdCgUKZTe+dPHJkwM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Joshua Hunt <johunt@akamai.com>,
        Vishwanath Pai <vpai@akamai.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 066/162] netfilter: ipset: regression in ip_set_hash_ip.c
Date:   Wed, 30 Nov 2022 19:22:27 +0100
Message-Id: <20221130180530.293787883@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180528.466039523@linuxfoundation.org>
References: <20221130180528.466039523@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vishwanath Pai <vpai@akamai.com>

[ Upstream commit c7aa1a76d4a0a3c401025b60c401412bbb60f8c6 ]

This patch introduced a regression: commit 48596a8ddc46 ("netfilter:
ipset: Fix adding an IPv4 range containing more than 2^31 addresses")

The variable e.ip is passed to adtfn() function which finally adds the
ip address to the set. The patch above refactored the for loop and moved
e.ip = htonl(ip) to the end of the for loop.

What this means is that if the value of "ip" changes between the first
assignement of e.ip and the forloop, then e.ip is pointing to a
different ip address than "ip".

Test case:
$ ipset create jdtest_tmp hash:ip family inet hashsize 2048 maxelem 100000
$ ipset add jdtest_tmp 10.0.1.1/31
ipset v6.21.1: Element cannot be added to the set: it's already added

The value of ip gets updated inside the  "else if (tb[IPSET_ATTR_CIDR])"
block but e.ip is still pointing to the old value.

Fixes: 48596a8ddc46 ("netfilter: ipset: Fix adding an IPv4 range containing more than 2^31 addresses")
Reviewed-by: Joshua Hunt <johunt@akamai.com>
Signed-off-by: Vishwanath Pai <vpai@akamai.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/ipset/ip_set_hash_ip.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/net/netfilter/ipset/ip_set_hash_ip.c b/net/netfilter/ipset/ip_set_hash_ip.c
index 361f4fd69bf4..d7a81b2250e7 100644
--- a/net/netfilter/ipset/ip_set_hash_ip.c
+++ b/net/netfilter/ipset/ip_set_hash_ip.c
@@ -150,18 +150,16 @@ hash_ip4_uadt(struct ip_set *set, struct nlattr *tb[],
 	if (((u64)ip_to - ip + 1) >> (32 - h->netmask) > IPSET_MAX_RANGE)
 		return -ERANGE;
 
-	if (retried) {
+	if (retried)
 		ip = ntohl(h->next.ip);
-		e.ip = htonl(ip);
-	}
 	for (; ip <= ip_to;) {
+		e.ip = htonl(ip);
 		ret = adtfn(set, &e, &ext, &ext, flags);
 		if (ret && !ip_set_eexist(ret, flags))
 			return ret;
 
 		ip += hosts;
-		e.ip = htonl(ip);
-		if (e.ip == 0)
+		if (ip == 0)
 			return 0;
 
 		ret = 0;
-- 
2.35.1



