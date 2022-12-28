Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65BB6657BD0
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 16:26:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232635AbiL1P0M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 10:26:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233770AbiL1PZ3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 10:25:29 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 979C914020
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 07:25:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3118D61560
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 15:25:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4205AC433D2;
        Wed, 28 Dec 2022 15:25:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672241127;
        bh=DY6HX5Oqg+lYOKFhnI5mdCIuTF9C5W6VAKeXwabiFeo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VJfXePavEAD1eQ6pbkHofl0OGU5ofuXqVVghK3Mam7idhUNmJAVRQdwYoUEUVA8i6
         YMaH74DO4w0FOrh7U5s4diPj81VDSkWCfwtdDNtmAEr+vqfftUyNNKjW0Fz64Iu5so
         vFj8imwnFObLZ3HbeZLeAZGKX5TLbmpXELY031oM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Xu Kuohai <xukuohai@huawei.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Jiri Olsa <jolsa@kernel.org>,
        Martin KaFai Lau <martin.lau@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0208/1146] selftest/bpf: Fix memory leak in kprobe_multi_test
Date:   Wed, 28 Dec 2022 15:29:07 +0100
Message-Id: <20221228144335.796419155@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
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
index a4b4133d39e9..0d82e28aed1a 100644
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
@@ -371,32 +373,32 @@ static int get_syms(char ***symsp, size_t *cntp)
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



