Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5ACFE420DD3
	for <lists+stable@lfdr.de>; Mon,  4 Oct 2021 15:17:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235973AbhJDNTM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Oct 2021 09:19:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:53702 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235581AbhJDNSA (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Oct 2021 09:18:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9500E6140A;
        Mon,  4 Oct 2021 13:07:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633352842;
        bh=J1iEKl133BFl8GS0D6zQaxSOG042pZEGzofHB6qkfrA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t+YAcXFKs9kh5veBVzom+m0URfE1fpsMiTCRT4tfcxbD/7UblvgrGvAhfTm0GjI9h
         alTrh9GEHBGiKuqRqCY0eWdsq2lRvb+GGKcejBdIf0hz4O1r0fjZFBD+lf8ryFEMlQ
         Y+nY1XQGIHTeAtz8s4BASm1ol6rECXjAzUvJjkfQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Leon Yu <leoyu@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Macpaul Lin <macpaul.lin@mediatek.com>
Subject: [PATCH 5.4 46/56] net: stmmac: dont attach interface until resume finishes
Date:   Mon,  4 Oct 2021 14:53:06 +0200
Message-Id: <20211004125031.454813586@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211004125030.002116402@linuxfoundation.org>
References: <20211004125030.002116402@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Leon Yu <leoyu@nvidia.com>

commit 31096c3e8b1163c6e966bf4d1f36d8b699008f84 upstream.

Commit 14b41a2959fb ("net: stmmac: Delete txtimer in suspend") was the
first attempt to fix a race between mod_timer() and setup_timer()
during stmmac_resume(). However the issue still exists as the commit
only addressed half of the issue.

Same race can still happen as stmmac_resume() re-attaches interface
way too early - even before hardware is fully initialized.  Worse,
doing so allows network traffic to restart and stmmac_tx_timer_arm()
being called in the middle of stmmac_resume(), which re-init tx timers
in stmmac_init_coalesce().  timer_list will be corrupted and system
crashes as a result of race between mod_timer() and setup_timer().

  systemd--1995    2.... 552950018us : stmmac_suspend: 4994
  ksoftirq-9       0..s2 553123133us : stmmac_tx_timer_arm: 2276
  systemd--1995    0.... 553127896us : stmmac_resume: 5101
  systemd--320     7...2 553132752us : stmmac_tx_timer_arm: 2276
  (sd-exec-1999    5...2 553135204us : stmmac_tx_timer_arm: 2276
  ---------------------------------
  pc : run_timer_softirq+0x468/0x5e0
  lr : run_timer_softirq+0x570/0x5e0
  Call trace:
   run_timer_softirq+0x468/0x5e0
   __do_softirq+0x124/0x398
   irq_exit+0xd8/0xe0
   __handle_domain_irq+0x6c/0xc0
   gic_handle_irq+0x60/0xb0
   el1_irq+0xb8/0x180
   arch_cpu_idle+0x38/0x230
   default_idle_call+0x24/0x3c
   do_idle+0x1e0/0x2b8
   cpu_startup_entry+0x28/0x48
   secondary_start_kernel+0x1b4/0x208

Fix this by deferring netif_device_attach() to the end of
stmmac_resume().

Signed-off-by: Leon Yu <leoyu@nvidia.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Cc: Macpaul Lin <macpaul.lin@mediatek.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_main.c
@@ -4855,8 +4855,6 @@ int stmmac_resume(struct device *dev)
 			stmmac_mdio_reset(priv->mii);
 	}
 
-	netif_device_attach(ndev);
-
 	mutex_lock(&priv->lock);
 
 	stmmac_reset_queues_param(priv);
@@ -4880,6 +4878,8 @@ int stmmac_resume(struct device *dev)
 
 	phylink_mac_change(priv->phylink, true);
 
+	netif_device_attach(ndev);
+
 	return 0;
 }
 EXPORT_SYMBOL_GPL(stmmac_resume);


