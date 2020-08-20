Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E77324B296
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 11:33:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728409AbgHTJdX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 05:33:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:43340 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728244AbgHTJb1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 05:31:27 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 09011207FB;
        Thu, 20 Aug 2020 09:31:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597915886;
        bh=9I2S2HgMrgai4q7C6nc9rocRMFt/8KsGXnWPakbYF0c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mwazPfjODAr//sTmK9qQWFYHQezPcKFdZ5YyysOksaCaofD2QiWl/EWcyVWlGVenW
         8p8ykm/XC7wQoDQNV2QpxHASWptNaxEpQhHv5Z0rcxvGo29P/arq7+Iq6hX89WAmp8
         B8ipxPO2QwZ7YPnbsgJtgChVDngcz0dUYzuX23LQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jin Yao <yao.jin@linux.intel.com>,
        Jiri Olsa <jolsa@kernel.org>, Ian Rogers <irogers@google.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Andi Kleen <ak@linux.intel.com>,
        Michael Petlan <mpetlan@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Thomas Richter <tmricht@linux.ibm.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 170/232] perf tools: Fix term parsing for raw syntax
Date:   Thu, 20 Aug 2020 11:20:21 +0200
Message-Id: <20200820091621.052418052@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820091612.692383444@linuxfoundation.org>
References: <20200820091612.692383444@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jiri Olsa <jolsa@kernel.org>

[ Upstream commit 4929e95a1400e45b4b5a87fd3ce10273444187d4 ]

Jin Yao reported issue with possible conflict between raw events and
term values in pmu event syntax.

Currently following syntax is resolved as raw event with 0xead value:

  uncore_imc_free_running/read/

instead of using 'read' term from uncore_imc_free_running pmu, because
'read' is correct raw event syntax with 0xead value.

To solve this issue we do following:

  - check existing terms during rXXXX syntax processing
    and make them priority in case of conflict

  - allow pmu/r0x1234/ syntax to be able to specify conflicting
    raw event (implemented in previous patch)

Also add automated tests for this and perf_pmu__parse_cleanup call to
parse_events_terms, so the test gets properly cleaned up.

Fixes: 3a6c51e4d66c ("perf parser: Add support to specify rXXX event with pmu")
Reported-by: Jin Yao <yao.jin@linux.intel.com>
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
Tested-by: Jin Yao <yao.jin@linux.intel.com>
Acked-by: Ian Rogers <irogers@google.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Michael Petlan <mpetlan@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Cc: Thomas Richter <tmricht@linux.ibm.com>
Link: http://lore.kernel.org/lkml/20200726075244.1191481-2-jolsa@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/tests/parse-events.c | 37 ++++++++++++++++++++++++++++++++-
 tools/perf/util/parse-events.c  | 28 +++++++++++++++++++++++++
 tools/perf/util/parse-events.h  |  2 ++
 tools/perf/util/parse-events.l  | 19 ++++++++++-------
 4 files changed, 77 insertions(+), 9 deletions(-)

diff --git a/tools/perf/tests/parse-events.c b/tools/perf/tests/parse-events.c
index 895188b63f963..6a2ec6ec0d0ef 100644
--- a/tools/perf/tests/parse-events.c
+++ b/tools/perf/tests/parse-events.c
@@ -631,6 +631,34 @@ static int test__checkterms_simple(struct list_head *terms)
 	TEST_ASSERT_VAL("wrong val", term->val.num == 1);
 	TEST_ASSERT_VAL("wrong config", !strcmp(term->config, "umask"));
 
+	/*
+	 * read
+	 *
+	 * The perf_pmu__test_parse_init injects 'read' term into
+	 * perf_pmu_events_list, so 'read' is evaluated as read term
+	 * and not as raw event with 'ead' hex value.
+	 */
+	term = list_entry(term->list.next, struct parse_events_term, list);
+	TEST_ASSERT_VAL("wrong type term",
+			term->type_term == PARSE_EVENTS__TERM_TYPE_USER);
+	TEST_ASSERT_VAL("wrong type val",
+			term->type_val == PARSE_EVENTS__TERM_TYPE_NUM);
+	TEST_ASSERT_VAL("wrong val", term->val.num == 1);
+	TEST_ASSERT_VAL("wrong config", !strcmp(term->config, "read"));
+
+	/*
+	 * r0xead
+	 *
+	 * To be still able to pass 'ead' value with 'r' syntax,
+	 * we added support to parse 'r0xHEX' event.
+	 */
+	term = list_entry(term->list.next, struct parse_events_term, list);
+	TEST_ASSERT_VAL("wrong type term",
+			term->type_term == PARSE_EVENTS__TERM_TYPE_CONFIG);
+	TEST_ASSERT_VAL("wrong type val",
+			term->type_val == PARSE_EVENTS__TERM_TYPE_NUM);
+	TEST_ASSERT_VAL("wrong val", term->val.num == 0xead);
+	TEST_ASSERT_VAL("wrong config", !term->config);
 	return 0;
 }
 
