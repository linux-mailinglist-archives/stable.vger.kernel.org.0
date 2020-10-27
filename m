Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C61FB29C224
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 18:32:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1819983AbgJ0Rbw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 13:31:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:41262 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1762292AbgJ0Olt (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:41:49 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0BCC9207BB;
        Tue, 27 Oct 2020 14:41:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603809708;
        bh=AHPu6VlPpb0XC/2887H1Sa35fVDy3w65m8Olms9NGyU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W4SFxVgC7mEbllbksON1t52cg9k5cRzqML/7S0imE6xlwMe9TybnECTr+DaFfLnfW
         l6uuasv3b0XHrV234Q5XutJ4Wh3Q9o2X5lPoGCAaYrhFPjZXXmPiWgK3tQWcInhtGv
         9qGpAY/hxWLz+OURyw8kDlSwINKzxzSInscJNKQI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Francesco Ruggeri <fruggeri@arista.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 292/408] netfilter: conntrack: connection timeout after re-register
Date:   Tue, 27 Oct 2020 14:53:50 +0100
Message-Id: <20201027135508.585157601@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135455.027547757@linuxfoundation.org>
References: <20201027135455.027547757@linuxfoundation.org>
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
index 1926fd56df56a..848b137151c26 100644
--- a/net/netfilter/nf_conntrack_proto_tcp.c
+++ b/net/netfilter/nf_conntrack_proto_tcp.c
@@ -541,13 +541,20 @@ static bool tcp_in_window(const struct nf_conn *ct,
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



