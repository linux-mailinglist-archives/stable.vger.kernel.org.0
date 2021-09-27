Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C789419AC8
	for <lists+stable@lfdr.de>; Mon, 27 Sep 2021 19:10:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235948AbhI0RMS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Sep 2021 13:12:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:48116 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236610AbhI0RKP (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Sep 2021 13:10:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CEAC861178;
        Mon, 27 Sep 2021 17:07:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632762472;
        bh=Qph3P2vCb/2ExWigLookIyt32+Kp6aSqwYW2z8dJTbE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sPLUkI+6fr9OKKIAo2HWg4FrFIniEEct+locW2JzIlcOXdK6PDzvnxljytjgyQ6vv
         /G+z5wkBHjJR14bulrUX6W+9CQilJZkolsVKIfm6lK2nJAEDhH5oZkLxs74oYI4I7r
         SD/26nuocrz2Z6Jq4zUtaIuNp1zTeZrAkNlJ/pQg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Claudiu Manoil <claudiu.manoil@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 036/103] enetc: Fix illegal access when reading affinity_hint
Date:   Mon, 27 Sep 2021 19:02:08 +0200
Message-Id: <20210927170226.996416573@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210927170225.702078779@linuxfoundation.org>
References: <20210927170225.702078779@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Claudiu Manoil <claudiu.manoil@nxp.com>

[ Upstream commit 7237a494decfa17d0b9d0076e6cee3235719de90 ]

irq_set_affinity_hit() stores a reference to the cpumask_t
parameter in the irq descriptor, and that reference can be
accessed later from irq_affinity_hint_proc_show(). Since
the cpu_mask parameter passed to irq_set_affinity_hit() has
only temporary storage (it's on the stack memory), later
accesses to it are illegal. Thus reads from the corresponding
procfs affinity_hint file can result in paging request oops.

The issue is fixed by the get_cpu_mask() helper, which provides
a permanent storage for the cpumask_t parameter.

Fixes: d4fd0404c1c9 ("enetc: Introduce basic PF and VF ENETC ethernet drivers")
Signed-off-by: Claudiu Manoil <claudiu.manoil@nxp.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/freescale/enetc/enetc.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc.c b/drivers/net/ethernet/freescale/enetc/enetc.c
index df4a858c8001..6877f8e2047b 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc.c
@@ -1320,7 +1320,6 @@ static void enetc_clear_bdrs(struct enetc_ndev_priv *priv)
 static int enetc_setup_irqs(struct enetc_ndev_priv *priv)
 {
 	struct pci_dev *pdev = priv->si->pdev;
-	cpumask_t cpu_mask;
 	int i, j, err;
 
 	for (i = 0; i < priv->bdr_int_num; i++) {
@@ -1349,9 +1348,7 @@ static int enetc_setup_irqs(struct enetc_ndev_priv *priv)
 
 			enetc_wr(hw, ENETC_SIMSITRV(idx), entry);
 		}
-		cpumask_clear(&cpu_mask);
-		cpumask_set_cpu(i % num_online_cpus(), &cpu_mask);
-		irq_set_affinity_hint(irq, &cpu_mask);
+		irq_set_affinity_hint(irq, get_cpu_mask(i % num_online_cpus()));
 	}
 
 	return 0;
-- 
2.33.0



