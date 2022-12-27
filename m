Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65D67656F4B
	for <lists+stable@lfdr.de>; Tue, 27 Dec 2022 21:40:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232735AbiL0Ukn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Dec 2022 15:40:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48610 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232744AbiL0Uj0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 27 Dec 2022 15:39:26 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A36D0FCC0;
        Tue, 27 Dec 2022 12:35:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F306A6123C;
        Tue, 27 Dec 2022 20:35:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AE7BC433F0;
        Tue, 27 Dec 2022 20:35:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672173316;
        bh=NGon96pG4Ksto5VuCo0CIA3vlpxsif3GHRvzH7/8CpM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=m/2YnptK3mpihm1Z7jWY5l/J+FzpWec+TxEPkDyZk8iTsicFw42ORau1FbM2JDJo5
         TEqWxa5FKd9z8CMN0ShVCLghmh/U2TJVUrve9OYvrm1peGfD00zmN28jkowH+Lafb5
         l5XAJU2fdbzC14rl0vfV5/Oiu7rNU/Op22kuH+k/ooBOLz5zFMKheF42eQ/Qy/Rpr1
         0vkIvBNkcwh7LpfvY6W3ZnZECAbPhVxrPcZM2xoew7magF8TmbUr7wvvEgu1xrS25f
         IcLTTBvw1gfRP2DmpdniIPVK27PnNfMt1M0qR3Pu0l8JhXQB3THwkOcYQuT3MpfuIC
         UjdfA4xV03SPA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Christophe Leroy <christophe.leroy@csgroup.eu>,
        "Naveen N . Rao" <naveen.n.rao@linux.vnet.ibm.com>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.10 2/7] objtool: Fix SEGFAULT
Date:   Tue, 27 Dec 2022 15:35:05 -0500
Message-Id: <20221227203512.1214527-2-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221227203512.1214527-1-sashal@kernel.org>
References: <20221227203512.1214527-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe Leroy <christophe.leroy@csgroup.eu>

[ Upstream commit efb11fdb3e1a9f694fa12b70b21e69e55ec59c36 ]

find_insn() will return NULL in case of failure. Check insn in order
to avoid a kernel Oops for NULL pointer dereference.

Tested-by: Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
Reviewed-by: Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
Acked-by: Josh Poimboeuf <jpoimboe@kernel.org>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20221114175754.1131267-9-sv@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/objtool/check.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/objtool/check.c b/tools/objtool/check.c
index ea80b29b9913..654ffb51e1dd 100644
--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -196,7 +196,7 @@ static bool __dead_end_function(struct objtool_file *file, struct symbol *func,
 		return false;
 
 	insn = find_insn(file, func->sec, func->offset);
-	if (!insn->func)
+	if (!insn || !insn->func)
 		return false;
 
 	func_for_each_insn(file, func, insn) {
-- 
2.35.1

