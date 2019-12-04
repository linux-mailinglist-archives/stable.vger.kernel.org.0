Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ED1E5113179
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 18:59:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728660AbfLDR7v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Dec 2019 12:59:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:37102 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728666AbfLDR7u (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Dec 2019 12:59:50 -0500
Received: from localhost (unknown [217.68.49.72])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3B7482084B;
        Wed,  4 Dec 2019 17:59:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575482389;
        bh=4ViH26CfKQ55nuwcbzbxlFI+t7zG1NSHwlFV6FltphI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hnesBWfgwO/4gzeGb+jRmwR0ge9PvJLSs5GmPljBgW7bW/jr/MRzbgUkhuiBZNoCr
         DQkPQwuG8zyiY7YbzLsZ/4zGGnr4rNWA/i7xyC3BbcMm8PijgIfZ1mamR/huGz4RX7
         CN/sC7nKSyP+lOtgnL+O0pNlVh7f0lzlFu47w1rI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ying Xue <ying.xue@windriver.com>,
        Jon Maloy <maloy@donjonn.com>,
        Hoang Le <hoang.h.le@dektech.com.au>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 68/92] tipc: fix skb may be leaky in tipc_link_input
Date:   Wed,  4 Dec 2019 18:50:08 +0100
Message-Id: <20191204174334.414973392@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191204174327.215426506@linuxfoundation.org>
References: <20191204174327.215426506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hoang Le <hoang.h.le@dektech.com.au>

[ Upstream commit 7384b538d3aed2ed49d3575483d17aeee790fb06 ]

When we free skb at tipc_data_input, we return a 'false' boolean.
Then, skb passed to subcalling tipc_link_input in tipc_link_rcv,

<snip>
1303 int tipc_link_rcv:
...
1354    if (!tipc_data_input(l, skb, l->inputq))
1355        rc |= tipc_link_input(l, skb, l->inputq);
</snip>

Fix it by simple changing to a 'true' boolean when skb is being free-ed.
Then, tipc_link_rcv will bypassed to subcalling tipc_link_input as above
condition.

Acked-by: Ying Xue <ying.xue@windriver.com>
Acked-by: Jon Maloy <maloy@donjonn.com>
Signed-off-by: Hoang Le <hoang.h.le@dektech.com.au>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/tipc/link.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/tipc/link.c b/net/tipc/link.c
index 736fffb28ab6f..0080699b7cd1b 100644
--- a/net/tipc/link.c
+++ b/net/tipc/link.c
@@ -883,7 +883,7 @@ static bool tipc_data_input(struct tipc_link *l, struct sk_buff *skb,
 	default:
 		pr_warn("Dropping received illegal msg type\n");
 		kfree_skb(skb);
-		return false;
+		return true;
 	};
 }
 
-- 
2.20.1



