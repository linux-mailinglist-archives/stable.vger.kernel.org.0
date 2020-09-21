Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FC2F272DE3
	for <lists+stable@lfdr.de>; Mon, 21 Sep 2020 18:45:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729317AbgIUQni (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Sep 2020 12:43:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:48292 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728492AbgIUQnf (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Sep 2020 12:43:35 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D52C523976;
        Mon, 21 Sep 2020 16:43:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600706615;
        bh=u/WIsO/68OACiuRirFmq3uibug4tZzwOl11xLW8+Vr0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PZpA8Mvuf4yePheb+/MidjoxIgp1F4MWExAcIF7V5VA32MiO98YTvpdGYQY1wGPsu
         4jToz3g7h7h9KMAgnRvAG2HBwg11hGTqyKx4y2ykb7AVnms4VEkTTMzoEtYZkMA/+l
         bGtKpGTXLxlYLfwbLENA82Fi6hLowfzX0XsNKVJs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaohe Lin <linmiaohe@huawei.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.8 004/118] net: handle the return value of pskb_carve_frag_list() correctly
Date:   Mon, 21 Sep 2020 18:26:56 +0200
Message-Id: <20200921162036.552382649@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200921162036.324813383@linuxfoundation.org>
References: <20200921162036.324813383@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miaohe Lin <linmiaohe@huawei.com>

commit eabe861881a733fc84f286f4d5a1ffaddd4f526f upstream.

pskb_carve_frag_list() may return -ENOMEM in pskb_carve_inside_nonlinear().
we should handle this correctly or we would get wrong sk_buff.

Fixes: 6fa01ccd8830 ("skbuff: Add pskb_extract() helper function")
Signed-off-by: Miaohe Lin <linmiaohe@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/core/skbuff.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -5988,9 +5988,13 @@ static int pskb_carve_inside_nonlinear(s
 	if (skb_has_frag_list(skb))
 		skb_clone_fraglist(skb);
 
-	if (k == 0) {
-		/* split line is in frag list */
-		pskb_carve_frag_list(skb, shinfo, off - pos, gfp_mask);
+	/* split line is in frag list */
+	if (k == 0 && pskb_carve_frag_list(skb, shinfo, off - pos, gfp_mask)) {
+		/* skb_frag_unref() is not needed here as shinfo->nr_frags = 0. */
+		if (skb_has_frag_list(skb))
+			kfree_skb_list(skb_shinfo(skb)->frag_list);
+		kfree(data);
+		return -ENOMEM;
 	}
 	skb_release_data(skb);
 


