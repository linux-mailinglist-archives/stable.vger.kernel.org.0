Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA12C656EC9
	for <lists+stable@lfdr.de>; Tue, 27 Dec 2022 21:34:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232190AbiL0UeK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Dec 2022 15:34:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232262AbiL0UdW (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 27 Dec 2022 15:33:22 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 856FCD108;
        Tue, 27 Dec 2022 12:33:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 30DE5B81168;
        Tue, 27 Dec 2022 20:33:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31CB1C433F0;
        Tue, 27 Dec 2022 20:33:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672173199;
        bh=3xOSEwOyxwJ+hft19cSXmSxTG/2pV8h7lk1oDOwu+c0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=d95tDLpL8euCovGvqccDnp+d2bnOWIOJ87t35KmJN1JXXl7QHCYUEGmqpp1ctT09u
         GS4Nd3mP4kL1X53c7V/2FFlwM9XSIgxRcomlc732hno6IWQs1rtnG81BJNOYarWc3a
         /17l2Ks4WFc0RBK5Quu+9tBHGGEjmrdJHVlwr4QhIg19urliM2dSrdVDcsSFCZx8+C
         MWKm+8N8qCkgaYX+pJLoDQrFgBoM72o7T76l44/F6bVQikgrvRlbp0SFMf/39T7Guh
         npwsTw1FpV/ge6raNY22m8OaPpQJ6rlHbg+7nCL6Horet7semNdqFv0Q/L+euX1Mfr
         RnKmBHBCYYw5Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Christophe Leroy <christophe.leroy@csgroup.eu>,
        "Naveen N . Rao" <naveen.n.rao@linux.vnet.ibm.com>,
        Josh Poimboeuf <jpoimboe@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 6.1 19/28] objtool: Fix SEGFAULT
Date:   Tue, 27 Dec 2022 15:32:40 -0500
Message-Id: <20221227203249.1213526-19-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221227203249.1213526-1-sashal@kernel.org>
References: <20221227203249.1213526-1-sashal@kernel.org>
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
index 43ec14c29a60..8427af808221 100644
--- a/tools/objtool/check.c
+++ b/tools/objtool/check.c
@@ -207,7 +207,7 @@ static bool __dead_end_function(struct objtool_file *file, struct symbol *func,
 		return false;
 
 	insn = find_insn(file, func->sec, func->offset);
-	if (!insn->func)
+	if (!insn || !insn->func)
 		return false;
 
 	func_for_each_insn(file, func, insn) {
-- 
2.35.1

