Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 920D1111E34
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 00:01:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727827AbfLCW4p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Dec 2019 17:56:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:51912 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728029AbfLCW4o (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Dec 2019 17:56:44 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F315B2053B;
        Tue,  3 Dec 2019 22:56:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575413803;
        bh=pBc3Uy6qdPU7f3AWBU+DO5jtFs1x2B3Mu8Vjn+lynnE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XKlg6+wyfFVzXweEaawvDCxzgVC04S/4FrkmHncYW10528t0bRlss90KvCa8toT1c
         1DTUWTPmNqkMNvXkmISyNOEfKr8YIsidGJFSIdiCrw3SofiL+Gn/V6NIEk9BdLzO7N
         4jDPZ5Yus6odeS7w8R6NUIPHwAtmG7CTqVK5mHTU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pan Bian <bianpan2016@163.com>,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: [PATCH 4.19 269/321] staging: rtl8192e: fix potential use after free
Date:   Tue,  3 Dec 2019 23:35:35 +0100
Message-Id: <20191203223441.119224182@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191203223427.103571230@linuxfoundation.org>
References: <20191203223427.103571230@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pan Bian <bianpan2016@163.com>

commit b7aa39a2ed0112d07fc277ebd24a08a7b2368ab9 upstream.

The variable skb is released via kfree_skb() when the return value of
_rtl92e_tx is not zero. However, after that, skb is accessed again to
read its length, which may result in a use after free bug. This patch
fixes the bug by moving the release operation to where skb is never
used later.

Signed-off-by: Pan Bian <bianpan2016@163.com>
Reviewed-by: Dan Carpenter <dan.carpenter@oracle.com>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/1572965351-6745-1-git-send-email-bianpan2016@163.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/staging/rtl8192e/rtl8192e/rtl_core.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/staging/rtl8192e/rtl8192e/rtl_core.c
+++ b/drivers/staging/rtl8192e/rtl8192e/rtl_core.c
@@ -1627,14 +1627,15 @@ static void _rtl92e_hard_data_xmit(struc
 	memcpy((unsigned char *)(skb->cb), &dev, sizeof(dev));
 	skb_push(skb, priv->rtllib->tx_headroom);
 	ret = _rtl92e_tx(dev, skb);
-	if (ret != 0)
-		kfree_skb(skb);
 
 	if (queue_index != MGNT_QUEUE) {
 		priv->rtllib->stats.tx_bytes += (skb->len -
 						 priv->rtllib->tx_headroom);
 		priv->rtllib->stats.tx_packets++;
 	}
+
+	if (ret != 0)
+		kfree_skb(skb);
 }
 
 static int _rtl92e_hard_start_xmit(struct sk_buff *skb, struct net_device *dev)


