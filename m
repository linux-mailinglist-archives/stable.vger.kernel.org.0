Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0819418B75E
	for <lists+stable@lfdr.de>; Thu, 19 Mar 2020 14:33:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727082AbgCSNdD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Mar 2020 09:33:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:33914 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729302AbgCSNO2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Mar 2020 09:14:28 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EE77620724;
        Thu, 19 Mar 2020 13:14:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584623668;
        bh=RxU2i+7ozgAdBFVOgCWg0lqlD9c1Uukji2c6jfD6wfA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MkKpH4Y5y691EYoCZDHWPDHIVzJYI01QySiTkMX3LlDwtbYfkg6Q5wIvmusi1Pk1T
         7fnUhrgOCm+zNutswuuiP4B8S8RztkXR1FAoQLhiBMrnKrBTf/0PwV0v3fIGLYNNBv
         9d8r+FtkmKwXr9a5gMS8zy2FW6/S0LgY1JECR5aE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Vasundhara Volam <vasundhara-v.volam@broadcom.com>,
        Michael Chan <michael.chan@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.14 14/99] bnxt_en: reinitialize IRQs when MTU is modified
Date:   Thu, 19 Mar 2020 14:02:52 +0100
Message-Id: <20200319123945.924942922@linuxfoundation.org>
X-Mailer: git-send-email 2.25.2
In-Reply-To: <20200319123941.630731708@linuxfoundation.org>
References: <20200319123941.630731708@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vasundhara Volam <vasundhara-v.volam@broadcom.com>

[ Upstream commit a9b952d267e59a3b405e644930f46d252cea7122 ]

MTU changes may affect the number of IRQs so we must call
bnxt_close_nic()/bnxt_open_nic() with the irq_re_init parameter
set to true.  The reason is that a larger MTU may require
aggregation rings not needed with smaller MTU.  We may not be
able to allocate the required number of aggregation rings and
so we reduce the number of channels which will change the number
of IRQs.  Without this patch, it may crash eventually in
pci_disable_msix() when the IRQs are not properly unwound.

Fixes: c0c050c58d84 ("bnxt_en: New Broadcom ethernet driver.")
Signed-off-by: Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -7310,13 +7310,13 @@ static int bnxt_change_mtu(struct net_de
 	struct bnxt *bp = netdev_priv(dev);
 
 	if (netif_running(dev))
-		bnxt_close_nic(bp, false, false);
+		bnxt_close_nic(bp, true, false);
 
 	dev->mtu = new_mtu;
 	bnxt_set_ring_params(bp);
 
 	if (netif_running(dev))
-		return bnxt_open_nic(bp, false, false);
+		return bnxt_open_nic(bp, true, false);
 
 	return 0;
 }


