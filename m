Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B845D419BF9
	for <lists+stable@lfdr.de>; Mon, 27 Sep 2021 19:23:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236864AbhI0RYg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Sep 2021 13:24:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:35166 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235898AbhI0RWO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Sep 2021 13:22:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BFDA1613A8;
        Mon, 27 Sep 2021 17:14:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632762847;
        bh=A4ahRCMAKn0v+DioCp9jJOd8r99Q792ns3PteJVLp0k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ok3lBXxNjY0LYgupTxOdN19yiUYiPeRsvBXnHdiAUcFPs5jX6VLXLU0lP6yJdQcLD
         0xJmjKWTsp1kVCNpKkFuNNAnaMumwuQk7E/HjKAAiC7sHQaFDTwKrH5gvXqByW+xfs
         0ZqgRGHLCg8UtpUBLq/ylAcJvnNdg2ZSCEdfurnE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Claudiu Manoil <claudiu.manoil@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 056/162] enetc: Fix illegal access when reading affinity_hint
Date:   Mon, 27 Sep 2021 19:01:42 +0200
Message-Id: <20210927170235.427711689@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210927170233.453060397@linuxfoundation.org>
References: <20210927170233.453060397@linuxfoundation.org>
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
index 3ca93adb9662..7f90c27c0e79 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc.c
@@ -1879,7 +1879,6 @@ static void enetc_clear_bdrs(struct enetc_ndev_priv *priv)
 static int enetc_setup_irqs(struct enetc_ndev_priv *priv)
 {
 	struct pci_dev *pdev = priv->si->pdev;
-	cpumask_t cpu_mask;
 	int i, j, err;
 
 	for (i = 0; i < priv->bdr_int_num; i++) {
@@ -1908,9 +1907,7 @@ static int enetc_setup_irqs(struct enetc_ndev_priv *priv)
 
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



