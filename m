Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B893B53A809
	for <lists+stable@lfdr.de>; Wed,  1 Jun 2022 16:08:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354588AbiFAOEv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Jun 2022 10:04:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354385AbiFAOEP (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Jun 2022 10:04:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70743AB0DD;
        Wed,  1 Jun 2022 06:58:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 456616149F;
        Wed,  1 Jun 2022 13:58:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B486CC385A5;
        Wed,  1 Jun 2022 13:58:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654091922;
        bh=iYB6LJ0axj8BzdWtlbpeeA22i2OHpc068qkkxc4c3f8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gjYSriit9i2vlh5ACEN5UHpM98a76lyVeE3JfmfoSehvA5t3g7hdzOWvlUVWdnE8Q
         tlNF0hNUfUzXd8ti/pKGWMp0ivFh9Q5SWVQTVoNVwAw6GpG0Q2CmsLcnjjgjj6F9Jx
         gpzfJcLDEGsdRac7MKTVpeUpkRM1TeUEcMev5FTvPv72zcBh69MldeX6105TNDb4u6
         Cs14oSiG7h/MROqVZovPLK/LAet5P27peuXKUd5hPMaiqsZ0pZhQXFAGNsUv0iBVrU
         4Y7m2ssN0vv8Mr1bPy3/yI2iCKu/pVtnol1Nbe2VGjLnecqV+KO7yjYX/VYtlCYNEb
         f5KBr5LxBbq8w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Haren Myneni <haren@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>, davem@davemloft.net,
        npiggin@gmail.com, linuxppc-dev@lists.ozlabs.org,
        linux-crypto@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 20/26] powerpc/powernv/vas: Assign real address to rx_fifo in vas_rx_win_attr
Date:   Wed,  1 Jun 2022 09:57:53 -0400
Message-Id: <20220601135759.2004435-20-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220601135759.2004435-1-sashal@kernel.org>
References: <20220601135759.2004435-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Haren Myneni <haren@linux.ibm.com>

[ Upstream commit c127d130f6d59fa81701f6b04023cf7cd1972fb3 ]

In init_winctx_regs(), __pa() is called on winctx->rx_fifo and this
function is called to initialize registers for receive and fault
windows. But the real address is passed in winctx->rx_fifo for
receive windows and the virtual address for fault windows which
causes errors with DEBUG_VIRTUAL enabled. Fixes this issue by
assigning only real address to rx_fifo in vas_rx_win_attr struct
for both receive and fault windows.

Reported-by: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Haren Myneni <haren@linux.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/338e958c7ab8f3b266fa794a1f80f99b9671829e.camel@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/include/asm/vas.h              | 2 +-
 arch/powerpc/platforms/powernv/vas-fault.c  | 2 +-
 arch/powerpc/platforms/powernv/vas-window.c | 4 ++--
 arch/powerpc/platforms/powernv/vas.h        | 2 +-
 drivers/crypto/nx/nx-common-powernv.c       | 2 +-
 5 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/arch/powerpc/include/asm/vas.h b/arch/powerpc/include/asm/vas.h
index e33f80b0ea81..47062b457049 100644
--- a/arch/powerpc/include/asm/vas.h
+++ b/arch/powerpc/include/asm/vas.h
@@ -52,7 +52,7 @@ enum vas_cop_type {
  * Receive window attributes specified by the (in-kernel) owner of window.
  */
 struct vas_rx_win_attr {
-	void *rx_fifo;
+	u64 rx_fifo;
 	int rx_fifo_size;
 	int wcreds_max;
 
diff --git a/arch/powerpc/platforms/powernv/vas-fault.c b/arch/powerpc/platforms/powernv/vas-fault.c
index 3d21fce254b7..dd9c23c09781 100644
--- a/arch/powerpc/platforms/powernv/vas-fault.c
+++ b/arch/powerpc/platforms/powernv/vas-fault.c
@@ -352,7 +352,7 @@ int vas_setup_fault_window(struct vas_instance *vinst)
 	vas_init_rx_win_attr(&attr, VAS_COP_TYPE_FAULT);
 
 	attr.rx_fifo_size = vinst->fault_fifo_size;
-	attr.rx_fifo = vinst->fault_fifo;
+	attr.rx_fifo = __pa(vinst->fault_fifo);
 
 	/*
 	 * Max creds is based on number of CRBs can fit in the FIFO.
diff --git a/arch/powerpc/platforms/powernv/vas-window.c b/arch/powerpc/platforms/powernv/vas-window.c
index 7ba0840fc3b5..3a86cdd5ae6c 100644
--- a/arch/powerpc/platforms/powernv/vas-window.c
+++ b/arch/powerpc/platforms/powernv/vas-window.c
@@ -403,7 +403,7 @@ static void init_winctx_regs(struct vas_window *window,
 	 *
 	 * See also: Design note in function header.
 	 */
-	val = __pa(winctx->rx_fifo);
+	val = winctx->rx_fifo;
 	val = SET_FIELD(VAS_PAGE_MIGRATION_SELECT, val, 0);
 	write_hvwc_reg(window, VREG(LFIFO_BAR), val);
 
@@ -737,7 +737,7 @@ static void init_winctx_for_rxwin(struct vas_window *rxwin,
 		 */
 		winctx->fifo_disable = true;
 		winctx->intr_disable = true;
-		winctx->rx_fifo = NULL;
+		winctx->rx_fifo = 0;
 	}
 
 	winctx->lnotify_lpid = rxattr->lnotify_lpid;
diff --git a/arch/powerpc/platforms/powernv/vas.h b/arch/powerpc/platforms/powernv/vas.h
index 70f793e8f6cc..1f6e73809205 100644
--- a/arch/powerpc/platforms/powernv/vas.h
+++ b/arch/powerpc/platforms/powernv/vas.h
@@ -383,7 +383,7 @@ struct vas_window {
  * is a container for the register fields in the window context.
  */
 struct vas_winctx {
-	void *rx_fifo;
+	u64 rx_fifo;
 	int rx_fifo_size;
 	int wcreds_max;
 	int rsvd_txbuf_count;
diff --git a/drivers/crypto/nx/nx-common-powernv.c b/drivers/crypto/nx/nx-common-powernv.c
index 13c65deda8e9..8a4f10bb3fcd 100644
--- a/drivers/crypto/nx/nx-common-powernv.c
+++ b/drivers/crypto/nx/nx-common-powernv.c
@@ -827,7 +827,7 @@ static int __init vas_cfg_coproc_info(struct device_node *dn, int chip_id,
 		goto err_out;
 
 	vas_init_rx_win_attr(&rxattr, coproc->ct);
-	rxattr.rx_fifo = (void *)rx_fifo;
+	rxattr.rx_fifo = rx_fifo;
 	rxattr.rx_fifo_size = fifo_size;
 	rxattr.lnotify_lpid = lpid;
 	rxattr.lnotify_pid = pid;
-- 
2.35.1

