Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57B004F65F1
	for <lists+stable@lfdr.de>; Wed,  6 Apr 2022 18:52:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237980AbiDFQyF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Apr 2022 12:54:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238133AbiDFQxF (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Apr 2022 12:53:05 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 014DF21799B;
        Wed,  6 Apr 2022 07:17:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C3B44B82426;
        Wed,  6 Apr 2022 14:17:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE8C6C385A3;
        Wed,  6 Apr 2022 14:17:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649254625;
        bh=OMfx41/031A0MP+RHm+KFwlRg5XT4Op6fvW1GZ75ZuQ=;
        h=From:To:Cc:Subject:Date:From;
        b=ie+v5zV3XbfY5P59UHcq+VjkI8jYwX+M798YCErKW4mWwv0QnMTzYY0jffAZsFU3G
         NlvREmST3Mo+7tk9Vp8tFVLhFCiuSyJIkSpUxz6C4lQp7KkFTVq4pylTTO7CbyOB8b
         qQtOHKG+zvk0IRBtTWkeqALBoUjyzccmtfUr63v+sODqL7mIXCl97wfuhgbOegKmjx
         SrKL4NSIwcwdfxICNvyal+YIFKmN+GtAtnmrPXerskHsKWm1LUkZ7REub0s/5tBAkg
         paiu7LCYgtynayD8d832/BWLmBKdP9cKgoHq5Bdon9dXOufgzpTLpqeIsn36OZqjYH
         /rQKYtCcfkKVg==
From:   guoren@kernel.org
To:     guoren@kernel.org, arnd@arndb.de, palmer@dabbelt.com
Cc:     linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-riscv@lists.infradead.org,
        Guo Ren <guoren@linux.alibaba.com>,
        Palmer Dabbelt <palmer@rivosinc.com>,
        Masami Hiramatsu <mhiramat@kernel.org>, stable@vger.kernel.org
Subject: [PATCH V3] riscv: patch_text: Fixup last cpu should be master
Date:   Wed,  6 Apr 2022 22:16:49 +0800
Message-Id: <20220406141649.728971-1-guoren@kernel.org>
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
Acked-by: Palmer Dabbelt <palmer@rivosinc.com>
Reviewed-by: Masami Hiramatsu <mhiramat@kernel.org>
Cc: <stable@vger.kernel.org>
---
 arch/riscv/kernel/patch.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/riscv/kernel/patch.c b/arch/riscv/kernel/patch.c
index 0b552873a577..765004b60513 100644
--- a/arch/riscv/kernel/patch.c
+++ b/arch/riscv/kernel/patch.c
@@ -104,7 +104,7 @@ static int patch_text_cb(void *data)
 	struct patch_insn *patch = data;
 	int ret = 0;
 
-	if (atomic_inc_return(&patch->cpu_count) == 1) {
+	if (atomic_inc_return(&patch->cpu_count) == num_online_cpus()) {
 		ret =
 		    patch_text_nosync(patch->addr, &patch->insn,
 					    GET_INSN_LENGTH(patch->insn));
-- 
2.25.1

