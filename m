Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 013B61F432A
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 19:51:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732731AbgFIRut (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Jun 2020 13:50:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:38818 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732722AbgFIRus (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 9 Jun 2020 13:50:48 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0F503207ED;
        Tue,  9 Jun 2020 17:50:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591725047;
        bh=I/C5wTw0k+vOVdGvsWnZiMB/R9OHvicC4Y/1i2mXlxo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eAuj9UdgxUMJkcEH7Yot58uKnVRr9YNzNMc+YFZVV7bYvQtdwmqx2r76ZpWFkbI5t
         6iV6kFs1/OPLXEZkUfPcS4HRQHvcKrutZn6dAlmtEK+dvnEdVP1SgqV/Dig+jqWpAc
         2fJOLuEo1qpM2HoSzBfgbX2Q6H7cnBuVH+5anDUo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hu Jiahui <kirin.say@gmail.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Eric Dumazet <edumazet@google.com>,
        Kalle Valo <kvalo@codeaurora.org>
Subject: [PATCH 4.14 22/46] airo: Fix read overflows sending packets
Date:   Tue,  9 Jun 2020 19:44:38 +0200
Message-Id: <20200609174026.228819624@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200609174022.938987501@linuxfoundation.org>
References: <20200609174022.938987501@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

commit 11e7a91994c29da96d847f676be023da6a2c1359 upstream.

The problem is that we always copy a minimum of ETH_ZLEN (60) bytes from
skb->data even when skb->len is less than ETH_ZLEN so it leads to a read
overflow.

The fix is to pad skb->data to at least ETH_ZLEN bytes.

Cc: <stable@vger.kernel.org>
Reported-by: Hu Jiahui <kirin.say@gmail.com>
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/20200527184830.GA1164846@mwanda
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/cisco/airo.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/drivers/net/wireless/cisco/airo.c
+++ b/drivers/net/wireless/cisco/airo.c
@@ -1928,6 +1928,10 @@ static netdev_tx_t mpi_start_xmit(struct
 		airo_print_err(dev->name, "%s: skb == NULL!",__func__);
 		return NETDEV_TX_OK;
 	}
+	if (skb_padto(skb, ETH_ZLEN)) {
+		dev->stats.tx_dropped++;
+		return NETDEV_TX_OK;
+	}
 	npacks = skb_queue_len (&ai->txq);
 
 	if (npacks >= MAXTXQ - 1) {
@@ -2130,6 +2134,10 @@ static netdev_tx_t airo_start_xmit(struc
 		airo_print_err(dev->name, "%s: skb == NULL!", __func__);
 		return NETDEV_TX_OK;
 	}
+	if (skb_padto(skb, ETH_ZLEN)) {
+		dev->stats.tx_dropped++;
+		return NETDEV_TX_OK;
+	}
 
 	/* Find a vacant FID */
 	for( i = 0; i < MAX_FIDS / 2 && (fids[i] & 0xffff0000); i++ );
@@ -2204,6 +2212,10 @@ static netdev_tx_t airo_start_xmit11(str
 		airo_print_err(dev->name, "%s: skb == NULL!", __func__);
 		return NETDEV_TX_OK;
 	}
+	if (skb_padto(skb, ETH_ZLEN)) {
+		dev->stats.tx_dropped++;
+		return NETDEV_TX_OK;
+	}
 
 	/* Find a vacant FID */
 	for( i = MAX_FIDS / 2; i < MAX_FIDS && (fids[i] & 0xffff0000); i++ );


