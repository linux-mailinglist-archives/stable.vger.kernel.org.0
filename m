Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C317C53A74A
	for <lists+stable@lfdr.de>; Wed,  1 Jun 2022 15:59:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353955AbiFAN7b (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Jun 2022 09:59:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354050AbiFAN64 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Jun 2022 09:58:56 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12588A0058;
        Wed,  1 Jun 2022 06:55:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 70EFDCE1AF2;
        Wed,  1 Jun 2022 13:55:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E67E9C3411E;
        Wed,  1 Jun 2022 13:55:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654091755;
        bh=ynjdX7sqIzj3XGbBUvL+J2pZWNuexzQpo7a/4F/yD1M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tJU6CMFqK+JBfaDiWNzVhvkaJSjREMOeUTZSeCoMAO9lNzsBfFVKt3reLwfvl2Bdk
         1e7yzX6dVJfnjlIVeCMYCu1Jz62SFMAhoKtOJv8FsLnq5pyKdwVa0NFJfSd2pH8dXr
         4IPUpzg24d1SGRm4KHOxpSkRMM6u9qlSrR/BsERn1up6z5R7Avx1egj+g2SKouorli
         W/B3vIE2ZZ/m6f8BVp4WisYgRC5jPMEnCs738bSTFtIhpIq+daXIF0QneoaGOqX3xD
         M4kLgDl4x1P3zStT0oT0gdUsWVmCfZZbtFCPfKmiLrmapOhvPftJJIQq906IxY4wxb
         XelbwRgNMrl4Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Haren Myneni <haren@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>, davem@davemloft.net,
        npiggin@gmail.com, linuxppc-dev@lists.ozlabs.org,
        linux-crypto@vger.kernel.org
Subject: [PATCH AUTOSEL 5.17 38/48] powerpc/powernv/vas: Assign real address to rx_fifo in vas_rx_win_attr
Date:   Wed,  1 Jun 2022 09:54:11 -0400
Message-Id: <20220601135421.2003328-38-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220601135421.2003328-1-sashal@kernel.org>
References: <20220601135421.2003328-1-sashal@kernel.org>
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
index 57573d9c1e09..56834a8a1465 100644
--- a/arch/powerpc/include/asm/vas.h
+++ b/arch/powerpc/include/asm/vas.h
@@ -112,7 +112,7 @@ static inline void vas_user_win_add_mm_context(struct vas_user_win_ref *ref)
  * Receive window attributes specified by the (in-kernel) owner of window.
  */
 struct vas_rx_win_attr {
-	void *rx_fifo;
+	u64 rx_fifo;
 	int rx_fifo_size;
 	int wcreds_max;
 
diff --git a/arch/powerpc/platforms/powernv/vas-fault.c b/arch/powerpc/platforms/powernv/vas-fault.c
index a7aabc18039e..c1bfad56447d 100644
--- a/arch/powerpc/platforms/powernv/vas-fault.c
+++ b/arch/powerpc/platforms/powernv/vas-fault.c
@@ -216,7 +216,7 @@ int vas_setup_fault_window(struct vas_instance *vinst)
 	vas_init_rx_win_attr(&attr, VAS_COP_TYPE_FAULT);
 
 	attr.rx_fifo_size = vinst->fault_fifo_size;
-	attr.rx_fifo = vinst->fault_fifo;
+	attr.rx_fifo = __pa(vinst->fault_fifo);
 
 	/*
 	 * Max creds is based on number of CRBs can fit in the FIFO.
diff --git a/arch/powerpc/platforms/powernv/vas-window.c b/arch/powerpc/platforms/powernv/vas-window.c
index 0f8d39fbf2b2..0072682531d8 100644
--- a/arch/powerpc/platforms/powernv/vas-window.c
+++ b/arch/powerpc/platforms/powernv/vas-window.c
@@ -404,7 +404,7 @@ static void init_winctx_regs(struct pnv_vas_window *window,
 	 *
 	 * See also: Design note in function header.
 	 */
-	val = __pa(winctx->rx_fifo);
+	val = winctx->rx_fifo;
 	val = SET_FIELD(VAS_PAGE_MIGRATION_SELECT, val, 0);
 	write_hvwc_reg(window, VREG(LFIFO_BAR), val);
 
@@ -739,7 +739,7 @@ static void init_winctx_for_rxwin(struct pnv_vas_window *rxwin,
 		 */
 		winctx->fifo_disable = true;
 		winctx->intr_disable = true;
-		winctx->rx_fifo = NULL;
+		winctx->rx_fifo = 0;
 	}
 
 	winctx->lnotify_lpid = rxattr->lnotify_lpid;
diff --git a/arch/powerpc/platforms/powernv/vas.h b/arch/powerpc/platforms/powernv/vas.h
index 8bb08e395de0..08d9d3d5a22b 100644
--- a/arch/powerpc/platforms/powernv/vas.h
+++ b/arch/powerpc/platforms/powernv/vas.h
@@ -376,7 +376,7 @@ struct pnv_vas_window {
  * is a container for the register fields in the window context.
  */
 struct vas_winctx {
-	void *rx_fifo;
+	u64 rx_fifo;
 	int rx_fifo_size;
 	int wcreds_max;
 	int rsvd_txbuf_count;
diff --git a/drivers/crypto/nx/nx-common-powernv.c b/drivers/crypto/nx/nx-common-powernv.c
index 32a036ada5d0..f418817c0f43 100644
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

