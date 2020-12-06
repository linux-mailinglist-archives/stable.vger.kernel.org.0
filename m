Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 050892D0459
	for <lists+stable@lfdr.de>; Sun,  6 Dec 2020 12:52:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728677AbgLFLo7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Dec 2020 06:44:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:44440 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728809AbgLFLo6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 6 Dec 2020 06:44:58 -0500
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Davide Caratti <dcaratti@redhat.com>,
        Guillaume Nault <gnault@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.9 35/46] net/sched: act_mpls: ensure LSE is pullable before reading it
Date:   Sun,  6 Dec 2020 12:17:43 +0100
Message-Id: <20201206111558.149317835@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201206111556.455533723@linuxfoundation.org>
References: <20201206111556.455533723@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Davide Caratti <dcaratti@redhat.com>

[ Upstream commit 9608fa653059c3f72faab0c148ac8773c46e7314 ]

when 'act_mpls' is used to mangle the LSE, the current value is read from
the packet dereferencing 4 bytes at mpls_hdr(): ensure that the label is
contained in the skb "linear" area.

Found by code inspection.

v2:
 - use MPLS_HLEN instead of sizeof(new_lse), thanks to Jakub Kicinski

Fixes: 2a2ea50870ba ("net: sched: add mpls manipulation actions to TC")
Signed-off-by: Davide Caratti <dcaratti@redhat.com>
Acked-by: Guillaume Nault <gnault@redhat.com>
Link: https://lore.kernel.org/r/3243506cba43d14858f3bd21ee0994160e44d64a.1606987058.git.dcaratti@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sched/act_mpls.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/net/sched/act_mpls.c
+++ b/net/sched/act_mpls.c
@@ -88,6 +88,9 @@ static int tcf_mpls_act(struct sk_buff *
 			goto drop;
 		break;
 	case TCA_MPLS_ACT_MODIFY:
+		if (!pskb_may_pull(skb,
+				   skb_network_offset(skb) + MPLS_HLEN))
+			goto drop;
 		new_lse = tcf_mpls_get_lse(mpls_hdr(skb), p, false);
 		if (skb_mpls_update_lse(skb, new_lse))
 			goto drop;


