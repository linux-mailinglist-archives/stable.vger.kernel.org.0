Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71F9035BE51
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 10:57:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238274AbhDLI5u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 04:57:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:44464 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239076AbhDLIze (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Apr 2021 04:55:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A84D160241;
        Mon, 12 Apr 2021 08:55:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618217716;
        bh=NVn1Bh8Jj5naMznwxoRD3JVNXnKAuTiarNUyiFAbH9k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AXHLFXGPj606m/LKYv275ELVYmw7MAtkLhEv7tCpY0/0u7a96qvIv8iklIyTLvnCt
         zA2HfK+9Ts1k96eo6GOZc4BtqKLrG7+BgN7OK3ezG2AiNVeeAcF2IKWiq+HdcpMbXM
         PV0Qb0d6LBEpf+nuXhRVcCcNoMcweWPRf50Qd0LQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lv Yunlong <lyl2019@mail.ustc.edu.cn>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 119/188] ethernet: myri10ge: Fix a use after free in myri10ge_sw_tso
Date:   Mon, 12 Apr 2021 10:40:33 +0200
Message-Id: <20210412084017.609447378@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210412084013.643370347@linuxfoundation.org>
References: <20210412084013.643370347@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lv Yunlong <lyl2019@mail.ustc.edu.cn>

[ Upstream commit 63415767a2446136372e777cde5bb351f21ec21d ]

In myri10ge_sw_tso, the skb_list_walk_safe macro will set
(curr) = (segs) and (next) = (curr)->next. If status!=0 is true,
the memory pointed by curr and segs will be free by dev_kfree_skb_any(curr).
But later, the segs is used by segs = segs->next and causes a uaf.

As (next) = (curr)->next, my patch replaces seg->next to next.

Fixes: 536577f36ff7a ("net: myri10ge: use skb_list_walk_safe helper for gso segments")
Signed-off-by: Lv Yunlong <lyl2019@mail.ustc.edu.cn>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/myricom/myri10ge/myri10ge.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/myricom/myri10ge/myri10ge.c b/drivers/net/ethernet/myricom/myri10ge/myri10ge.c
index 1634ca6d4a8f..c84c8bf2bc20 100644
--- a/drivers/net/ethernet/myricom/myri10ge/myri10ge.c
+++ b/drivers/net/ethernet/myricom/myri10ge/myri10ge.c
@@ -2897,7 +2897,7 @@ static netdev_tx_t myri10ge_sw_tso(struct sk_buff *skb,
 			dev_kfree_skb_any(curr);
 			if (segs != NULL) {
 				curr = segs;
-				segs = segs->next;
+				segs = next;
 				curr->next = NULL;
 				dev_kfree_skb_any(segs);
 			}
-- 
2.30.2



