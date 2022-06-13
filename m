Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D74254927D
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:30:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242964AbiFMKly (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 06:41:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345764AbiFMKkm (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 06:40:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6536C20187;
        Mon, 13 Jun 2022 03:23:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 024ED60DC4;
        Mon, 13 Jun 2022 10:23:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 126F3C34114;
        Mon, 13 Jun 2022 10:23:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655115817;
        bh=zlr3C4xgJD135dQdTWBXK1U0qwJZQAP7U25NcO+I5cQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nId1t7QeADdvm+m5ZA8BTgFDT9JNHBzc8YeUU0vuPP3hOrNcXmGpIw65VfGLedl+v
         r6R24h4i5a4hfy0t3Vcv7WBKhAC+emU2ZdHadw2vyBHkoEut3e3H9DDb471K5qXGyS
         ByOyw4PCImx7lpR2svt3sK5hpSMwwpogc4oDiXSE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peng Wu <wupeng58@huawei.com>,
        Wei Xu <xuwei5@hisilicon.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 041/218] ARM: hisi: Add missing of_node_put after of_find_compatible_node
Date:   Mon, 13 Jun 2022 12:08:19 +0200
Message-Id: <20220613094918.093365439@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094908.257446132@linuxfoundation.org>
References: <20220613094908.257446132@linuxfoundation.org>
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

From: Peng Wu <wupeng58@huawei.com>

[ Upstream commit 9bc72e47d4630d58a840a66a869c56b29554cfe4 ]

of_find_compatible_node  will increment the refcount of the returned
device_node. Calling of_node_put() to avoid the refcount leak

Signed-off-by: Peng Wu <wupeng58@huawei.com>
Signed-off-by: Wei Xu <xuwei5@hisilicon.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/mach-hisi/platsmp.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm/mach-hisi/platsmp.c b/arch/arm/mach-hisi/platsmp.c
index da5689ababf7..d7fbfb6d293d 100644
--- a/arch/arm/mach-hisi/platsmp.c
+++ b/arch/arm/mach-hisi/platsmp.c
@@ -70,14 +70,17 @@ static void __init hi3xxx_smp_prepare_cpus(unsigned int max_cpus)
 		}
 		ctrl_base = of_iomap(np, 0);
 		if (!ctrl_base) {
+			of_node_put(np);
 			pr_err("failed to map address\n");
 			return;
 		}
 		if (of_property_read_u32(np, "smp-offset", &offset) < 0) {
+			of_node_put(np);
 			pr_err("failed to find smp-offset property\n");
 			return;
 		}
 		ctrl_base += offset;
+		of_node_put(np);
 	}
 }
 
@@ -163,6 +166,7 @@ static int hip01_boot_secondary(unsigned int cpu, struct task_struct *idle)
 	if (WARN_ON(!node))
 		return -1;
 	ctrl_base = of_iomap(node, 0);
+	of_node_put(node);
 
 	/* set the secondary core boot from DDR */
 	remap_reg_value = readl_relaxed(ctrl_base + REG_SC_CTRL);
-- 
2.35.1



