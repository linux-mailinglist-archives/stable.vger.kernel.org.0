Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2481F63DE75
	for <lists+stable@lfdr.de>; Wed, 30 Nov 2022 19:37:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230372AbiK3ShL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 13:37:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230436AbiK3ShJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 13:37:09 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CCA993A5C
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 10:37:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3A8B0B81B82
        for <stable@vger.kernel.org>; Wed, 30 Nov 2022 18:37:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F3D8C433D7;
        Wed, 30 Nov 2022 18:37:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669833424;
        bh=M9Cdb9EKSh6xBbuv64roB52dnuM/zZES8ZOgtQu9TYk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xzu9QLNF/+qd0NP0R6nNjDBDEfsRWh92lnOxVzkXU6TprFMeVZxFAwI8Ze5sDtife
         cMxllizDFJENZDVH77c6z+YQAEXCKyNjbt1l97skA63cKLhoJbkDx/ax4+CSke0Mg3
         zQCAUjfbUOLw6uy7Jb1ojAvTzJ/ti8vyh4OGl8Yg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Joshua Hunt <johunt@akamai.com>,
        Vishwanath Pai <vpai@akamai.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 100/206] netfilter: ipset: regression in ip_set_hash_ip.c
Date:   Wed, 30 Nov 2022 19:22:32 +0100
Message-Id: <20221130180535.587997704@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180532.974348590@linuxfoundation.org>
References: <20221130180532.974348590@linuxfoundation.org>
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
index dd30c03d5a23..75d556d71652 100644
--- a/net/netfilter/ipset/ip_set_hash_ip.c
+++ b/net/netfilter/ipset/ip_set_hash_ip.c
@@ -151,18 +151,16 @@ hash_ip4_uadt(struct ip_set *set, struct nlattr *tb[],
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



