Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15B9A48008F
	for <lists+stable@lfdr.de>; Mon, 27 Dec 2021 16:47:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240118AbhL0PrK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Dec 2021 10:47:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240438AbhL0PpJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Dec 2021 10:45:09 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2EAFC08E886;
        Mon, 27 Dec 2021 07:42:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 79952B810B9;
        Mon, 27 Dec 2021 15:42:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AE0FC36AEA;
        Mon, 27 Dec 2021 15:42:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640619742;
        bh=S7+d1VwPqfG5GaWzyEIx5wd2SnTRpVKT2boXkNTxyfQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jpbgfUY/3bBTMsq1FPdUNzuiy7SCk4/uIIsVaqJMXwt7MBfyxzvEuaP3wxL0+1ctw
         PcovxTZRPEZUNpBd42IP7DaipZsJ2LD6IWxlqDCpFCL1DdMZ7HhT/LwGAJzCpgXCdq
         yTn9XdRPAuHiScRvcYvP3reM+4AJHsFBBRoyJ86o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Ignacy=20Gaw=C4=99dzki?= 
        <ignacy.gawedzki@green-communications.fr>,
        Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 021/128] netfilter: fix regression in looped (broad|multi)casts MAC handling
Date:   Mon, 27 Dec 2021 16:29:56 +0100
Message-Id: <20211227151332.221500820@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211227151331.502501367@linuxfoundation.org>
References: <20211227151331.502501367@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ignacy Gawędzki <ignacy.gawedzki@green-communications.fr>

[ Upstream commit ebb966d3bdfed581ecccbb4a7432341baf7619b4 ]

In commit 5648b5e1169f ("netfilter: nfnetlink_queue: fix OOB when mac
header was cleared"), the test for non-empty MAC header introduced in
commit 2c38de4c1f8da7 ("netfilter: fix looped (broad|multi)cast's MAC
handling") has been replaced with a test for a set MAC header.

This breaks the case when the MAC header has been reset (using
skb_reset_mac_header), as is the case with looped-back multicast
packets.  As a result, the packets ending up in NFQUEUE get a bogus
hwaddr interpreted from the first bytes of the IP header.

This patch adds a test for a non-empty MAC header in addition to the
test for a set MAC header.  The same two tests are also implemented in
nfnetlink_log.c, where the initial code of commit 2c38de4c1f8da7
("netfilter: fix looped (broad|multi)cast's MAC handling") has not been
touched, but where supposedly the same situation may happen.

Fixes: 5648b5e1169f ("netfilter: nfnetlink_queue: fix OOB when mac header was cleared")
Signed-off-by: Ignacy Gawędzki <ignacy.gawedzki@green-communications.fr>
Reviewed-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nfnetlink_log.c   | 3 ++-
 net/netfilter/nfnetlink_queue.c | 3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nfnetlink_log.c b/net/netfilter/nfnetlink_log.c
index 691ef4cffdd90..7f83f9697fc14 100644
--- a/net/netfilter/nfnetlink_log.c
+++ b/net/netfilter/nfnetlink_log.c
@@ -556,7 +556,8 @@ __build_packet_message(struct nfnl_log_net *log,
 		goto nla_put_failure;
 
 	if (indev && skb->dev &&
-	    skb->mac_header != skb->network_header) {
+	    skb_mac_header_was_set(skb) &&
+	    skb_mac_header_len(skb) != 0) {
 		struct nfulnl_msg_packet_hw phw;
 		int len;
 
diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
index 4acc4b8e9fe5a..959527708e382 100644
--- a/net/netfilter/nfnetlink_queue.c
+++ b/net/netfilter/nfnetlink_queue.c
@@ -560,7 +560,8 @@ nfqnl_build_packet_message(struct net *net, struct nfqnl_instance *queue,
 		goto nla_put_failure;
 
 	if (indev && entskb->dev &&
-	    skb_mac_header_was_set(entskb)) {
+	    skb_mac_header_was_set(entskb) &&
+	    skb_mac_header_len(entskb) != 0) {
 		struct nfqnl_msg_packet_hw phw;
 		int len;
 
-- 
2.34.1



