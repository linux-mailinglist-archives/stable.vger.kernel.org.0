Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A13A4F77A0
	for <lists+stable@lfdr.de>; Thu,  7 Apr 2022 09:34:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241842AbiDGHg0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Apr 2022 03:36:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241863AbiDGHgQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 7 Apr 2022 03:36:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB968194FF3;
        Thu,  7 Apr 2022 00:34:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8BD9CB826C7;
        Thu,  7 Apr 2022 07:34:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A285C385A4;
        Thu,  7 Apr 2022 07:34:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649316855;
        bh=R2FPA9lWSXRgAzEvdehN22kFHU9pjAW3rQXXGDs7cDQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OJlKMZ2aKAzw5+LeIolJB5pwRD23zC0v1DrROL+aQ2kRGcMIIsMaieRXUWJ7LPfML
         nyQDGC2U5D8LolVa+curnmQgS1G1eTqJU6hy8o/PK6TXWuqokCFmrNHffffMrLMcA6
         eoih0F/3+r8HL51n2Y7mCAaPGw3hQ8FZazxhD6WzjaSFyku4Tu+I6JekSksdCexMLf
         9i77RxagVWEuZ+JIeMVfyempj2xEj4HBmmTL0UVXgD1ZAMhk1YTlOJcfiQVibNXquT
         I877fj9qjzdWkWW46gJ59BkzmgKvL4eg2L9Nj5v0EgdHTWjw9L4HN2Dni12GE86edn
         Y8htB1f4ONb3Q==
From:   guoren@kernel.org
To:     guoren@kernel.org, arnd@arndb.de, gregkh@linuxfoundation.org
Cc:     linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-csky@vger.kernel.org, linux-xtensa@linux-xtensa.org,
        linux-riscv@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org,
        Guo Ren <guoren@linux.alibaba.com>,
        Max Filippov <jcmvbkbc@gmail.com>,
        Masami Hiramatsu <mhiramat@kernel.org>, stable@vger.kernel.org
Subject: [PATCH V4 3/4] xtensa: patch_text: Fixup last cpu should be master
Date:   Thu,  7 Apr 2022 15:33:22 +0800
Message-Id: <20220407073323.743224-4-guoren@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220407073323.743224-1-guoren@kernel.org>
References: <20220407073323.743224-1-guoren@kernel.org>
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

Fixes: 64711f9a47d4 ("xtensa: implement jump_label support")
Signed-off-by: Guo Ren <guoren@linux.alibaba.com>
Signed-off-by: Guo Ren <guoren@kernel.org>
Reviewed-by: Max Filippov <jcmvbkbc@gmail.com>
Reviewed-by: Masami Hiramatsu <mhiramat@kernel.org>
Cc: <stable@vger.kernel.org>
---
 arch/xtensa/kernel/jump_label.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/xtensa/kernel/jump_label.c b/arch/xtensa/kernel/jump_label.c
index 0dde21e0d3de..ad1841cecdfb 100644
--- a/arch/xtensa/kernel/jump_label.c
+++ b/arch/xtensa/kernel/jump_label.c
@@ -40,7 +40,7 @@ static int patch_text_stop_machine(void *data)
 {
 	struct patch *patch = data;
 
-	if (atomic_inc_return(&patch->cpu_count) == 1) {
+	if (atomic_inc_return(&patch->cpu_count) == num_online_cpus()) {
 		local_patch_text(patch->addr, patch->data, patch->sz);
 		atomic_inc(&patch->cpu_count);
 	} else {
-- 
2.25.1

