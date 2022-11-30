Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 559A463E3AF
	for <lists+stable@lfdr.de>; Wed, 30 Nov 2022 23:51:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229595AbiK3Wvx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 17:51:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229476AbiK3Wvn (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 17:51:43 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6184D8E598;
        Wed, 30 Nov 2022 14:51:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B653061D53;
        Wed, 30 Nov 2022 22:51:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1311EC433D7;
        Wed, 30 Nov 2022 22:51:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1669848701;
        bh=p6uj0vBJbTC56O/6SClTa02F/4udZegs6k2B6l0zuUA=;
        h=Date:To:From:Subject:From;
        b=nBwXrn4ua4ocnGbQ5lqAUJWvnhAxJ6F3eIT5xdFF17mcvfvcmC72VF70o1LHroHex
         Jv4wm01/nfxcFqAZ12gHeKrcausI89UaLO9aFRYYPwD4OCKGE25nuHIemx3is7T8En
         qhZjKwxmJEOGpVc+WPQJiPl7LmifVWXvUPim51YM=
Date:   Wed, 30 Nov 2022 14:51:40 -0800
To:     mm-commits@vger.kernel.org, stable@vger.kernel.org, sj@kernel.org,
        akpm@linux-foundation.org
From:   Andrew Morton <akpm@linux-foundation.org>
Subject: [merged mm-hotfixes-stable] mm-damon-sysfs-fix-wrong-empty-schemes-assumption-under-online-tuning-in-damon_sysfs_set_schemes.patch removed from -mm tree
Message-Id: <20221130225141.1311EC433D7@smtp.kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The quilt patch titled
     Subject: mm/damon/sysfs: fix wrong empty schemes assumption under online tuning in damon_sysfs_set_schemes()
has been removed from the -mm tree.  Its filename was
     mm-damon-sysfs-fix-wrong-empty-schemes-assumption-under-online-tuning-in-damon_sysfs_set_schemes.patch

This patch was dropped because it was merged into the mm-hotfixes-stable branch
of git://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm

------------------------------------------------------
From: SeongJae Park <sj@kernel.org>
Subject: mm/damon/sysfs: fix wrong empty schemes assumption under online tuning in damon_sysfs_set_schemes()
Date: Tue, 22 Nov 2022 19:48:31 +0000

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
---

 mm/damon/sysfs.c |   46 +++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 44 insertions(+), 2 deletions(-)

--- a/mm/damon/sysfs.c~mm-damon-sysfs-fix-wrong-empty-schemes-assumption-under-online-tuning-in-damon_sysfs_set_schemes
+++ a/mm/damon/sysfs.c
@@ -2283,12 +2283,54 @@ static struct damos *damon_sysfs_mk_sche
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
_

Patches currently in -mm which might be from sj@kernel.org are

mm-damon-core-split-out-damos-charged-region-skip-logic-into-a-new-function.patch
mm-damon-core-split-damos-application-logic-into-a-new-function.patch
mm-damon-core-split-out-scheme-stat-update-logic-into-a-new-function.patch
mm-damon-core-split-out-scheme-quota-adjustment-logic-into-a-new-function.patch
mm-damon-sysfs-use-damon_addr_range-for-regions-start-and-end-values.patch
mm-damon-sysfs-remove-parameters-of-damon_sysfs_region_alloc.patch
mm-damon-sysfs-move-sysfs_lock-to-common-module.patch
mm-damon-sysfs-move-unsigned-long-range-directory-to-common-module.patch
mm-damon-sysfs-split-out-kdamond-independent-schemes-stats-update-logic-into-a-new-function.patch
mm-damon-sysfs-split-out-schemes-directory-implementation-to-separate-file.patch
mm-damon-modules-deduplicate-init-steps-for-damon-context-setup.patch
mm-damon-reclaimlru_sort-remove-unnecessarily-included-headers.patch
mm-damon-reclaim-enable-and-disable-synchronously.patch
selftests-damon-add-tests-for-damon_reclaims-enabled-parameter.patch
mm-damon-lru_sort-enable-and-disable-synchronously.patch
selftests-damon-add-tests-for-damon_lru_sorts-enabled-parameter.patch
docs-admin-guide-mm-damon-usage-describe-the-rules-of-sysfs-region-directories.patch
docs-admin-guide-mm-damon-usage-fix-wrong-usage-example-of-init_regions-file.patch
mm-damon-core-add-a-callback-for-scheme-target-regions-check.patch
mm-damon-sysfs-schemes-implement-schemes-tried_regions-directory.patch
mm-damon-sysfs-schemes-implement-scheme-region-directory.patch
mm-damon-sysfs-implement-damos-tried-regions-update-command.patch
mm-damon-sysfs-implement-damos-tried-regions-update-command-fix.patch
mm-damon-sysfs-schemes-implement-damos-tried-regions-clear-command.patch
mm-damon-sysfs-schemes-implement-damos-tried-regions-clear-command-fix.patch
tools-selftets-damon-sysfs-test-tried_regions-directory-existence.patch
docs-admin-guide-mm-damon-usage-document-schemes-s-tried_regions-sysfs-directory.patch
docs-abi-damon-document-schemes-s-tried_regions-sysfs-directory.patch
selftests-damon-test-non-context-inputs-to-rm_contexts-file.patch

