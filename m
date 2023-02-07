Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 720DE68D834
	for <lists+stable@lfdr.de>; Tue,  7 Feb 2023 14:07:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232178AbjBGNHh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Feb 2023 08:07:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232216AbjBGNHg (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Feb 2023 08:07:36 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C4257697
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 05:06:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id B90FACE1D90
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 13:05:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD8CCC4339B;
        Tue,  7 Feb 2023 13:05:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675775155;
        bh=YuAxhSscfdcXIpSSCrr/6za3dBM/xLH3uBpNT/2Ut+c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kZ0Mul67Ydjxv3g0Mxj23eC7pUQWdZkoSLftJWMIE9CbTN1EGgokOlLFro40MAjhp
         CjifWopFZJgaMkN45h+iZv6z9xbPafEvo4FCt4iYAwl9r77WC7yWYy1J/QO10ungoI
         +QHJ0U4bm3YxCgpGRLERJIMyGJ25DhbPblV7NYRY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        "Isaac J. Manjarres" <isaacmanjarres@google.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Calvin Zhang <calvinzhang.cool@gmail.com>,
        Frank Rowand <frowand.list@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        Saravana Kannan <saravanak@google.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.1 155/208] Revert "mm: kmemleak: alloc gray object for reserved region with direct map"
Date:   Tue,  7 Feb 2023 13:56:49 +0100
Message-Id: <20230207125641.483877071@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230207125634.292109991@linuxfoundation.org>
References: <20230207125634.292109991@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Isaac J. Manjarres <isaacmanjarres@google.com>

commit 8ef852f1cb426a5812aee700d3b4297aaa426acc upstream.

This reverts commit 972fa3a7c17c9d60212e32ecc0205dc585b1e769.

Kmemleak operates by periodically scanning memory regions for pointers to
allocated memory blocks to determine if they are leaked or not.  However,
reserved memory regions can be used for DMA transactions between a device
and a CPU, and thus, wouldn't contain pointers to allocated memory blocks,
making them inappropriate for kmemleak to scan.  Thus, revert this commit.

Link: https://lkml.kernel.org/r/20230124230254.295589-1-isaacmanjarres@google.com
Fixes: 972fa3a7c17c9 ("mm: kmemleak: alloc gray object for reserved region with direct map")
Signed-off-by: Isaac J. Manjarres <isaacmanjarres@google.com>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Cc: Calvin Zhang <calvinzhang.cool@gmail.com>
Cc: Frank Rowand <frowand.list@gmail.com>
Cc: Rob Herring <robh+dt@kernel.org>
Cc: Saravana Kannan <saravanak@google.com>
Cc: <stable@vger.kernel.org>	[5.17+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/of/fdt.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/of/fdt.c b/drivers/of/fdt.c
index f08b25195ae7..d1a68b6d03b3 100644
--- a/drivers/of/fdt.c
+++ b/drivers/of/fdt.c
@@ -26,7 +26,6 @@
 #include <linux/serial_core.h>
 #include <linux/sysfs.h>
 #include <linux/random.h>
-#include <linux/kmemleak.h>
 
 #include <asm/setup.h>  /* for COMMAND_LINE_SIZE */
 #include <asm/page.h>
@@ -525,12 +524,9 @@ static int __init __reserved_mem_reserve_reg(unsigned long node,
 		size = dt_mem_next_cell(dt_root_size_cells, &prop);
 
 		if (size &&
-		    early_init_dt_reserve_memory(base, size, nomap) == 0) {
+		    early_init_dt_reserve_memory(base, size, nomap) == 0)
 			pr_debug("Reserved memory: reserved region for node '%s': base %pa, size %lu MiB\n",
 				uname, &base, (unsigned long)(size / SZ_1M));
-			if (!nomap)
-				kmemleak_alloc_phys(base, size, 0);
-		}
 		else
 			pr_err("Reserved memory: failed to reserve memory for node '%s': base %pa, size %lu MiB\n",
 			       uname, &base, (unsigned long)(size / SZ_1M));
-- 
2.39.1



