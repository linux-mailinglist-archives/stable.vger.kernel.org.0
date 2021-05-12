Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E764937CBA7
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 18:58:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235746AbhELQhM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:37:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:42394 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241691AbhELQ1v (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:27:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BFE2F616E8;
        Wed, 12 May 2021 15:55:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620834904;
        bh=IinN2jw2FW3k0CTyTPz3TpXXtJm++SBbxoWOUEJhtwA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=C9TtP0Bnh9bb6YU8NuVDNYvxwO1ZEba/IizgsI1XMbKOhlRqUcvGgfqeclHk6xq0h
         84uQf51xFbQDJTuSYIGB8Eveh/C8bUOhG7foDRgg5fjWEvJNpCsB0Ve14uKtJgtlJj
         zCEJrHKoo4zW7DC11yXi4athbaQLcufXIDiBfXHc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lv Yunlong <lyl2019@mail.ustc.edu.cn>,
        Xie He <xie.he.0141@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.12 130/677] Revert "drivers/net/wan/hdlc_fr: Fix a double free in pvc_xmit"
Date:   Wed, 12 May 2021 16:42:56 +0200
Message-Id: <20210512144841.543141879@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144837.204217980@linuxfoundation.org>
References: <20210512144837.204217980@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xie He <xie.he.0141@gmail.com>

commit d362fd0be456dba2d3d58a90b7a193962776562b upstream.

This reverts commit 1b479fb80160
("drivers/net/wan/hdlc_fr: Fix a double free in pvc_xmit").

1. This commit is incorrect. "__skb_pad" will NOT free the skb on
failure when its "free_on_error" parameter is "false".

2. This commit claims to fix my commit. But it didn't CC me??

Fixes: 1b479fb80160 ("drivers/net/wan/hdlc_fr: Fix a double free in pvc_xmit")
Cc: Lv Yunlong <lyl2019@mail.ustc.edu.cn>
Signed-off-by: Xie He <xie.he.0141@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wan/hdlc_fr.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/drivers/net/wan/hdlc_fr.c
+++ b/drivers/net/wan/hdlc_fr.c
@@ -415,7 +415,7 @@ static netdev_tx_t pvc_xmit(struct sk_bu
 
 		if (pad > 0) { /* Pad the frame with zeros */
 			if (__skb_pad(skb, pad, false))
-				goto out;
+				goto drop;
 			skb_put(skb, pad);
 		}
 	}
@@ -448,9 +448,8 @@ static netdev_tx_t pvc_xmit(struct sk_bu
 	return NETDEV_TX_OK;
 
 drop:
-	kfree_skb(skb);
-out:
 	dev->stats.tx_dropped++;
+	kfree_skb(skb);
 	return NETDEV_TX_OK;
 }
 


