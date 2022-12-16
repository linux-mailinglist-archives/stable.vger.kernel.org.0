Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D463B64EBAA
	for <lists+stable@lfdr.de>; Fri, 16 Dec 2022 13:56:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230251AbiLPM4z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Dec 2022 07:56:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229730AbiLPM4y (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Dec 2022 07:56:54 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5E885214F;
        Fri, 16 Dec 2022 04:56:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 40F4AB81D68;
        Fri, 16 Dec 2022 12:56:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68C97C433EF;
        Fri, 16 Dec 2022 12:56:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671195410;
        bh=C6FfR4E3jMSA/dzbt5H0sYXAfQXYM1v3Q9Im/zptGSk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dt6/ohy7UAOi0CXy12ViHP43HIOp0QkDz3ZJi2BppfoeVhikS5O6NMBJISAK/uje0
         4e4q7Au/5fWMpVHxda/BsrYBN46LcnghwzsnB8PBJhNs/2VS0D1ujIMbhaYzu5Kd2U
         PgmGo/0un50b3sMUZexQPiO/hl2qsUQWnYrxIZn5HiQI9KNqP8pqS3j1ehGBoDedxL
         JhNO/BGH7IAIw6DRZi/HIlF8kHGoCo+1gN8mZA7hkml2rmuNuB4DYUI7JyII6Gk+O5
         NEkV3SKSHOdshj1CxlYk7c1oDN10dfFm9HT69g44GmSCyfMr0kSVUMAT/5H1Znq/eB
         ghu9+PYHDOHbQ==
From:   Jiri Olsa <jolsa@kernel.org>
To:     stable@vger.kernel.org
Cc:     Martynas Pumputis <m@lambda.lt>, Song Liu <song@kernel.org>,
        bpf@vger.kernel.org
Subject: [PATCH stable 6.0 2/8] ftrace: Add support to resolve module symbols in ftrace_lookup_symbols
Date:   Fri, 16 Dec 2022 13:56:22 +0100
Message-Id: <20221216125628.1622505-3-jolsa@kernel.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221216125628.1622505-1-jolsa@kernel.org>
References: <20221216125628.1622505-1-jolsa@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 3640bf8584f4ab0f5eed6285f09213954acd8b62 upstream.

Currently ftrace_lookup_symbols iterates only over core symbols,
adding module_kallsyms_on_each_symbol call to check on modules
symbols as well.

Also removing 'args.found == args.cnt' condition, because it's
already checked in kallsyms_callback function.

Also removing 'err < 0' check, because both *kallsyms_on_each_symbol
functions do not return error.

Reported-by: Martynas Pumputis <m@lambda.lt>
Acked-by: Song Liu <song@kernel.org>
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
Link: https://lore.kernel.org/r/20221025134148.3300700-3-jolsa@kernel.org
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
---
 kernel/trace/ftrace.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 9e6231f4a04f..768306ec3c94 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -8261,6 +8261,10 @@ struct kallsyms_data {
 	size_t found;
 };
 
+/* This function gets called for all kernel and module symbols
+ * and returns 1 in case we resolved all the requested symbols,
+ * 0 otherwise.
+ */
 static int kallsyms_callback(void *data, const char *name,
 			     struct module *mod, unsigned long addr)
 {
@@ -8304,17 +8308,19 @@ static int kallsyms_callback(void *data, const char *name,
 int ftrace_lookup_symbols(const char **sorted_syms, size_t cnt, unsigned long *addrs)
 {
 	struct kallsyms_data args;
-	int err;
+	int found_all;
 
 	memset(addrs, 0, sizeof(*addrs) * cnt);
 	args.addrs = addrs;
 	args.syms = sorted_syms;
 	args.cnt = cnt;
 	args.found = 0;
-	err = kallsyms_on_each_symbol(kallsyms_callback, &args);
-	if (err < 0)
-		return err;
-	return args.found == args.cnt ? 0 : -ESRCH;
+
+	found_all = kallsyms_on_each_symbol(kallsyms_callback, &args);
+	if (found_all)
+		return 0;
+	found_all = module_kallsyms_on_each_symbol(kallsyms_callback, &args);
+	return found_all ? 0 : -ESRCH;
 }
 
 #ifdef CONFIG_SYSCTL
-- 
2.38.1

