Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 11801F407E
	for <lists+stable@lfdr.de>; Fri,  8 Nov 2019 07:38:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727016AbfKHGiW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Nov 2019 01:38:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:57860 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725372AbfKHGiW (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Nov 2019 01:38:22 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D726B21D6C;
        Fri,  8 Nov 2019 06:38:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573195100;
        bh=ieq994yZc2Vpj4i3TC+W/mt+eyZaGMkEyFcmL4nTI8g=;
        h=Subject:To:From:Date:From;
        b=vH/D/asO7jEghIKHxje/vgMRjeu/sG/FMQpkfScSIkhaGylZMthls5PUMX0b+FCsd
         K8CJFWJMfi1PK0L3qW3XrNQGuGLrry7rqS4VQimV44sYgVLzDduZjwx5JrQkYu+XQK
         ZID5IilUHC24cXmQ7Hkc0fEHZ27Gek6f0bPzf5t0=
Subject: patch "staging: rtl8192e: fix potential use after free" added to staging-next
To:     bianpan2016@163.com, dan.carpenter@oracle.com,
        gregkh@linuxfoundation.org, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 08 Nov 2019 07:38:00 +0100
Message-ID: <1573195080160125@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    staging: rtl8192e: fix potential use after free

to my staging git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git
in the staging-next branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will also be merged in the next major kernel release
during the merge window.

If you have any questions about this process, please let me know.


From b7aa39a2ed0112d07fc277ebd24a08a7b2368ab9 Mon Sep 17 00:00:00 2001
From: Pan Bian <bianpan2016@163.com>
Date: Tue, 5 Nov 2019 22:49:11 +0800
Subject: staging: rtl8192e: fix potential use after free

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
 drivers/staging/rtl8192e/rtl8192e/rtl_core.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/rtl8192e/rtl8192e/rtl_core.c b/drivers/staging/rtl8192e/rtl8192e/rtl_core.c
index b08712a9c029..dace81a7d1ba 100644
--- a/drivers/staging/rtl8192e/rtl8192e/rtl_core.c
+++ b/drivers/staging/rtl8192e/rtl8192e/rtl_core.c
@@ -1616,14 +1616,15 @@ static void _rtl92e_hard_data_xmit(struct sk_buff *skb, struct net_device *dev,
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
-- 
2.24.0


