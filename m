Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9FC7E64EBB0
	for <lists+stable@lfdr.de>; Fri, 16 Dec 2022 13:57:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230267AbiLPM5W (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Dec 2022 07:57:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230273AbiLPM5T (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 16 Dec 2022 07:57:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 331455289D;
        Fri, 16 Dec 2022 04:57:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CDB24620D9;
        Fri, 16 Dec 2022 12:57:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6981C433D2;
        Fri, 16 Dec 2022 12:57:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671195438;
        bh=YheSUB8obxKxu9TjYr17jXNS47E36g8HmCLUCLFUQ3E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WrJRC+Rr+O2tIMb+dni75RCzYbVz2X5LpwNFl4Y1denKHU0TI9zrltaLuM40sCqN/
         kKHU8MDogR0o5SR8QJqf4C+jbRSexdyD5tdydTNuefaDl2B1MjDmo4XpXRSwoEA66D
         v+tZj1TsQTRGOVO/O5wKYYWKJU/ZRdvV0WkNANEECCVQE8wWjZwQGg1UGWeN/7EHQB
         QcStawTqfvicft57k4lvTTqhFe1UaHifjSXxdWYT30c4JReLij34gfJ+ktO1IxD25z
         gMAlGBBWiMcm6ADwZitFrhPz/8O3xUb61QKsSLZJcU7uiJMlflCqpEJ/f9gbnnSuoV
         MHRqxnzeerQCg==
From:   Jiri Olsa <jolsa@kernel.org>
To:     stable@vger.kernel.org
Cc:     Song Liu <song@kernel.org>, bpf@vger.kernel.org,
        Martynas Pumputis <m@lambda.lt>
Subject: [PATCH stable 6.0 5/8] selftests/bpf: Add load_kallsyms_refresh function
Date:   Fri, 16 Dec 2022 13:56:25 +0100
Message-Id: <20221216125628.1622505-6-jolsa@kernel.org>
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

commit 10705b2b7a8e4eb46ab5bf1b9ee354cb9a929428 upstream.

Adding load_kallsyms_refresh function to re-read symbols from
/proc/kallsyms file.

This will be needed to get proper functions addresses from
bpf_testmod.ko module, which is loaded/unloaded several times
during the tests run, so symbols might be already old when
we need to use them.

Acked-by: Song Liu <song@kernel.org>
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
Link: https://lore.kernel.org/r/20221025134148.3300700-6-jolsa@kernel.org
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
---
 tools/testing/selftests/bpf/trace_helpers.c | 20 +++++++++++++-------
 tools/testing/selftests/bpf/trace_helpers.h |  2 ++
 2 files changed, 15 insertions(+), 7 deletions(-)

diff --git a/tools/testing/selftests/bpf/trace_helpers.c b/tools/testing/selftests/bpf/trace_helpers.c
index 9c4be2cdb21a..09a16a77bae4 100644
--- a/tools/testing/selftests/bpf/trace_helpers.c
+++ b/tools/testing/selftests/bpf/trace_helpers.c
@@ -23,7 +23,7 @@ static int ksym_cmp(const void *p1, const void *p2)
 	return ((struct ksym *)p1)->addr - ((struct ksym *)p2)->addr;
 }
 
-int load_kallsyms(void)
+int load_kallsyms_refresh(void)
 {
 	FILE *f;
 	char func[256], buf[256];
@@ -31,12 +31,7 @@ int load_kallsyms(void)
 	void *addr;
 	int i = 0;
 
-	/*
-	 * This is called/used from multiplace places,
-	 * load symbols just once.
-	 */
-	if (sym_cnt)
-		return 0;
+	sym_cnt = 0;
 
 	f = fopen("/proc/kallsyms", "r");
 	if (!f)
@@ -57,6 +52,17 @@ int load_kallsyms(void)
 	return 0;
 }
 
+int load_kallsyms(void)
+{
+	/*
+	 * This is called/used from multiplace places,
+	 * load symbols just once.
+	 */
+	if (sym_cnt)
+		return 0;
+	return load_kallsyms_refresh();
+}
+
 struct ksym *ksym_search(long key)
 {
 	int start = 0, end = sym_cnt;
diff --git a/tools/testing/selftests/bpf/trace_helpers.h b/tools/testing/selftests/bpf/trace_helpers.h
index 238a9c98cde2..53efde0e2998 100644
--- a/tools/testing/selftests/bpf/trace_helpers.h
+++ b/tools/testing/selftests/bpf/trace_helpers.h
@@ -10,6 +10,8 @@ struct ksym {
 };
 
 int load_kallsyms(void);
+int load_kallsyms_refresh(void);
+
 struct ksym *ksym_search(long key);
 long ksym_get_addr(const char *name);
 
-- 
2.38.1

