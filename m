Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB58759479B
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 02:00:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240957AbiHOXH5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 19:07:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353119AbiHOXHN (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 19:07:13 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39F9E1423D3;
        Mon, 15 Aug 2022 12:59:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A23D4B80EAD;
        Mon, 15 Aug 2022 19:59:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0BA7C433C1;
        Mon, 15 Aug 2022 19:59:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660593553;
        bh=caZpDJ7aSRMBdaIMuyVsTOuU9AM6FJlvGJPQMJVwMhk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AJQiUbvt4ZAE+dDuDN+/dd6LdGYFE3uTCpUVq+1fncz58kqTrWDxYYwsi/w1cipPY
         kUlBcoGKNcEVm3g9xu5Hjcoyc1+wNyGmggYe9Buds8mwfy4UaDRhF+Gkq7+sBTpmrm
         xrrtkBlAJ9J8wzhzB+F8u8+40JJAFPPGYN93oZXw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Liang He <windhl@126.com>,
        Atish Patra <atishp@rivosinc.com>,
        Andrew Jones <ajones@ventanamicro.com>,
        Will Deacon <will@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0287/1157] perf: RISC-V: Add of_node_put() when breaking out of for_each_of_cpu_node()
Date:   Mon, 15 Aug 2022 19:54:03 +0200
Message-Id: <20220815180451.099813403@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Liang He <windhl@126.com>

[ Upstream commit 491f10d08fdae10a177edf6af4f43b83b293114b ]

In pmu_sbi_setup_irqs(), we should call of_node_put() for the 'cpu'
when breaking out of for_each_of_cput_node() as its refcount will
be automatically increased and decreased during the iteration.

Fixes: 4905ec2fb7e6 ("RISC-V: Add sscofpmf extension support")
Signed-off-by: Liang He <windhl@126.com>
Reviewed-by: Atish Patra <atishp@rivosinc.com>
Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
Link: https://lore.kernel.org/r/20220715130330.443363-1-windhl@126.com
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/perf/riscv_pmu_sbi.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/perf/riscv_pmu_sbi.c b/drivers/perf/riscv_pmu_sbi.c
index bae614c73b14..231d86d3949c 100644
--- a/drivers/perf/riscv_pmu_sbi.c
+++ b/drivers/perf/riscv_pmu_sbi.c
@@ -682,12 +682,15 @@ static int pmu_sbi_setup_irqs(struct riscv_pmu *pmu, struct platform_device *pde
 		child = of_get_compatible_child(cpu, "riscv,cpu-intc");
 		if (!child) {
 			pr_err("Failed to find INTC node\n");
+			of_node_put(cpu);
 			return -ENODEV;
 		}
 		domain = irq_find_host(child);
 		of_node_put(child);
-		if (domain)
+		if (domain) {
+			of_node_put(cpu);
 			break;
+		}
 	}
 	if (!domain) {
 		pr_err("Failed to find INTC IRQ root domain\n");
-- 
2.35.1



