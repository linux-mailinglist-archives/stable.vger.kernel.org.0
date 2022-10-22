Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B542460891D
	for <lists+stable@lfdr.de>; Sat, 22 Oct 2022 10:31:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233586AbiJVIbT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Oct 2022 04:31:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234013AbiJVI3M (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Oct 2022 04:29:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 920C12E2BAD;
        Sat, 22 Oct 2022 01:01:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4531F60AFA;
        Sat, 22 Oct 2022 08:00:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27020C433D7;
        Sat, 22 Oct 2022 08:00:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666425607;
        bh=Xz/JYnNX+bv4d5sNBNrD5dHf4bfzzM5L7MEjHHLxJTw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=H6rL+InRTUElvIlZItognaPFHJRAN5sEq1ClqqFIvaWofsbyNObsG7vWoQNRNxvtb
         znRUHfZCWU5+m8gxTYNp0qCLsA6Yeg/sSs9/YD7fsZrxl8dw8l6/j/eXUY5fN09OHy
         qrrAg1n9rkLAqU+midzCPz5cj86VxZLsULn38WXs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, linux-riscv@lists.infradead.org,
        mingo@redhat.com, paul.walmsley@sifive.com, palmer@dabbelt.com,
        aou@eecs.berkeley.edu, zanussi@kernel.org, liaochang1@huawei.com,
        chris.zjh@huawei.com, Yipeng Zou <zouyipeng@huawei.com>,
        "Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
        "Steven Rostedt (Google)" <rostedt@goodmis.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 526/717] tracing: kprobe: Make gen test module work in arm and riscv
Date:   Sat, 22 Oct 2022 09:26:45 +0200
Message-Id: <20221022072521.582016938@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221022072415.034382448@linuxfoundation.org>
References: <20221022072415.034382448@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yipeng Zou <zouyipeng@huawei.com>

[ Upstream commit d8ef45d66c01425ff748e13ef7dd1da7a91cc93c ]

For now, this selftest module can only work in x86 because of the
kprobe cmd was fixed use of x86 registers.
This patch adapted to register names under arm and riscv, So that
this module can be worked on those platform.

Link: https://lkml.kernel.org/r/20220919125629.238242-3-zouyipeng@huawei.com

Cc: <linux-riscv@lists.infradead.org>
Cc: <mingo@redhat.com>
Cc: <paul.walmsley@sifive.com>
Cc: <palmer@dabbelt.com>
Cc: <aou@eecs.berkeley.edu>
Cc: <zanussi@kernel.org>
Cc: <liaochang1@huawei.com>
Cc: <chris.zjh@huawei.com>
Fixes: 64836248dda2 ("tracing: Add kprobe event command generation test module")
Signed-off-by: Yipeng Zou <zouyipeng@huawei.com>
Acked-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/kprobe_event_gen_test.c | 47 +++++++++++++++++++++++++---
 1 file changed, 43 insertions(+), 4 deletions(-)

diff --git a/kernel/trace/kprobe_event_gen_test.c b/kernel/trace/kprobe_event_gen_test.c
index e023154be0f8..80e04a1e1977 100644
--- a/kernel/trace/kprobe_event_gen_test.c
+++ b/kernel/trace/kprobe_event_gen_test.c
@@ -35,6 +35,45 @@
 static struct trace_event_file *gen_kprobe_test;
 static struct trace_event_file *gen_kretprobe_test;
 
+#define KPROBE_GEN_TEST_FUNC	"do_sys_open"
+
+/* X86 */
+#if defined(CONFIG_X86_64) || defined(CONFIG_X86_32)
+#define KPROBE_GEN_TEST_ARG0	"dfd=%ax"
+#define KPROBE_GEN_TEST_ARG1	"filename=%dx"
+#define KPROBE_GEN_TEST_ARG2	"flags=%cx"
+#define KPROBE_GEN_TEST_ARG3	"mode=+4($stack)"
+
+/* ARM64 */
+#elif defined(CONFIG_ARM64)
+#define KPROBE_GEN_TEST_ARG0	"dfd=%x0"
+#define KPROBE_GEN_TEST_ARG1	"filename=%x1"
+#define KPROBE_GEN_TEST_ARG2	"flags=%x2"
+#define KPROBE_GEN_TEST_ARG3	"mode=%x3"
+
+/* ARM */
+#elif defined(CONFIG_ARM)
+#define KPROBE_GEN_TEST_ARG0	"dfd=%r0"
+#define KPROBE_GEN_TEST_ARG1	"filename=%r1"
+#define KPROBE_GEN_TEST_ARG2	"flags=%r2"
+#define KPROBE_GEN_TEST_ARG3	"mode=%r3"
+
+/* RISCV */
+#elif defined(CONFIG_RISCV)
+#define KPROBE_GEN_TEST_ARG0	"dfd=%a0"
+#define KPROBE_GEN_TEST_ARG1	"filename=%a1"
+#define KPROBE_GEN_TEST_ARG2	"flags=%a2"
+#define KPROBE_GEN_TEST_ARG3	"mode=%a3"
+
+/* others */
+#else
+#define KPROBE_GEN_TEST_ARG0	NULL
+#define KPROBE_GEN_TEST_ARG1	NULL
+#define KPROBE_GEN_TEST_ARG2	NULL
+#define KPROBE_GEN_TEST_ARG3	NULL
+#endif
+
+
 /*
  * Test to make sure we can create a kprobe event, then add more
  * fields.
@@ -58,14 +97,14 @@ static int __init test_gen_kprobe_cmd(void)
 	 * fields.
 	 */
 	ret = kprobe_event_gen_cmd_start(&cmd, "gen_kprobe_test",
-					 "do_sys_open",
-					 "dfd=%ax", "filename=%dx");
+					 KPROBE_GEN_TEST_FUNC,
+					 KPROBE_GEN_TEST_ARG0, KPROBE_GEN_TEST_ARG1);
 	if (ret)
 		goto free;
 
 	/* Use kprobe_event_add_fields to add the rest of the fields */
 
-	ret = kprobe_event_add_fields(&cmd, "flags=%cx", "mode=+4($stack)");
+	ret = kprobe_event_add_fields(&cmd, KPROBE_GEN_TEST_ARG2, KPROBE_GEN_TEST_ARG3);
 	if (ret)
 		goto free;
 
@@ -128,7 +167,7 @@ static int __init test_gen_kretprobe_cmd(void)
 	 * Define the kretprobe event.
 	 */
 	ret = kretprobe_event_gen_cmd_start(&cmd, "gen_kretprobe_test",
-					    "do_sys_open",
+					    KPROBE_GEN_TEST_FUNC,
 					    "$retval");
 	if (ret)
 		goto free;
-- 
2.35.1



