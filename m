Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB5CF259C57
	for <lists+stable@lfdr.de>; Tue,  1 Sep 2020 19:15:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729189AbgIAPPP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Sep 2020 11:15:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:59348 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729185AbgIAPPJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Sep 2020 11:15:09 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 45CC1206FA;
        Tue,  1 Sep 2020 15:15:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598973308;
        bh=7/WCKlMTvBR7YmWfYFwJp9dRNVnCi7LtZNSvGah06qg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iQtQPnYsP0rLd9WQEy+KUWrLxkEwyTAiK3QprMs07CAUCsbrNPyDbG1SW+sI+XfzT
         lvwEyGZSnrJQ4zIqFGAtimuvLc5QlKD4rr1lDPlHAm0fI0PEkl39ywcQNHmxdPgxe0
         xwAbM67SiH99dbLZ8das6DgR1blUNN4rrnwN/wM0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaohe Lin <linmiaohe@huawei.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.9 03/78] net: Fix potential wrong skb->protocol in skb_vlan_untag()
Date:   Tue,  1 Sep 2020 17:09:39 +0200
Message-Id: <20200901150924.884408213@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200901150924.680106554@linuxfoundation.org>
References: <20200901150924.680106554@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miaohe Lin <linmiaohe@huawei.com>

[ Upstream commit 55eff0eb7460c3d50716ed9eccf22257b046ca92 ]

We may access the two bytes after vlan_hdr in vlan_set_encap_proto(). So
we should pull VLAN_HLEN + sizeof(unsigned short) in skb_vlan_untag() or
we may access the wrong data.

Fixes: 0d5501c1c828 ("net: Always untag vlan-tagged traffic on input.")
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/skbuff.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -4591,8 +4591,8 @@ struct sk_buff *skb_vlan_untag(struct sk
 	skb = skb_share_check(skb, GFP_ATOMIC);
 	if (unlikely(!skb))
 		goto err_free;
-
-	if (unlikely(!pskb_may_pull(skb, VLAN_HLEN)))
+	/* We may access the two bytes after vlan_hdr in vlan_set_encap_proto(). */
+	if (unlikely(!pskb_may_pull(skb, VLAN_HLEN + sizeof(unsigned short))))
 		goto err_free;
 
 	vhdr = (struct vlan_hdr *)skb->data;


