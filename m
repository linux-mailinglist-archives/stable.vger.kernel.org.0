Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5D8BF32BE7
	for <lists+stable@lfdr.de>; Mon,  3 Jun 2019 11:14:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726561AbfFCJMi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Jun 2019 05:12:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:59786 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728652AbfFCJMe (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Jun 2019 05:12:34 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7EF4D26121;
        Mon,  3 Jun 2019 09:12:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559553154;
        bh=lFZ3PGfZK2qjQolczzZuiGrnCp8ui3kQL4gKKqL5Ufk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TLb1eIgJbZEDJ1BSUAeJYuIJ24ayY7H7XwDWrawli/HXaeVSnPk3ix8/4AwtvQFvG
         x/wvK2SfZ3LHPkBOa+gXJ9/IY5BNY+rBFlZjvClsEHVmFRB3dMmcjitbGZmoZmR2+m
         hAYnxGVZEny3y+WMC8nTo1yX3e6VaZa2fIRyPgfk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Chan <michael.chan@broadcom.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.0 28/36] bnxt_en: Reduce memory usage when running in kdump kernel.
Date:   Mon,  3 Jun 2019 11:09:16 +0200
Message-Id: <20190603090522.857884217@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190603090520.998342694@linuxfoundation.org>
References: <20190603090520.998342694@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Chan <michael.chan@broadcom.com>

[ Upstream commit d629522e1d66561f38e5c8d4f52bb6d254ec0707 ]

Skip RDMA context memory allocations, reduce to 1 ring, and disable
TPA when running in the kdump kernel.  Without this patch, the driver
fails to initialize with memory allocation errors when running in a
typical kdump kernel.

Fixes: cf6daed098d1 ("bnxt_en: Increase context memory allocations on 57500 chips for RDMA.")
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c |    4 ++--
 drivers/net/ethernet/broadcom/bnxt/bnxt.h |    4 +++-
 2 files changed, 5 insertions(+), 3 deletions(-)

--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -6338,7 +6338,7 @@ static int bnxt_alloc_ctx_mem(struct bnx
 	if (!ctx || (ctx->flags & BNXT_CTX_FLAG_INITED))
 		return 0;
 
-	if (bp->flags & BNXT_FLAG_ROCE_CAP) {
+	if ((bp->flags & BNXT_FLAG_ROCE_CAP) && !is_kdump_kernel()) {
 		pg_lvl = 2;
 		extra_qps = 65536;
 		extra_srqs = 8192;
@@ -10279,7 +10279,7 @@ static int bnxt_set_dflt_rings(struct bn
 
 	if (sh)
 		bp->flags |= BNXT_FLAG_SHARED_RINGS;
-	dflt_rings = netif_get_num_default_rss_queues();
+	dflt_rings = is_kdump_kernel() ? 1 : netif_get_num_default_rss_queues();
 	/* Reduce default rings on multi-port cards so that total default
 	 * rings do not exceed CPU count.
 	 */
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
@@ -20,6 +20,7 @@
 
 #include <linux/interrupt.h>
 #include <linux/rhashtable.h>
+#include <linux/crash_dump.h>
 #include <net/devlink.h>
 #include <net/dst_metadata.h>
 #include <net/switchdev.h>
@@ -1367,7 +1368,8 @@ struct bnxt {
 #define BNXT_CHIP_TYPE_NITRO_A0(bp) ((bp)->flags & BNXT_FLAG_CHIP_NITRO_A0)
 #define BNXT_RX_PAGE_MODE(bp)	((bp)->flags & BNXT_FLAG_RX_PAGE_MODE)
 #define BNXT_SUPPORTS_TPA(bp)	(!BNXT_CHIP_TYPE_NITRO_A0(bp) &&	\
-				 !(bp->flags & BNXT_FLAG_CHIP_P5))
+				 !(bp->flags & BNXT_FLAG_CHIP_P5) &&	\
+				 !is_kdump_kernel())
 
 /* Chip class phase 5 */
 #define BNXT_CHIP_P5(bp)			\


