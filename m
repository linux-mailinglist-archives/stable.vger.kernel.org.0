Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC76529C3DF
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 18:51:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1822621AbgJ0Ru5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 13:50:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:50186 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S368331AbgJ0OYz (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:24:55 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EDC4F20773;
        Tue, 27 Oct 2020 14:24:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603808694;
        bh=8Jf+WeU3toZNUFLXDndU+jLYFdoEBcRcguOYr6hDGb8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GYlhBI69cGcdvrSNSlpOi3F2y8ryQKW41QYxV7W8UR5HsLIeNZ991MnZFtu3mzoMQ
         u5GX4Sg2FuvHc5ABMvVcADbuXXxWtyIgnfz5O65kPdLxVZLsatR2QgeWRqpLPh876b
         plEdCiZx6YhVPzpib9kmdwauD0eCdmdEO5bxPRnw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Francesco Ruggeri <fruggeri@arista.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 189/264] netfilter: conntrack: connection timeout after re-register
Date:   Tue, 27 Oct 2020 14:54:07 +0100
Message-Id: <20201027135439.536255486@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135430.632029009@linuxfoundation.org>
References: <20201027135430.632029009@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Francesco Ruggeri <fruggeri@arista.com>

[ Upstream commit 4f25434bccc28cf8a07876ef5142a2869a674353 ]

If the first packet conntrack sees after a re-register is an outgoing
keepalive packet with no data (SEG.SEQ = SND.NXT-1), td_end is set to
SND.NXT-1.
When the peer correctly acknowledges SND.NXT, tcp_in_window fails
check III (Upper bound for valid (s)ack: sack <= receiver.td_end) and
returns false, which cascades into nf_conntrack_in setting
skb->_nfct = 0 and in later conntrack iptables rules not matching.
In cases where iptables are dropping packets that do not match
conntrack rules this can result in idle tcp connections to time out.

v2: adjust td_end when getting the reply rather than when sending out
    the keepalive packet.

Fixes: f94e63801ab2 ("netfilter: conntrack: reset tcp maxwin on re-register")
Signed-off-by: Francesco Ruggeri <fruggeri@arista.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_conntrack_proto_tcp.c | 19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

diff --git a/net/netfilter/nf_conntrack_proto_tcp.c b/net/netfilter/nf_conntrack_proto_tcp.c
index 7011ab27c4371..40f8a1252394b 100644
--- a/net/netfilter/nf_conntrack_proto_tcp.c
+++ b/net/netfilter/nf_conntrack_proto_tcp.c
@@ -549,13 +549,20 @@ static bool tcp_in_window(const struct nf_conn *ct,
 			swin = win << sender->td_scale;
 			sender->td_maxwin = (swin == 0 ? 1 : swin);
 			sender->td_maxend = end + sender->td_maxwin;
-			/*
-			 * We haven't seen traffic in the other direction yet
-			 * but we have to tweak window tracking to pass III
-			 * and IV until that happens.
-			 */
-			if (receiver->td_maxwin == 0)
+			if (receiver->td_maxwin == 0) {
+				/* We haven't seen traffic in the other
+				 * direction yet but we have to tweak window
+				 * tracking to pass III and IV until that
+				 * happens.
+				 */
 				receiver->td_end = receiver->td_maxend = sack;
+			} else if (sack == receiver->td_end + 1) {
+				/* Likely a reply to a keepalive.
+				 * Needed for III.
+				 */
+				receiver->td_end++;
+			}
+
 		}
 	} else if (((state->state == TCP_CONNTRACK_SYN_SENT
 		     && dir == IP_CT_DIR_ORIGINAL)
-- 
2.25.1



