Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18F6F669677
	for <lists+stable@lfdr.de>; Fri, 13 Jan 2023 13:09:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234479AbjAMMIz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Jan 2023 07:08:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239906AbjAMMH6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 13 Jan 2023 07:07:58 -0500
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2FA8395D4
        for <stable@vger.kernel.org>; Fri, 13 Jan 2023 04:01:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1673611260; x=1705147260;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=qwYLpR4n8sk5JMoA5wDMP1VNX/CMdZQ/eU37IeEfbHo=;
  b=e6CuCExZa+RJAhZYRsYYvOCVD5A5hXAcaKaPEV4+Ucr+oHsL7STMaDh6
   sRMuc0Eorg4/OzC9J0PfgnakY6RgkafSrKLbEky9Sp1K/QkApXWZ/3cf/
   /WZuj83uKhiVYxTosMU6VhFbzS+YNE2jcGCf1ta7dcd8lAoEmO66NIkMe
   xIPWRffzGhzSelywsjp1V52t/ziOYZshDCSnvrWV+nLw6+iUsyMOvDLCd
   SIhbKPheBRVB4mU0NUL1cQSMjmWwDLoROZWf3qcjEfwk0n8nh+urxtIpG
   KkGcEpxN3nzMVaEH0T7MXhYZ3V1zE8l0HUBcsqgUjextWbVkhrtJ6PC/3
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10588"; a="322675897"
X-IronPort-AV: E=Sophos;i="5.97,213,1669104000"; 
   d="scan'208";a="322675897"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jan 2023 04:01:00 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10588"; a="721506758"
X-IronPort-AV: E=Sophos;i="5.97,213,1669104000"; 
   d="scan'208";a="721506758"
Received: from nirmoyda-desk.igk.intel.com ([10.102.42.231])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Jan 2023 04:00:58 -0800
From:   Nirmoy Das <nirmoy.das@intel.com>
To:     intel-gfx@lists.freedesktop.org
Cc:     dri-devel@lists.freedesktop.org, chris.p.wilson@linux.intel.com,
        matthew.auld@intel.com, andi.shyti@linux.intel.com,
        Nirmoy Das <nirmoy.das@intel.com>, stable@vger.kernel.org
Subject: [PATCH] drm/i915/selftests: Unwind hugepages to drop wakeref on error
Date:   Fri, 13 Jan 2023 13:00:53 +0100
Message-Id: <20230113120053.29618-1-nirmoy.das@intel.com>
X-Mailer: git-send-email 2.39.0
MIME-Version: 1.0
Organization: Intel Deutschland GmbH, Registered Address: Am Campeon 10, 85579 Neubiberg, Germany, Commercial Register: Amtsgericht Muenchen HRB 186928 
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chris Wilson <chris.p.wilson@linux.intel.com>

Make sure that upon error after we have acquired the wakeref we do
release it again.

Fixes: 027c38b4121e ("drm/i915/selftests: Grab the runtime pm in shrink_thp")
Reviewed-by: Matthew Auld <matthew.auld@intel.com>
Signed-off-by: Chris Wilson <chris.p.wilson@linux.intel.com>
Signed-off-by: Nirmoy Das <nirmoy.das@intel.com>
Cc: <stable@vger.kernel.org> # v6.0+
---
 drivers/gpu/drm/i915/gem/selftests/huge_pages.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/i915/gem/selftests/huge_pages.c b/drivers/gpu/drm/i915/gem/selftests/huge_pages.c
index c281b0ec9e05..295d6f2cc4ff 100644
--- a/drivers/gpu/drm/i915/gem/selftests/huge_pages.c
+++ b/drivers/gpu/drm/i915/gem/selftests/huge_pages.c
@@ -1855,7 +1855,7 @@ static int igt_shrink_thp(void *arg)
 			I915_SHRINK_ACTIVE);
 	i915_vma_unpin(vma);
 	if (err)
-		goto out_put;
+		goto out_wf;
 
 	/*
 	 * Now that the pages are *unpinned* shrinking should invoke
@@ -1871,7 +1871,7 @@ static int igt_shrink_thp(void *arg)
 		pr_err("unexpected pages mismatch, should_swap=%s\n",
 		       str_yes_no(should_swap));
 		err = -EINVAL;
-		goto out_put;
+		goto out_wf;
 	}
 
 	if (should_swap == (obj->mm.page_sizes.sg || obj->mm.page_sizes.phys)) {
@@ -1883,7 +1883,7 @@ static int igt_shrink_thp(void *arg)
 
 	err = i915_vma_pin(vma, 0, 0, flags);
 	if (err)
-		goto out_put;
+		goto out_wf;
 
 	while (n--) {
 		err = cpu_check(obj, n, 0xdeadbeaf);
-- 
2.39.0

