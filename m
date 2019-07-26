Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C32EA76DB2
	for <lists+stable@lfdr.de>; Fri, 26 Jul 2019 17:36:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389364AbfGZPcA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Jul 2019 11:32:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:47094 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388617AbfGZPcA (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 26 Jul 2019 11:32:00 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C188820644;
        Fri, 26 Jul 2019 15:31:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564155119;
        bh=ppr5BAOLZkqvQ0hhuWwGlJX9zzXOdBVO8hauVU+jdio=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dqvgSTG/13DDYwfl9Ht4afJYtTvJwqDYkL0+eHtWpE71f2Wk5tDE4KVVbiUf4QI5+
         kOPJTPuTF3CvmKCW9uBif8mRh5YPd9WVIk4hXNqmU7Ys3uBzQoUItWrilgUhdP/0yO
         UscagVPYIFLns4aX59jKWPllzXgAyoii5zxTE98M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Brian King <brking@linux.vnet.ibm.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.19 01/50] bnx2x: Prevent load reordering in tx completion processing
Date:   Fri, 26 Jul 2019 17:24:36 +0200
Message-Id: <20190726152300.923718700@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190726152300.760439618@linuxfoundation.org>
References: <20190726152300.760439618@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Brian King <brking@linux.vnet.ibm.com>

[ Upstream commit ea811b795df24644a8eb760b493c43fba4450677 ]

This patch fixes an issue seen on Power systems with bnx2x which results
in the skb is NULL WARN_ON in bnx2x_free_tx_pkt firing due to the skb
pointer getting loaded in bnx2x_free_tx_pkt prior to the hw_cons
load in bnx2x_tx_int. Adding a read memory barrier resolves the issue.

Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
@@ -286,6 +286,9 @@ int bnx2x_tx_int(struct bnx2x *bp, struc
 	hw_cons = le16_to_cpu(*txdata->tx_cons_sb);
 	sw_cons = txdata->tx_pkt_cons;
 
+	/* Ensure subsequent loads occur after hw_cons */
+	smp_rmb();
+
 	while (sw_cons != hw_cons) {
 		u16 pkt_cons;
 