@@ -1776,7 +1804,7 @@ struct terms_test {
 
 static struct terms_test test__terms[] = {
 	[0] = {
-		.str   = "config=10,config1,config2=3,umask=1",
+		.str   = "config=10,config1,config2=3,umask=1,read,r0xead",
 		.check = test__checkterms_simple,
 	},
 };
@@ -1836,6 +1864,13 @@ static int test_term(struct terms_test *t)
 
 	INIT_LIST_HEAD(&terms);
 
+	/*
+	 * The perf_pmu__test_parse_init prepares perf_pmu_events_list
+	 * which gets freed in parse_events_terms.
+	 */
+	if (perf_pmu__test_parse_init())
+		return -1;
+
 	ret = parse_events_terms(&terms, t->str);
 	if (ret) {
 		pr_debug("failed to parse terms '%s', err %d\n",
diff --git a/tools/perf/util/parse-events.c b/tools/perf/util/parse-events.c
index 3decbb203846a..4476de0e678aa 100644
--- a/tools/perf/util/parse-events.c
+++ b/tools/perf/util/parse-events.c
@@ -2017,6 +2017,32 @@ static void perf_pmu__parse_init(void)
 	perf_pmu__parse_cleanup();
 }
 
+/*
+ * This function injects special term in
+ * perf_pmu_events_list so the test code
+ * can check on this functionality.
+ */
+int perf_pmu__test_parse_init(void)
+{
+	struct perf_pmu_event_symbol *list;
+
+	list = malloc(sizeof(*list) * 1);
+	if (!list)
+		return -ENOMEM;
+
+	list->type   = PMU_EVENT_SYMBOL;
+	list->symbol = strdup("read");
+
+	if (!list->symbol) {
+		free(list);
+		return -ENOMEM;
+	}
+
+	perf_pmu_events_list = list;
+	perf_pmu_events_list_num = 1;
+	return 0;
+}
+
 enum perf_pmu_event_symbol_type
 perf_pmu__parse_check(const char *name)
 {
@@ -2078,6 +2104,8 @@ int parse_events_terms(struct list_head *terms, const char *str)
 	int ret;
 
 	ret = parse_events__scanner(str, &parse_state);
+	perf_pmu__parse_cleanup();
+
 	if (!ret) {
 		list_splice(parse_state.terms, terms);
 		zfree(&parse_state.terms);
diff --git a/tools/perf/util/parse-events.h b/tools/perf/util/parse-events.h
index 1fe23a2f9b36e..0b8cdb7270f04 100644
--- a/tools/perf/util/parse-events.h
+++ b/tools/perf/util/parse-events.h
@@ -253,4 +253,6 @@ static inline bool is_sdt_event(char *str __maybe_unused)
 }
 #endif /* HAVE_LIBELF_SUPPORT */
 
+int perf_pmu__test_parse_init(void);
+
 #endif /* __PERF_PARSE_EVENTS_H */
diff --git a/tools/perf/util/parse-events.l b/tools/perf/util/parse-events.l
index 002802e17059e..7332d16cb4fc7 100644
--- a/tools/perf/util/parse-events.l
+++ b/tools/perf/util/parse-events.l
@@ -41,14 +41,6 @@ static int value(yyscan_t scanner, int base)
 	return __value(yylval, text, base, PE_VALUE);
 }
 
-static int raw(yyscan_t scanner)
-{
-	YYSTYPE *yylval = parse_events_get_lval(scanner);
-	char *text = parse_events_get_text(scanner);
-
-	return __value(yylval, text + 1, 16, PE_RAW);
-}
-
 static int str(yyscan_t scanner, int token)
 {
 	YYSTYPE *yylval = parse_events_get_lval(scanner);
@@ -72,6 +64,17 @@ static int str(yyscan_t scanner, int token)
 	return token;
 }
 
+static int raw(yyscan_t scanner)
+{
+	YYSTYPE *yylval = parse_events_get_lval(scanner);
+	char *text = parse_events_get_text(scanner);
+
+	if (perf_pmu__parse_check(text) == PMU_EVENT_SYMBOL)
+		return str(scanner, PE_NAME);
+
+	return __value(yylval, text + 1, 16, PE_RAW);
+}
+
 static bool isbpf_suffix(char *text)
 {
 	int len = strlen(text);
-- 
2.25.1



