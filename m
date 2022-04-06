Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 829F84F66D7
	for <lists+stable@lfdr.de>; Wed,  6 Apr 2022 19:19:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238357AbiDFRLZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Apr 2022 13:11:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238594AbiDFRK6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Apr 2022 13:10:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A93E1FAA22;
        Wed,  6 Apr 2022 07:32:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DD3DD61A35;
        Wed,  6 Apr 2022 14:32:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D74BC385A3;
        Wed,  6 Apr 2022 14:32:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649255561;
        bh=Rhb8TyRe2vNjt7n+l907Rhf1+1/HlhpR5h4bXpZTsMo=;
        h=From:To:Cc:Subject:Date:From;
        b=RQxFqh0rxmr6J9/CaU/1Cjum7EMd9XJWxItIpVqY+AzgkuLO9Yca1Ju0vdECnq9lG
         tcT0UtA++x/p6FgORIn2U3nekai3FtMhDqkpBYztoJdGXL3V6uFOIzB5CiB66Ohp1r
         3kWEyPvVoYN168XzQZ1JLkdM9Me2zmc4j4TY52QqQud4IT4xNwNQy059v4ZYrFNjMu
         jj2WGePORhQoCQueTisSKF8xdrGfI4e12zx+q8+i5Gqw5J3o9w9JcOKWCU3m+eFkBt
         7zycGrplLbySgtIDn+/CUMWPoWLrb4+GfVuqGEpto8CahPrZ/fh6vEI+sWwCzw8WIb
         tjr72ylikca4w==
From:   guoren@kernel.org
To:     guoren@kernel.org, arnd@arndb.de
Cc:     linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-csky@vger.kernel.org, Guo Ren <guoren@linux.alibaba.com>,
        Masami Hiramatsu <mhiramat@kernel.org>, stable@vger.kernel.org
Subject: [PATCH V3] csky: patch_text: Fixup last cpu should be master
Date:   Wed,  6 Apr 2022 22:32:27 +0800
Message-Id: <20220406143227.731004-1-guoren@kernel.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
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

From: Guo Ren <guoren@linux.alibaba.com>

These patch_text implementations are using stop_machine_cpuslocked
infrastructure with atomic cpu_count. The original idea: When the
master CPU patch_text, the others should wait for it. But current
implementation is using the first CPU as master, which couldn't
guarantee the remaining CPUs are waiting. This patch changes the
last CPU as the master to solve the potential risk.

Signed-off-by: Guo Ren <guoren@linux.alibaba.com>
Signed-off-by: Guo Ren <guoren@kernel.org>
Reviewed-by: Masami Hiramatsu <mhiramat@kernel.org>
Cc: <stable@vger.kernel.org>
---
 arch/csky/kernel/probes/kprobes.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/csky/kernel/probes/kprobes.c b/arch/csky/kernel/probes/kprobes.c
index 42920f25e73c..34ba684d5962 100644
--- a/arch/csky/kernel/probes/kprobes.c
+++ b/arch/csky/kernel/probes/kprobes.c
@@ -30,7 +30,7 @@ static int __kprobes patch_text_cb(void *priv)
 	struct csky_insn_patch *param = priv;
 	unsigned int addr = (unsigned int)param->addr;
 
-	if (atomic_inc_return(&param->cpu_count) == 1) {
+	if (atomic_inc_return(&param->cpu_count) == num_online_cpus()) {
 		*(u16 *) addr = cpu_to_le16(param->opcode);
 		dcache_wb_range(addr, addr + 2);
 		atomic_inc(&param->cpu_count);
-- 
2.25.1

