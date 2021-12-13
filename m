Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 081654727BE
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 11:06:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241543AbhLMKEs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 05:04:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235685AbhLMKAq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 05:00:46 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05AAAC09B120;
        Mon, 13 Dec 2021 01:48:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 4EE7ACE0E92;
        Mon, 13 Dec 2021 09:48:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBFECC33A44;
        Mon, 13 Dec 2021 09:48:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639388935;
        bh=6kBPxSslbtJkTfjdNaA7EiZNeekOmRzTEIcOuJh+uZk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J5lsmFBaBw2O1DBQTJL3QMslMaa+7A3I1RmcR2Yob2/EXHzgp7psVoxSfvzunfEft
         ZjtJVb137dXY77tyZiAk3GTr90JXg6zuYCTMPeGMZ3vbXobNnxkrkfgbjHVpb+Uvw/
         ZwntQUmZtpYnDXg5UpWe5xeam3IG6cNuKBtVCWpo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 5.10 061/132] can: pch_can: pch_can_rx_normal: fix use after free
Date:   Mon, 13 Dec 2021 10:30:02 +0100
Message-Id: <20211213092941.218358729@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211213092939.074326017@linuxfoundation.org>
References: <20211213092939.074326017@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vincent Mailhol <mailhol.vincent@wanadoo.fr>

commit 94cddf1e9227a171b27292509d59691819c458db upstream.

After calling netif_receive_skb(skb), dereferencing skb is unsafe.
Especially, the can_frame cf which aliases skb memory is dereferenced
just after the call netif_receive_skb(skb).

Reordering the lines solves the issue.

Fixes: b21d18b51b31 ("can: Topcliff: Add PCH_CAN driver.")
Link: https://lore.kernel.org/all/20211123111654.621610-1-mailhol.vincent@wanadoo.fr
Cc: stable@vger.kernel.org
Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/can/pch_can.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/can/pch_can.c
+++ b/drivers/net/can/pch_can.c
@@ -692,11 +692,11 @@ static int pch_can_rx_normal(struct net_
 			cf->data[i + 1] = data_reg >> 8;
 		}
 
-		netif_receive_skb(skb);
 		rcv_pkts++;
 		stats->rx_packets++;
 		quota--;
 		stats->rx_bytes += cf->can_dlc;
+		netif_receive_skb(skb);
 
 		pch_fifo_thresh(priv, obj_num);
 		obj_num++;


