Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A9504541CBD
	for <lists+stable@lfdr.de>; Wed,  8 Jun 2022 00:04:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382572AbiFGWDp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 18:03:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1382708AbiFGWCs (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 18:02:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D5991957A4;
        Tue,  7 Jun 2022 12:15:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4240F61846;
        Tue,  7 Jun 2022 19:15:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FEA0C385A5;
        Tue,  7 Jun 2022 19:15:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654629304;
        bh=RiYoesI/2/VhLz4xXzKPGtNRHm3pm6lxNILgLYxpFek=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XbeaXkKFGT2CZLiPm96FDGObiccqr8xFv25KFt0AwfV8elRDaZbwjOvV6BmnVmJO9
         qomDuXFYyn2wZEwUfIkJVwH/pytcmveA4JTVNj9OiuSKtrdEYuiHd+v6fRcqXSlfB6
         2/AaC5wYX8xBrGaVUvB0mFg2WoQfyNHRMMo3fLGY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaoqian Lin <linmq006@gmail.com>,
        =?UTF-8?q?C=C3=A9dric=20Le=20Goater?= <clg@kaod.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 644/879] powerpc/xive: Fix refcount leak in xive_spapr_init
Date:   Tue,  7 Jun 2022 19:02:42 +0200
Message-Id: <20220607165021.539731054@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607165002.659942637@linuxfoundation.org>
References: <20220607165002.659942637@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miaoqian Lin <linmq006@gmail.com>

[ Upstream commit 1d1fb9618bdd5a5fbf9a9eb75133da301d33721c ]

of_find_compatible_node() returns a node pointer with refcount
incremented, we should use of_node_put() on it when done.
Add missing of_node_put() to avoid refcount leak.

Fixes: eac1e731b59e ("powerpc/xive: guest exploitation of the XIVE interrupt controller")
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Reviewed-by: Cédric Le Goater <clg@kaod.org>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20220512090535.33397-1-linmq006@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/sysdev/xive/spapr.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/sysdev/xive/spapr.c b/arch/powerpc/sysdev/xive/spapr.c
index 29456c255f9f..503f544d28e2 100644
--- a/arch/powerpc/sysdev/xive/spapr.c
+++ b/arch/powerpc/sysdev/xive/spapr.c
@@ -830,12 +830,12 @@ bool __init xive_spapr_init(void)
 	/* Resource 1 is the OS ring TIMA */
 	if (of_address_to_resource(np, 1, &r)) {
 		pr_err("Failed to get thread mgmnt area resource\n");
-		return false;
+		goto err_put;
 	}
 	tima = ioremap(r.start, resource_size(&r));
 	if (!tima) {
 		pr_err("Failed to map thread mgmnt area\n");
-		return false;
+		goto err_put;
 	}
 
 	if (!xive_get_max_prio(&max_prio))
@@ -871,6 +871,7 @@ bool __init xive_spapr_init(void)
 	if (!xive_core_init(np, &xive_spapr_ops, tima, TM_QW1_OS, max_prio))
 		goto err_mem_free;
 
+	of_node_put(np);
 	pr_info("Using %dkB queues\n", 1 << (xive_queue_shift - 10));
 	return true;
 
@@ -878,6 +879,8 @@ bool __init xive_spapr_init(void)
 	xive_irq_bitmap_remove_all();
 err_unmap:
 	iounmap(tima);
+err_put:
+	of_node_put(np);
 	return false;
 }
 
-- 
2.35.1



