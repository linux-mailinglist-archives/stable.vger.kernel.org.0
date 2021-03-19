Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6513341C49
	for <lists+stable@lfdr.de>; Fri, 19 Mar 2021 13:20:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230187AbhCSMUK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Mar 2021 08:20:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:57664 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230284AbhCSMTt (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Mar 2021 08:19:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D2C7F64F72;
        Fri, 19 Mar 2021 12:19:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616156389;
        bh=nAUcEeJ1NK06Tz29gmNhIMfD/AN88L6AkmVtSbLQYqM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YphzPndK5IopZWulB0qijnXgrIsr3osllWZfqVUHxN1B09CiiK7x3CsrBi1wv5jda
         /reMLPkr2KZg2taCnhs+2O4SjsVlOL3nOOkYmmh7tKmu8S2TGQWrzmcACexptHAc5Z
         0FJjvTpdckxPn2jKJxlb1tbS4XN/COlNffCBN8DU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Colin Xu <colin.xu@intel.com>
Subject: [PATCH 5.4 09/18] drm/i915/gvt: Fix mmio handler break on BXT/APL.
Date:   Fri, 19 Mar 2021 13:18:47 +0100
Message-Id: <20210319121745.770745914@linuxfoundation.org>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210319121745.449875976@linuxfoundation.org>
References: <20210319121745.449875976@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Colin Xu <colin.xu@intel.com>

commit 92010a97098c4c9fd777408cc98064d26b32695b upstream

- Remove dup mmio handler for BXT/APL. Otherwise mmio handler will fail
  to init.
- Add engine GPR with F_CMD_ACCESS since BXT/APL will load them via
  LRI. Otherwise, guest will enter failsafe mode.

V2:
Use RCS/BCS GPR macros instead of offset.
Revise commit message.

V3:
Use GEN8_RING_CS_GPR macros on ring base.

Reviewed-by: Zhenyu Wang <zhenyuw@linux.intel.com>
Signed-off-by: Colin Xu <colin.xu@intel.com>
Signed-off-by: Zhenyu Wang <zhenyuw@linux.intel.com>
Link: http://patchwork.freedesktop.org/patch/msgid/20201016052913.209248-1-colin.xu@intel.com
(cherry picked from commit 92010a97098c4c9fd777408cc98064d26b32695b)
Signed-off-by: Colin Xu <colin.xu@intel.com>
Cc: <stable@vger.kernel.org> # 5.4.y
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/gvt/handlers.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/i915/gvt/handlers.c
+++ b/drivers/gpu/drm/i915/gvt/handlers.c
@@ -3132,7 +3132,7 @@ static int init_skl_mmio_info(struct int
 		 NULL, NULL);
 
 	MMIO_D(GAMT_CHKN_BIT_REG, D_KBL | D_CFL);
-	MMIO_D(GEN9_CTX_PREEMPT_REG, D_SKL_PLUS);
+	MMIO_D(GEN9_CTX_PREEMPT_REG, D_SKL_PLUS & ~D_BXT);
 
 	return 0;
 }
@@ -3306,6 +3306,12 @@ static int init_bxt_mmio_info(struct int
 	MMIO_D(GEN8_PUSHBUS_SHIFT, D_BXT);
 	MMIO_D(GEN6_GFXPAUSE, D_BXT);
 	MMIO_DFH(GEN8_L3SQCREG1, D_BXT, F_CMD_ACCESS, NULL, NULL);
+	MMIO_DFH(GEN8_L3CNTLREG, D_BXT, F_CMD_ACCESS, NULL, NULL);
+	MMIO_DFH(_MMIO(0x20D8), D_BXT, F_CMD_ACCESS, NULL, NULL);
+	MMIO_F(HSW_CS_GPR(0), 0x40, F_CMD_ACCESS, 0, 0, D_BXT, NULL, NULL);
+	MMIO_F(_MMIO(0x12600), 0x40, F_CMD_ACCESS, 0, 0, D_BXT, NULL, NULL);
+	MMIO_F(BCS_GPR(0), 0x40, F_CMD_ACCESS, 0, 0, D_BXT, NULL, NULL);
+	MMIO_F(_MMIO(0x1a600), 0x40, F_CMD_ACCESS, 0, 0, D_BXT, NULL, NULL);
 
 	MMIO_DFH(GEN9_CTX_PREEMPT_REG, D_BXT, F_CMD_ACCESS, NULL, NULL);
 


