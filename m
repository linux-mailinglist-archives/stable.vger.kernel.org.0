Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC20F657B49
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:19:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233298AbiL1PT6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:19:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233270AbiL1PTy (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:19:54 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0370513FA6
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:19:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7A3FEB816D9
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:19:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE612C433D2;
        Wed, 28 Dec 2022 15:19:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672240791;
        bh=YfvghuHV/PKWUstqcre32eUMoo1Em/uIM5aaBU6SKTI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HRvHpUdfPRo6/yjWHLURh5whyo7+clAEKbHMZTUO4kpdJbtD0U19NmdYLFFgquja2
         5FOp9FooS27xBmWwLw381//ZWJIEJIPyO+vmfLmwOh8bDAOhMalXHhfq2oiOEPkD0f
         VJSmraiz/8o/pZNkLu2YCztkIzgeqAlokJ72dj2s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Xu Kuohai <xukuohai@huawei.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Jiri Olsa <jolsa@kernel.org>,
        Martin KaFai Lau <martin.lau@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0203/1073] selftest/bpf: Fix memory leak in kprobe_multi_test
Date:   Wed, 28 Dec 2022 15:29:51 +0100
Message-Id: <20221228144333.532035619@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xu Kuohai <xukuohai@huawei.com>

[ Upstream commit 6d2e21dc4db3933db65293552ecc1ede26febeca ]

The get_syms() function in kprobe_multi_test.c does not free the string
memory allocated by sscanf correctly. Fix it.

Fixes: 5b6c7e5c4434 ("selftests/bpf: Add attach bench test")
Signed-off-by: Xu Kuohai <xukuohai@huawei.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Acked-by: Jiri Olsa <jolsa@kernel.org>
Acked-by: Martin KaFai Lau <martin.lau@kernel.org>
Link: https://lore.kernel.org/bpf/20221011120108.782373-5-xukuohai@huaweicloud.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../bpf/prog_tests/kprobe_multi_test.c        | 26 ++++++++++---------
 1 file changed, 14 insertions(+), 12 deletions(-)

diff --git a/tools/testing/selftests/bpf/prog_tests/kprobe_multi_test.c b/tools/testing/selftests/bpf/prog_tests/kprobe_multi_test.c
index d457a55ff408..287b3ac40227 100644
--- a/tools/testing/selftests/bpf/prog_tests/kprobe_multi_test.c
+++ b/tools/testing/selftests/bpf/prog_tests/kprobe_multi_test.c
@@ -325,7 +325,7 @@ static bool symbol_equal(const void *key1, const void *key2, void *ctx __maybe_u
 static int get_syms(char ***symsp, size_t *cntp)
 {
 	size_t cap = 0, cnt = 0, i;
-	char *name, **syms = NULL;
+	char *name = NULL, **syms = NULL;
 	struct hashmap *map;
 	char buf[256];
 	FILE *f;
@@ -352,6 +352,8 @@ static int get_syms(char ***symsp, size_t *cntp)
 		/* skip modules */
 		if (strchr(buf, '['))
 			continue;
+
+		free(name);
 		if (sscanf(buf, "%ms$*[^\n]\n", &name) != 1)
 			continue;
 		/*
@@ -369,32 +371,32 @@ static int get_syms(char ***symsp, size_t *cntp)
 		if (!strncmp(name, "__ftrace_invalid_address__",
 			     sizeof("__ftrace_invalid_address__") - 1))
 			continue;
+
 		err = hashmap__add(map, name, NULL);
-		if (err) {
-			free(name);
-			if (err == -EEXIST)
-				continue;
+		if (err == -EEXIST)
+			continue;
+		if (err)
 			goto error;
-		}
+
 		err = libbpf_ensure_mem((void **) &syms, &cap,
 					sizeof(*syms), cnt + 1);
-		if (err) {
-			free(name);
+		if (err)
 			goto error;
-		}
-		syms[cnt] = name;
-		cnt++;
+
+		syms[cnt++] = name;
+		name = NULL;
 	}
 
 	*symsp = syms;
 	*cntp = cnt;
 
 error:
+	free(name);
 	fclose(f);
 	hashmap__free(map);
 	if (err) {
 		for (i = 0; i < cnt; i++)
-			free(syms[cnt]);
+			free(syms[i]);
 		free(syms);
 	}
 	return err;
-- 
2.35.1



