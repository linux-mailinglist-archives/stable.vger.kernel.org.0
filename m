Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC6323005F6
	for <lists+stable@lfdr.de>; Fri, 22 Jan 2021 15:49:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728055AbhAVOsj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Jan 2021 09:48:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:40016 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728517AbhAVOYk (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Jan 2021 09:24:40 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8054D23BAF;
        Fri, 22 Jan 2021 14:19:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611325153;
        bh=birdTOT75bVz5Pb/jTyZNeLd2/yr1nrXGMflJ1+rR1o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0sTV1w7t9QMhOFaxxisdHbaNheJsaIQBNgIIveOJClntTEtVf87cVRluJ6iSKQBjR
         GpWUro5ffa7jiryklwwgpTzFnV8uyDBfPOeEbQtagBK5UTW6HxcE/L2z8cfz7rgOlD
         94Ms4fSkkKlInyjD9Orf0HdKUHXW+nAnb1oZI8RA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Seb Laveze <sebastien.laveze@nxp.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 35/43] net: stmmac: use __napi_schedule() for PREEMPT_RT
Date:   Fri, 22 Jan 2021 15:12:51 +0100
Message-Id: <20210122135737.083048352@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210122135735.652681690@linuxfoundation.org>
References: <20210122135735.652681690@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Seb Laveze <sebastien.laveze@nxp.com>

[ Upstream commit 1f02efd1bb35bee95feed6aab46d1217f29d555b ]

Use of __napi_schedule_irqoff() is not safe with PREEMPT_RT in which
hard interrupts are not disabled while running the threaded interrupt.

Using __napi_schedule() works for both PREEMPT_RT and mainline Linux,
just at the cost of an additional check if interrupts are disabled for
mainline (since they are already disabled).

Similar to the fix done for enetc commit 215602a8d212 ("enetc: use
napi_schedule to be compatible with PREEMPT_RT")

Signed-off-by: Seb Laveze <sebastien.laveze@nxp.com>
Link: https://lore.kernel.org/r/20210112140121.1487619-1-sebastien.laveze@oss.nxp.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -2158,7 +2158,7 @@ static int stmmac_napi_check(struct stmm
 			spin_lock_irqsave(&ch->lock, flags);
 			stmmac_disable_dma_irq(priv, priv->ioaddr, chan, 1, 0);
 			spin_unlock_irqrestore(&ch->lock, flags);
-			__napi_schedule_irqoff(&ch->rx_napi);
+			__napi_schedule(&ch->rx_napi);
 		}
 	}
 
@@ -2167,7 +2167,7 @@ static int stmmac_napi_check(struct stmm
 			spin_lock_irqsave(&ch->lock, flags);
 			stmmac_disable_dma_irq(priv, priv->ioaddr, chan, 0, 1);
 			spin_unlock_irqrestore(&ch->lock, flags);
-			__napi_schedule_irqoff(&ch->tx_napi);
+			__napi_schedule(&ch->tx_napi);
 		}
 	}
 


