Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5377A3A016C
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 21:17:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235129AbhFHSwJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 14:52:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:48452 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236220AbhFHSuH (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Jun 2021 14:50:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CFA6661464;
        Tue,  8 Jun 2021 18:39:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623177567;
        bh=ixrl0uHslFT0eriSVGrlLXxI+fCYgeuCYMN0JSuV70A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DZYyxJY2/e+cQNuVUc8RqoyEgZV4IfyHxBylaRpN8CkTjH70pk/REzQ136+v8/ZK2
         s4pFrQr+aRtqBnrh3ghJMinTPnVQRUxpCCsogIzWCkcvT+aRMcDMODIoblejVpXgpr
         etIuV0scAP/wWEG+qftm52xlLD2GpeFJJatmk/xs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ariel Levkovich <lariel@nvidia.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 020/137] net/sched: act_ct: Fix ct template allocation for zone 0
Date:   Tue,  8 Jun 2021 20:26:00 +0200
Message-Id: <20210608175943.096722639@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210608175942.377073879@linuxfoundation.org>
References: <20210608175942.377073879@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ariel Levkovich <lariel@nvidia.com>

[ Upstream commit fb91702b743dec78d6507c53a2dec8a8883f509d ]

Fix current behavior of skipping template allocation in case the
ct action is in zone 0.

Skipping the allocation may cause the datapath ct code to ignore the
entire ct action with all its attributes (commit, nat) in case the ct
action in zone 0 was preceded by a ct clear action.

The ct clear action sets the ct_state to untracked and resets the
skb->_nfct pointer. Under these conditions and without an allocated
ct template, the skb->_nfct pointer will remain NULL which will
cause the tc ct action handler to exit without handling commit and nat
actions, if such exist.

For example, the following rule in OVS dp:
recirc_id(0x2),ct_state(+new-est-rel-rpl+trk),ct_label(0/0x1), \
in_port(eth0),actions:ct_clear,ct(commit,nat(src=10.11.0.12)), \
recirc(0x37a)

Will result in act_ct skipping the commit and nat actions in zone 0.

The change removes the skipping of template allocation for zone 0 and
treats it the same as any other zone.

Fixes: b57dc7c13ea9 ("net/sched: Introduce action ct")
Signed-off-by: Ariel Levkovich <lariel@nvidia.com>
Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Link: https://lore.kernel.org/r/20210526170110.54864-1-lariel@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/act_ct.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/net/sched/act_ct.c b/net/sched/act_ct.c
index 6376b7b22325..315a5b2f3add 100644
--- a/net/sched/act_ct.c
+++ b/net/sched/act_ct.c
@@ -1199,9 +1199,6 @@ static int tcf_ct_fill_params(struct net *net,
 				   sizeof(p->zone));
 	}
 
-	if (p->zone == NF_CT_DEFAULT_ZONE_ID)
-		return 0;
-
 	nf_ct_zone_init(&zone, p->zone, NF_CT_DEFAULT_ZONE_DIR, 0);
 	tmpl = nf_ct_tmpl_alloc(net, &zone, GFP_KERNEL);
 	if (!tmpl) {
-- 
2.30.2



