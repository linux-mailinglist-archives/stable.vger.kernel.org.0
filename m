Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4DE246344D7
	for <lists+stable@lfdr.de>; Tue, 22 Nov 2022 20:48:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234698AbiKVTsy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Nov 2022 14:48:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234578AbiKVTso (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Nov 2022 14:48:44 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94DEA57B78;
        Tue, 22 Nov 2022 11:48:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 007EA61759;
        Tue, 22 Nov 2022 19:48:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8418C433D6;
        Tue, 22 Nov 2022 19:48:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669146518;
        bh=fELDYP7X7g2hQl01HL1seDQ0enwlGxaSh2Vjv+ZYToU=;
        h=From:To:Cc:Subject:Date:From;
        b=d9awUBACiXT6NtF2V4ad/eJjEaQCigkXO/j1aQoYsuFW6RdPlhNvCz352QKphf6uv
         YeHKeIHQLBktbxEvc0HOp+LzekGhy5IIrfe6vuqQZ0djQb/haE5Rq+vjd2jxYOP3AB
         bzUfe4vQLX7dcyuwlXhqofokrNoUPDH4XD832fhZ31mJAv3yjMpbSoctQF0+vJNA5a
         pJLEyOhcaZTvflI94IT8T66up2b/V6KJpR60+xl9uz4atP+qUNuq9fJzOYRWnXvWX5
         yXFFaeNg50ZldZGB7nOgFqPk1bBpqglkmqfDflyfWghPpY5OZ37nRSKAcdsfSWB67p
         TOTO1D6eWMa7Q==
From:   SeongJae Park <sj@kernel.org>
To:     akpm@linux-foundation.org
Cc:     damon@lists.linux.dev, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, SeongJae Park <sj@kernel.org>,
        stable@vger.kernel.org
Subject: [PATCH mm-hotfixes-unstable] mm/damon/sysfs: fix wrong empty schemes assumption under online tuning in damon_sysfs_set_schemes()
Date:   Tue, 22 Nov 2022 19:48:31 +0000
Message-Id: <20221122194831.3472-1-sj@kernel.org>
X-Mailer: git-send-email 2.25.1
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

Commit da87878010e5 ("mm/damon/sysfs: support online inputs update")
made 'damon_sysfs_set_schemes()' to be called for running DAMON context,
which could have schemes.  In the case, DAMON sysfs interface is
supposed to update, remove, or add schemes to reflect the sysfs files.
However, the code is assuming the DAMON context wouldn't have schemes at
all, and therefore creates and adds new schemes.  As a result, the code
doesn't work as intended for online schemes tuning and could have more
than expected memory footprint.   The schemes are all in the DAMON
context, so it doesn't leak the memory, though.

Remove the wrong asssumption (the DAMON context wouldn't have schemes)
in 'damon_sysfs_set_schemes()' to fix the bug.

Fixes: da87878010e5 ("mm/damon/sysfs: support online inputs update")
Cc: <stable@vger.kernel.org> # 5.19.y
Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/sysfs.c | 46 ++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 44 insertions(+), 2 deletions(-)

diff --git a/mm/damon/sysfs.c b/mm/damon/sysfs.c
index 5ce403378c20..07e5f1bdf025 100644
--- a/mm/damon/sysfs.c
+++ b/mm/damon/sysfs.c
@@ -2283,12 +2283,54 @@ static struct damos *damon_sysfs_mk_scheme(
 			&wmarks);
 }
 
+static void damon_sysfs_update_scheme(struct damos *scheme,
+		struct damon_sysfs_scheme *sysfs_scheme)
+{
+	struct damon_sysfs_access_pattern *access_pattern =
+		sysfs_scheme->access_pattern;
+	struct damon_sysfs_quotas *sysfs_quotas = sysfs_scheme->quotas;
+	struct damon_sysfs_weights *sysfs_weights = sysfs_quotas->weights;
+	struct damon_sysfs_watermarks *sysfs_wmarks = sysfs_scheme->watermarks;
+
+	scheme->pattern.min_sz_region = access_pattern->sz->min;
+	scheme->pattern.max_sz_region = access_pattern->sz->max;
+	scheme->pattern.min_nr_accesses = access_pattern->nr_accesses->min;
+	scheme->pattern.max_nr_accesses = access_pattern->nr_accesses->max;
+	scheme->pattern.min_age_region = access_pattern->age->min;
+	scheme->pattern.max_age_region = access_pattern->age->max;
+
+	scheme->action = sysfs_scheme->action;
+
+	scheme->quota.ms = sysfs_quotas->ms;
+	scheme->quota.sz = sysfs_quotas->sz;
+	scheme->quota.reset_interval = sysfs_quotas->reset_interval_ms;
+	scheme->quota.weight_sz = sysfs_weights->sz;
+	scheme->quota.weight_nr_accesses = sysfs_weights->nr_accesses;
+	scheme->quota.weight_age = sysfs_weights->age;
+
+	scheme->wmarks.metric = sysfs_wmarks->metric;
+	scheme->wmarks.interval = sysfs_wmarks->interval_us;
+	scheme->wmarks.high = sysfs_wmarks->high;
+	scheme->wmarks.mid = sysfs_wmarks->mid;
+	scheme->wmarks.low = sysfs_wmarks->low;
+}
+
 static int damon_sysfs_set_schemes(struct damon_ctx *ctx,
 		struct damon_sysfs_schemes *sysfs_schemes)
 {
-	int i;
+	struct damos *scheme, *next;
+	int i = 0;
+
+	damon_for_each_scheme_safe(scheme, next, ctx) {
+		if (i < sysfs_schemes->nr)
+			damon_sysfs_update_scheme(scheme,
+					sysfs_schemes->schemes_arr[i]);
+		else
+			damon_destroy_scheme(scheme);
+		i++;
+	}
 
-	for (i = 0; i < sysfs_schemes->nr; i++) {
+	for (; i < sysfs_schemes->nr; i++) {
 		struct damos *scheme, *next;
 
 		scheme = damon_sysfs_mk_scheme(sysfs_schemes->schemes_arr[i]);
-- 
2.25.1

