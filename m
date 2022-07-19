Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8BA98579E36
	for <lists+stable@lfdr.de>; Tue, 19 Jul 2022 14:59:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235119AbiGSM7B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 08:59:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242520AbiGSM6b (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 08:58:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8637D4F1A2;
        Tue, 19 Jul 2022 05:23:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 12304618E6;
        Tue, 19 Jul 2022 12:23:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5D69C341C6;
        Tue, 19 Jul 2022 12:23:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658233414;
        bh=1vc3EJytqyUNS1xlFfoMKtjkqyxG3EvQLNlJniO4kOk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pl5H6se3r+oxS/jvUTOdbuB4ap2gDr6nJLEb4JKWp4ZHVUYnEkChjxpfJqhkSEJVV
         wTI+eADstdDUS+EH+4Xy2bDa8dXmOXiUMaJUnD9sIAmkddar4f8vD59C8vweYH20rr
         I1TA00WdXmsbynY3ScUYDawjLyzcRsqqMEdtIJVw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kuniyuki Iwashima <kuniyu@amazon.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 114/231] icmp: Fix a data-race around sysctl_icmp_echo_ignore_broadcasts.
Date:   Tue, 19 Jul 2022 13:53:19 +0200
Message-Id: <20220719114724.118355028@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220719114714.247441733@linuxfoundation.org>
References: <20220719114714.247441733@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kuniyuki Iwashima <kuniyu@amazon.com>

[ Upstream commit 66484bb98ed2dfa1dda37a32411483d8311ac269 ]

While reading sysctl_icmp_echo_ignore_broadcasts, it can be changed
concurrently.  Thus, we need to add READ_ONCE() to its reader.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/icmp.c            | 2 +-
 net/ipv4/sysctl_net_ipv4.c | 2 ++
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/ipv4/icmp.c b/net/ipv4/icmp.c
index 7edc8a3b1646..2c402b4671a1 100644
--- a/net/ipv4/icmp.c
+++ b/net/ipv4/icmp.c
@@ -1239,7 +1239,7 @@ int icmp_rcv(struct sk_buff *skb)
 		 */
 		if ((icmph->type == ICMP_ECHO ||
 		     icmph->type == ICMP_TIMESTAMP) &&
-		    net->ipv4.sysctl_icmp_echo_ignore_broadcasts) {
+		    READ_ONCE(net->ipv4.sysctl_icmp_echo_ignore_broadcasts)) {
 			goto error;
 		}
 		if (icmph->type != ICMP_ECHO &&
diff --git a/net/ipv4/sysctl_net_ipv4.c b/net/ipv4/sysctl_net_ipv4.c
index 8987864c4479..6613351094ce 100644
--- a/net/ipv4/sysctl_net_ipv4.c
+++ b/net/ipv4/sysctl_net_ipv4.c
@@ -621,6 +621,8 @@ static struct ctl_table ipv4_net_table[] = {
 		.maxlen		= sizeof(u8),
 		.mode		= 0644,
 		.proc_handler	= proc_dou8vec_minmax,
+		.extra1		= SYSCTL_ZERO,
+		.extra2		= SYSCTL_ONE
 	},
 	{
 		.procname	= "icmp_ignore_bogus_error_responses",
-- 
2.35.1



