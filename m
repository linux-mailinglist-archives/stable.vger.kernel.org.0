Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EBEBB17817A
	for <lists+stable@lfdr.de>; Tue,  3 Mar 2020 20:02:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388251AbgCCSCf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Mar 2020 13:02:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:47300 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388248AbgCCSCf (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Mar 2020 13:02:35 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 91F3F20656;
        Tue,  3 Mar 2020 18:02:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583258555;
        bh=FPVa7EgyFbqzPMP9b5UqFWfiQfjcJ/p/YEDAggvfVJs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eEFQMb8FZtDDFIS/j82+CpRd02FBqggUFpC55hg68RndCt8q8jZgiAKvyCI1TdgxK
         KKDUMoWB27J2rbkWQWnThJK8ZzSxLMrL91Mj8Pi/DBSmJP8FEai3b66xxkdIvmEqcA
         xPO88heqa8stEqV54a9FX54sIzv+6G2vcEi+SIX8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.19 76/87] drivers: net: xgene: Fix the order of the arguments of alloc_etherdev_mqs()
Date:   Tue,  3 Mar 2020 18:44:07 +0100
Message-Id: <20200303174357.083595653@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200303174349.075101355@linuxfoundation.org>
References: <20200303174349.075101355@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

commit 5a44c71ccda60a50073c5d7fe3f694cdfa3ab0c2 upstream.

'alloc_etherdev_mqs()' expects first 'tx', then 'rx'. The semantic here
looks reversed.

Reorder the arguments passed to 'alloc_etherdev_mqs()' in order to keep
the correct semantic.

In fact, this is a no-op because both XGENE_NUM_[RT]X_RING are 8.

Fixes: 107dec2749fe ("drivers: net: xgene: Add support for multiple queues")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/ethernet/apm/xgene/xgene_enet_main.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/ethernet/apm/xgene/xgene_enet_main.c
+++ b/drivers/net/ethernet/apm/xgene/xgene_enet_main.c
@@ -2034,7 +2034,7 @@ static int xgene_enet_probe(struct platf
 	int ret;
 
 	ndev = alloc_etherdev_mqs(sizeof(struct xgene_enet_pdata),
-				  XGENE_NUM_RX_RING, XGENE_NUM_TX_RING);
+				  XGENE_NUM_TX_RING, XGENE_NUM_RX_RING);
 	if (!ndev)
 		return -ENOMEM;
 


