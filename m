Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3D6371F06E
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 13:44:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730019AbfEOL0s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 07:26:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:37610 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729874AbfEOL0o (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 May 2019 07:26:44 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EF1A6206BF;
        Wed, 15 May 2019 11:26:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557919604;
        bh=XdBZfExrQaGrAdoM+O6YjnIhVvug8FBLlDpS7/BCRi0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NGs+VdpLTI+hmnFeY7y1/1fmEjTxpqfxJQh6Xz8KbNHZrOAVsMDVU8nsdlM1c87ZR
         oaw/qaI8PHVs2q9T8bgO4mQ641s5oJZX3o8MKkoSGkXfnV7Vnwrg87iM433zWJqGr+
         8enPbtnQnpHgm6TErwFX8jPCBFQIyU03a9I8U490=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Felix Fietkau <nbd@nbd.name>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.0 024/137] mac80211: fix memory accounting with A-MSDU aggregation
Date:   Wed, 15 May 2019 12:55:05 +0200
Message-Id: <20190515090655.028786660@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190515090651.633556783@linuxfoundation.org>
References: <20190515090651.633556783@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit eb9b64e3a9f8483e6e54f4e03b2ae14ae5db2690 ]

skb->truesize can change due to memory reallocation or when adding extra
fragments. Adjust fq->memory_usage accordingly

Signed-off-by: Felix Fietkau <nbd@nbd.name>
Acked-by: Toke Høiland-Jørgensen <toke@redhat.com>
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/tx.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
index 928f13a208b05..714d80e48a102 100644
--- a/net/mac80211/tx.c
+++ b/net/mac80211/tx.c
@@ -3214,6 +3214,7 @@ static bool ieee80211_amsdu_aggregate(struct ieee80211_sub_if_data *sdata,
 	u8 max_subframes = sta->sta.max_amsdu_subframes;
 	int max_frags = local->hw.max_tx_fragments;
 	int max_amsdu_len = sta->sta.max_amsdu_len;
+	int orig_truesize;
 	__be16 len;
 	void *data;
 	bool ret = false;
@@ -3254,6 +3255,7 @@ static bool ieee80211_amsdu_aggregate(struct ieee80211_sub_if_data *sdata,
 	if (!head || skb_is_gso(head))
 		goto out;
 
+	orig_truesize = head->truesize;
 	orig_len = head->len;
 
 	if (skb->len + head->len > max_amsdu_len)
@@ -3311,6 +3313,7 @@ static bool ieee80211_amsdu_aggregate(struct ieee80211_sub_if_data *sdata,
 	*frag_tail = skb;
 
 out_recalc:
+	fq->memory_usage += head->truesize - orig_truesize;
 	if (head->len != orig_len) {
 		flow->backlog += head->len - orig_len;
 		tin->backlog_bytes += head->len - orig_len;
-- 
2.20.1



