Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0834C53A893
	for <lists+stable@lfdr.de>; Wed,  1 Jun 2022 16:11:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344470AbiFAOLC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Jun 2022 10:11:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354710AbiFAOJd (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Jun 2022 10:09:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C17941163;
        Wed,  1 Jun 2022 07:00:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5D619615E9;
        Wed,  1 Jun 2022 14:00:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01213C385B8;
        Wed,  1 Jun 2022 14:00:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654092041;
        bh=zlr3C4xgJD135dQdTWBXK1U0qwJZQAP7U25NcO+I5cQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E/1vR3c3a4J+AjAzcChd3EQjtQQ94Kav4fTG7y5pSA2a+t/Y5OUJKjKAvZzzI4HiI
         byrMrVVROe7PvDjovYttJTzZjMyv5mUKiHZOvF3ZyRD8vxJrZ9VKITzrsD1f4b42RT
         MJ8tlCwBDekGKSqxCQMz5A0yQtFp0HdJMCv5f2bujg7xyhLixkEouq+8Bhun5KW0Il
         bQmUsLlBOQk1OBZaf5JQKpJFf2ZezTbfOy/xRUT79IomZBXRDf4NbK0uU1f08DT/PZ
         Fe7D75C7BRwbdFBcO27seBicNGNc07INRJZplkA4oNf1zxYkmuMhSyXfS6xSsmXXtz
         uVrN5LfmlTfwg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Peng Wu <wupeng58@huawei.com>, Wei Xu <xuwei5@hisilicon.com>,
        Sasha Levin <sashal@kernel.org>, linux@armlinux.org.uk,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 4.14 08/14] ARM: hisi: Add missing of_node_put after of_find_compatible_node
Date:   Wed,  1 Jun 2022 10:00:21 -0400
Message-Id: <20220601140027.2005280-8-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220601140027.2005280-1-sashal@kernel.org>
References: <20220601140027.2005280-1-sashal@kernel.org>
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

