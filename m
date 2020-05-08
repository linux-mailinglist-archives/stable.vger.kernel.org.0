Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F14ED1CADC2
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 15:06:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728370AbgEHNEd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 09:04:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:53776 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729353AbgEHMs6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 May 2020 08:48:58 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 845C024953;
        Fri,  8 May 2020 12:48:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588942138;
        bh=K0ZGYulBriFMjO4nLQ5/9iPqciULhpiG+A26PMQUrvM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ns7gFgZ/2AU7WA1DtI3KrxyKyVOFVwoxTHjvQvge78j1H8WKi4Nw/jtv1bGOyzj2C
         pQlg/AV5umd/b9YPy5+zPU7j34B0lt4XQHkcgnV1QgmWEP+9H3ArgOdMJoXlcb356/
         3YpH7NckmMI8IAJnEyzmjMdF9axJlvnJTO5k3Yaw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Florian Fainelli <f.fainelli@gmail.com>,
        Michael Chan <michael.chan@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.4 275/312] bnxt_en: Remove locking around txr->dev_state
Date:   Fri,  8 May 2020 14:34:26 +0200
Message-Id: <20200508123143.771875671@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200508123124.574959822@linuxfoundation.org>
References: <20200508123124.574959822@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Florian Fainelli <f.fainelli@gmail.com>

commit cbce91cad4ee39070bf3c7873767194e4be88e16 upstream.

txr->dev_state was not consistently manipulated with the acquisition of
the per-queue lock, after further inspection the lock does not seem
necessary, either the value is read as BNXT_DEV_STATE_CLOSING or 0.

Reported-by: coverity (CID 1339583)
Fixes: c0c050c58d840 ("bnxt_en: New Broadcom ethernet driver.")
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Acked-by: Michael Chan <michael.chan@broadcom.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c |    2 --
 1 file changed, 2 deletions(-)

--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -4310,9 +4310,7 @@ static void bnxt_tx_disable(struct bnxt
 			bnapi = bp->bnapi[i];
 			txr = &bnapi->tx_ring;
 			txq = netdev_get_tx_queue(bp->dev, i);
-			__netif_tx_lock(txq, smp_processor_id());
 			txr->dev_state = BNXT_DEV_STATE_CLOSING;
-			__netif_tx_unlock(txq);
 		}
 	}
 	/* Stop all TX queues */


