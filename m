Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 76621450BAB
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 18:25:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237918AbhKOR1b (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 12:27:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:50944 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237365AbhKORYp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 12:24:45 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5D2A663247;
        Mon, 15 Nov 2021 17:15:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636996546;
        bh=TPqxtag/iNEIRKR7i/5rPC9yx7kLKOAcvsGsOIl2rBE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BVm+O69hap8Ww0Zj+v2+p1Acq4uG8iLMhwED5E+XfBv7ChoQHW/W36tiKa5icfnyN
         My/UfP5W0FtNAZQYD0Jic3YiuILZiAsJINXvLnxKxmuKwgIdhGGtBUEjZZsQfvPXIF
         MQ0CoINODV7hd7MTbzDF4TMI2HHsb/AnKbOxk3pw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <zenczykowski@gmail.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 180/355] netfilter: conntrack: set on IPS_ASSURED if flows enters internal stream state
Date:   Mon, 15 Nov 2021 18:01:44 +0100
Message-Id: <20211115165319.604596785@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165313.549179499@linuxfoundation.org>
References: <20211115165313.549179499@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pablo Neira Ayuso <pablo@netfilter.org>

[ Upstream commit b7b1d02fc43925a4d569ec221715db2dfa1ce4f5 ]

The internal stream state sets the timeout to 120 seconds 2 seconds
after the creation of the flow, attach this internal stream state to the
IPS_ASSURED flag for consistent event reporting.

Before this patch:

      [NEW] udp      17 30 src=10.246.11.13 dst=216.239.35.0 sport=37282 dport=123 [UNREPLIED] src=216.239.35.0 dst=10.246.11.13 sport=123 dport=37282
   [UPDATE] udp      17 30 src=10.246.11.13 dst=216.239.35.0 sport=37282 dport=123 src=216.239.35.0 dst=10.246.11.13 sport=123 dport=37282
   [UPDATE] udp      17 30 src=10.246.11.13 dst=216.239.35.0 sport=37282 dport=123 src=216.239.35.0 dst=10.246.11.13 sport=123 dport=37282 [ASSURED]
  [DESTROY] udp      17 src=10.246.11.13 dst=216.239.35.0 sport=37282 dport=123 src=216.239.35.0 dst=10.246.11.13 sport=123 dport=37282 [ASSURED]

Note IPS_ASSURED for the flow not yet in the internal stream state.

after this update:

      [NEW] udp      17 30 src=10.246.11.13 dst=216.239.35.0 sport=37282 dport=123 [UNREPLIED] src=216.239.35.0 dst=10.246.11.13 sport=123 dport=37282
   [UPDATE] udp      17 30 src=10.246.11.13 dst=216.239.35.0 sport=37282 dport=123 src=216.239.35.0 dst=10.246.11.13 sport=123 dport=37282
   [UPDATE] udp      17 120 src=10.246.11.13 dst=216.239.35.0 sport=37282 dport=123 src=216.239.35.0 dst=10.246.11.13 sport=123 dport=37282 [ASSURED]
  [DESTROY] udp      17 src=10.246.11.13 dst=216.239.35.0 sport=37282 dport=123 src=216.239.35.0 dst=10.246.11.13 sport=123 dport=37282 [ASSURED]

Before this patch, short-lived UDP flows never entered IPS_ASSURED, so
they were already candidate flow to be deleted by early_drop under
stress.

Before this patch, IPS_ASSURED is set on regardless the internal stream
state, attach this internal stream state to IPS_ASSURED.

packet #1 (original direction) enters NEW state
packet #2 (reply direction) enters ESTABLISHED state, sets on IPS_SEEN_REPLY
paclet #3 (any direction) sets on IPS_ASSURED (if 2 seconds since the
          creation has passed by).

Reported-by: Maciej Żenczykowski <zenczykowski@gmail.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_conntrack_proto_udp.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_conntrack_proto_udp.c b/net/netfilter/nf_conntrack_proto_udp.c
index 7365b43f8f980..e3a2d018f4ec5 100644
--- a/net/netfilter/nf_conntrack_proto_udp.c
+++ b/net/netfilter/nf_conntrack_proto_udp.c
@@ -105,15 +105,18 @@ int nf_conntrack_udp_packet(struct nf_conn *ct,
 	 */
 	if (test_bit(IPS_SEEN_REPLY_BIT, &ct->status)) {
 		unsigned long extra = timeouts[UDP_CT_UNREPLIED];
+		bool stream = false;
 
 		/* Still active after two seconds? Extend timeout. */
-		if (time_after(jiffies, ct->proto.udp.stream_ts))
+		if (time_after(jiffies, ct->proto.udp.stream_ts)) {
 			extra = timeouts[UDP_CT_REPLIED];
+			stream = true;
+		}
 
 		nf_ct_refresh_acct(ct, ctinfo, skb, extra);
 
 		/* Also, more likely to be important, and not a probe */
-		if (!test_and_set_bit(IPS_ASSURED_BIT, &ct->status))
+		if (stream && !test_and_set_bit(IPS_ASSURED_BIT, &ct->status))
 			nf_conntrack_event_cache(IPCT_ASSURED, ct);
 	} else {
 		nf_ct_refresh_acct(ct, ctinfo, skb,
-- 
2.33.0



