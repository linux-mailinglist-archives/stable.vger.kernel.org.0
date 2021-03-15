Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2350B33B999
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:08:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234360AbhCOOGR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 10:06:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:37820 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233472AbhCOOBo (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 10:01:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A559E64EEF;
        Mon, 15 Mar 2021 14:01:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816902;
        bh=/vJDTPrN7rS8uO5Sccty2NbMJzCiahnO/8xXXkGJJpg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kfqMN9IBhTNTGYqSnQGG1cDtxiYBUW319BoTumRcW8KfMXcDl6hHvH3u/w6AdsbCf
         uL2+P6jBPjH2ejkdhwN4g1yO7OGbVp6/vp+UgHSQfTrI7tpo49WwIMnoOiedLyXma7
         n0vhTqjRw9zdk2MnIIz7KkJ14WRJJK2wg30Nt2D4=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Frank Li <Frank.Li@nxp.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 5.11 191/306] mmc: cqhci: Fix random crash when remove mmc module/card
Date:   Mon, 15 Mar 2021 14:54:14 +0100
Message-Id: <20210315135514.065173812@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135507.611436477@linuxfoundation.org>
References: <20210315135507.611436477@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Frank Li <lznuaa@gmail.com>

commit f06391c45e83f9a731045deb23df7cc3814fd795 upstream.

[ 6684.493350] Unable to handle kernel paging request at virtual address ffff800011c5b0f0
[ 6684.498531] mmc0: card 0001 removed
[ 6684.501556] Mem abort info:
[ 6684.509681]   ESR = 0x96000047
[ 6684.512786]   EC = 0x25: DABT (current EL), IL = 32 bits
[ 6684.518394]   SET = 0, FnV = 0
[ 6684.521707]   EA = 0, S1PTW = 0
[ 6684.524998] Data abort info:
[ 6684.528236]   ISV = 0, ISS = 0x00000047
[ 6684.532986]   CM = 0, WnR = 1
[ 6684.536129] swapper pgtable: 4k pages, 48-bit VAs, pgdp=0000000081b22000
[ 6684.543923] [ffff800011c5b0f0] pgd=00000000bffff003, p4d=00000000bffff003, pud=00000000bfffe003, pmd=00000000900e1003, pte=0000000000000000
[ 6684.557915] Internal error: Oops: 96000047 [#1] PREEMPT SMP
[ 6684.564240] Modules linked in: sdhci_esdhc_imx(-) sdhci_pltfm sdhci cqhci mmc_block mmc_core fsl_jr_uio caam_jr caamkeyblob_desc caamhash_desc caamalg_desc crypto_engine rng_core authenc libdes crct10dif_ce flexcan can_dev caam error [last unloaded: mmc_core]
[ 6684.587281] CPU: 0 PID: 79138 Comm: kworker/0:3H Not tainted 5.10.9-01410-g3ba33182767b-dirty #10
[ 6684.596160] Hardware name: Freescale i.MX8DXL EVK (DT)
[ 6684.601320] Workqueue: kblockd blk_mq_run_work_fn

[ 6684.606094] pstate: 40000005 (nZcv daif -PAN -UAO -TCO BTYPE=--)
[ 6684.612286] pc : cqhci_request+0x148/0x4e8 [cqhci]
^GMessage from syslogd@  at Thu Jan  1 01:51:24 1970 ...[ 6684.617085] lr : cqhci_request+0x314/0x4e8 [cqhci]
[ 6684.626734] sp : ffff80001243b9f0
[ 6684.630049] x29: ffff80001243b9f0 x28: ffff00002c3dd000
[ 6684.635367] x27: 0000000000000001 x26: 0000000000000001
[ 6684.640690] x25: ffff00002c451000 x24: 000000000000000f
[ 6684.646007] x23: ffff000017e71c80 x22: ffff00002c451000
[ 6684.651326] x21: ffff00002c0f3550 x20: ffff00002c0f3550
[ 6684.656651] x19: ffff000017d46880 x18: ffff00002cea1500
[ 6684.661977] x17: 0000000000000000 x16: 0000000000000000
[ 6684.667294] x15: 000001ee628e3ed1 x14: 0000000000000278
[ 6684.672610] x13: 0000000000000001 x12: 0000000000000001
[ 6684.677927] x11: 0000000000000000 x10: 0000000000000000
[ 6684.683243] x9 : 000000000000002b x8 : 0000000000001000
[ 6684.688560] x7 : 0000000000000010 x6 : ffff00002c0f3678
[ 6684.693886] x5 : 000000000000000f x4 : ffff800011c5b000
[ 6684.699211] x3 : 000000000002d988 x2 : 0000000000000008
[ 6684.704537] x1 : 00000000000000f0 x0 : 0002d9880008102f
[ 6684.709854] Call trace:
[ 6684.712313]  cqhci_request+0x148/0x4e8 [cqhci]
[ 6684.716803]  mmc_cqe_start_req+0x58/0x68 [mmc_core]
[ 6684.721698]  mmc_blk_mq_issue_rq+0x460/0x810 [mmc_block]
[ 6684.727018]  mmc_mq_queue_rq+0x118/0x2b0 [mmc_block]

The problem occurs when cqhci_request() get called after cqhci_disable() as
it leads to access of allocated memory that has already been freed. Let's
fix the problem by calling cqhci_disable() a bit later in the remove path.

Signed-off-by: Frank Li <Frank.Li@nxp.com>
Diagnosed-by: Adrian Hunter <adrian.hunter@intel.com>
Acked-by: Adrian Hunter <adrian.hunter@intel.com>
Link: https://lore.kernel.org/r/20210303174248.542175-1-Frank.Li@nxp.com
Fixes: f690f4409ddd ("mmc: mmc: Enable CQE's")
Cc: stable@vger.kernel.org
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/core/bus.c |   11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

--- a/drivers/mmc/core/bus.c
+++ b/drivers/mmc/core/bus.c
@@ -399,11 +399,6 @@ void mmc_remove_card(struct mmc_card *ca
 	mmc_remove_card_debugfs(card);
 #endif
 
-	if (host->cqe_enabled) {
-		host->cqe_ops->cqe_disable(host);
-		host->cqe_enabled = false;
-	}
-
 	if (mmc_card_present(card)) {
 		if (mmc_host_is_spi(card->host)) {
 			pr_info("%s: SPI card removed\n",
@@ -416,6 +411,10 @@ void mmc_remove_card(struct mmc_card *ca
 		of_node_put(card->dev.of_node);
 	}
 
+	if (host->cqe_enabled) {
+		host->cqe_ops->cqe_disable(host);
+		host->cqe_enabled = false;
+	}
+
 	put_device(&card->dev);
 }
-


