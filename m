Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45242641675
	for <lists+stable@lfdr.de>; Sat,  3 Dec 2022 12:36:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229462AbiLCLf7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 3 Dec 2022 06:35:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbiLCLf6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 3 Dec 2022 06:35:58 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B37D19284
        for <stable@vger.kernel.org>; Sat,  3 Dec 2022 03:35:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DFBADB81A6B
        for <stable@vger.kernel.org>; Sat,  3 Dec 2022 11:35:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EE89C433C1;
        Sat,  3 Dec 2022 11:35:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670067354;
        bh=F4h/fnPyLDE0ISQI+abpI5+3UYpdYiBep79VoxaMycM=;
        h=Subject:To:Cc:From:Date:From;
        b=r/BhgOS98zjmupI6587cWKD+kcu7VvQu68EpM54slzXdU3GLaGCymQQUqn2glUBrc
         tS+SAZnuPKnS3zHyPLM/PH98+7up+ziKSARpXVB3SYCAKo2lM+c5Jy3aRn+ufo36pl
         r1J5TpO6yzKEkT4ex4MgQUCnErLaZzx9LQRlzIxk=
Subject: FAILED: patch "[PATCH] mm/damon/sysfs: fix wrong empty schemes assumption under" failed to apply to 6.0-stable tree
To:     sj@kernel.org, akpm@linux-foundation.org, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 03 Dec 2022 12:35:51 +0100
Message-ID: <1670067351106151@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 6.0-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

95bc35f9bee5 ("mm/damon/sysfs: fix wrong empty schemes assumption under online tuning in damon_sysfs_set_schemes()")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 95bc35f9bee5220dad4e8567654ab3288a181639 Mon Sep 17 00:00:00 2001
From: SeongJae Park <sj@kernel.org>
Date: Tue, 22 Nov 2022 19:48:31 +0000
Subject: [PATCH] mm/damon/sysfs: fix wrong empty schemes assumption under
 online tuning in damon_sysfs_set_schemes()

Commit da87878010e5 ("mm/damon/sysfs: support online inputs update") made
'damon_sysfs_set_schemes()' to be called for running DAMON context, which
could have schemes.  In the case, DAMON sysfs interface is supposed to
update, remove, or add schemes to reflect the sysfs files.  However, the
code is assuming the DAMON context wouldn't have schemes at all, and
therefore creates and adds new schemes.  As a result, the code doesn't
work as intended for online schemes tuning and could have more than
expected memory footprint.  The schemes are all in the DAMON context, so
it doesn't leak the memory, though.

Remove the wrong asssumption (the DAMON context wouldn't have schemes) in
'damon_sysfs_set_schemes()' to fix the bug.

Link: https://lkml.kernel.org/r/20221122194831.3472-1-sj@kernel.org
Fixes: da87878010e5 ("mm/damon/sysfs: support online inputs update")
Signed-off-by: SeongJae Park <sj@kernel.org>
Cc: <stable@vger.kernel.org>	[5.19+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

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

