Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0FAED19B25E
	for <lists+stable@lfdr.de>; Wed,  1 Apr 2020 18:44:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388115AbgDAQnZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Apr 2020 12:43:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:44164 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389459AbgDAQnY (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Apr 2020 12:43:24 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 122302063A;
        Wed,  1 Apr 2020 16:43:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585759403;
        bh=+4TU2j85QaBbPTyUaEv5pNZ13HPIguW05u2KrMkHw/w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uMN/i5A+XGiVHPr6o4RABs2aYLIgShs6j5Z6Cj5nCSx2Q8rjVpY52/b4FkzrkeaQ0
         bHBxCAxg/8jaDvmSSr8+aD+VhvLzfHAvbfPfd4FclsSK+g8mJGE71V/uYsX43GZMln
         jPUtVBfYp+sSdsVqEFY62lOqqSpPOlJEpuUnknD4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrew Smith <andrew.smith@digi.com>,
        =?UTF-8?q?Ren=C3=A9=20van=20Dorst?= <opensource@vdorst.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.14 068/148] net: dsa: mt7530: Change the LINK bit to reflect the link status
Date:   Wed,  1 Apr 2020 18:17:40 +0200
Message-Id: <20200401161600.097576252@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200401161552.245876366@linuxfoundation.org>
References: <20200401161552.245876366@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Ren� van Dorst" <opensource@vdorst.com>

[ Upstream commit 22259471b51925353bd7b16f864c79fdd76e425e ]

Andrew reported:

After a number of network port link up/down changes, sometimes the switch
port gets stuck in a state where it thinks it is still transmitting packets
but the cpu port is not actually transmitting anymore. In this state you
will see a message on the console
"mtk_soc_eth 1e100000.ethernet eth0: transmit timed out" and the Tx counter
in ifconfig will be incrementing on virtual port, but not incrementing on
cpu port.

The issue is that MAC TX/RX status has no impact on the link status or
queue manager of the switch. So the queue manager just queues up packets
of a disabled port and sends out pause frames when the queue is full.

Change the LINK bit to reflect the link status.

Fixes: b8f126a8d543 ("net-next: dsa: add dsa support for Mediatek MT7530 switch")
Reported-by: Andrew Smith <andrew.smith@digi.com>
Signed-off-by: René van Dorst <opensource@vdorst.com>
Reviewed-by: Vivien Didelot <vivien.didelot@gmail.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/dsa/mt7530.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/dsa/mt7530.c
+++ b/drivers/net/dsa/mt7530.c
@@ -549,7 +549,7 @@ mt7530_mib_reset(struct dsa_switch *ds)
 static void
 mt7530_port_set_status(struct mt7530_priv *priv, int port, int enable)
 {
-	u32 mask = PMCR_TX_EN | PMCR_RX_EN;
+	u32 mask = PMCR_TX_EN | PMCR_RX_EN | PMCR_FORCE_LNK;
 
 	if (enable)
 		mt7530_set(priv, MT7530_PMCR_P(port), mask);


