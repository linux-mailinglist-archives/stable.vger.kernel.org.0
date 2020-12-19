Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E243C2DEF4B
	for <lists+stable@lfdr.de>; Sat, 19 Dec 2020 14:02:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727803AbgLSM7L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 19 Dec 2020 07:59:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:45232 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728013AbgLSM7L (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 19 Dec 2020 07:59:11 -0500
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Guillaume Nault <gnault@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.9 27/49] net: sched: Fix dump of MPLS_OPT_LSE_LABEL attribute in cls_flower
Date:   Sat, 19 Dec 2020 13:58:31 +0100
Message-Id: <20201219125346.007154943@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201219125344.671832095@linuxfoundation.org>
References: <20201219125344.671832095@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Guillaume Nault <gnault@redhat.com>

[ Upstream commit 7fdd375e383097a785bb65c66802e468f398bf82 ]

TCA_FLOWER_KEY_MPLS_OPT_LSE_LABEL is a u32 attribute (MPLS label is
20 bits long).

Fixes the following bug:

 $ tc filter add dev ethX ingress protocol mpls_uc \
     flower mpls lse depth 2 label 256             \
     action drop

 $ tc filter show dev ethX ingress
   filter protocol mpls_uc pref 49152 flower chain 0
   filter protocol mpls_uc pref 49152 flower chain 0 handle 0x1
     eth_type 8847
     mpls
       lse depth 2 label 0  <-- invalid label 0, should be 256
   ...

Fixes: 61aec25a6db5 ("cls_flower: Support filtering on multiple MPLS Label Stack Entries")
Signed-off-by: Guillaume Nault <gnault@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sched/cls_flower.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/net/sched/cls_flower.c
+++ b/net/sched/cls_flower.c
@@ -2424,8 +2424,8 @@ static int fl_dump_key_mpls_opt_lse(stru
 			return err;
 	}
 	if (lse_mask->mpls_label) {
-		err = nla_put_u8(skb, TCA_FLOWER_KEY_MPLS_OPT_LSE_LABEL,
-				 lse_key->mpls_label);
+		err = nla_put_u32(skb, TCA_FLOWER_KEY_MPLS_OPT_LSE_LABEL,
+				  lse_key->mpls_label);
 		if (err)
 			return err;
 	}


