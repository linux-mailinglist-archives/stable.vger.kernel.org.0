Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB83D54146F
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 22:18:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358619AbiFGUSF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 16:18:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376476AbiFGUQt (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 16:16:49 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F6211CEAC8;
        Tue,  7 Jun 2022 11:29:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 73B37B82340;
        Tue,  7 Jun 2022 18:29:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2D0FC385A2;
        Tue,  7 Jun 2022 18:29:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654626548;
        bh=8vn3WfCeBWbip3UZVakqAn6ebEUw0ACv6P34zaVi2U0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sl3+lvHgBJEotYiKJN/UvyMotvazLSSWXFpjadk8Z9H9fQY/ArTDEEHDblNSG0svB
         vY5N+gZ3nae2tO7ssaBsGcwyMziAGstqhg7GJBIVwhCQr2zhyrayIU3RvwTKQLFgI0
         GDoH1123vv0eZlBA7lcqAXPAtjHWemkaT+Q6mEjk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nathan Chancellor <nathan@kernel.org>,
        Kees Cook <keescook@chromium.org>,
        Sami Tolvanen <samitolvanen@google.com>,
        Tvrtko Ursulin <tvrtko.ursulin@intel.com>,
        Jani Nikula <jani.nikula@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 417/772] drm/i915: Fix CFI violation with show_dynamic_id()
Date:   Tue,  7 Jun 2022 19:00:09 +0200
Message-Id: <20220607165001.295022095@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164948.980838585@linuxfoundation.org>
References: <20220607164948.980838585@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nathan Chancellor <nathan@kernel.org>

[ Upstream commit 58606220a2f1407a7516c547f09a1ba7b4350a73 ]

When an attribute group is created with sysfs_create_group(), the
->sysfs_ops() callback is set to kobj_sysfs_ops, which sets the ->show()
callback to kobj_attr_show(). kobj_attr_show() uses container_of() to
get the ->show() callback from the attribute it was passed, meaning the
->show() callback needs to be the same type as the ->show() callback in
'struct kobj_attribute'.

However, show_dynamic_id() has the type of the ->show() callback in
'struct device_attribute', which causes a CFI violation when opening the
'id' sysfs node under drm/card0/metrics. This happens to work because
the layout of 'struct kobj_attribute' and 'struct device_attribute' are
the same, so the container_of() cast happens to allow the ->show()
callback to still work.

Change the type of show_dynamic_id() to match the ->show() callback in
'struct kobj_attributes' and update the type of sysfs_metric_id to
match, which resolves the CFI violation.

Fixes: f89823c21224 ("drm/i915/perf: Implement I915_PERF_ADD/REMOVE_CONFIG interface")
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Reviewed-by: Kees Cook <keescook@chromium.org>
Reviewed-by: Sami Tolvanen <samitolvanen@google.com>
Signed-off-by: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20220513075136.1027007-1-tvrtko.ursulin@linux.intel.com
(cherry picked from commit 18fb42db05a0b93ab5dd5eab5315e50eaa3ca620)
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/i915_perf.c       | 4 ++--
 drivers/gpu/drm/i915/i915_perf_types.h | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_perf.c b/drivers/gpu/drm/i915/i915_perf.c
index e27f3b7cf094..abcf7e66fe6a 100644
--- a/drivers/gpu/drm/i915/i915_perf.c
+++ b/drivers/gpu/drm/i915/i915_perf.c
@@ -4008,8 +4008,8 @@ static struct i915_oa_reg *alloc_oa_regs(struct i915_perf *perf,
 	return ERR_PTR(err);
 }
 
-static ssize_t show_dynamic_id(struct device *dev,
-			       struct device_attribute *attr,
+static ssize_t show_dynamic_id(struct kobject *kobj,
+			       struct kobj_attribute *attr,
 			       char *buf)
 {
 	struct i915_oa_config *oa_config =
diff --git a/drivers/gpu/drm/i915/i915_perf_types.h b/drivers/gpu/drm/i915/i915_perf_types.h
index aa14354a5120..f682c7a6474d 100644
--- a/drivers/gpu/drm/i915/i915_perf_types.h
+++ b/drivers/gpu/drm/i915/i915_perf_types.h
@@ -55,7 +55,7 @@ struct i915_oa_config {
 
 	struct attribute_group sysfs_metric;
 	struct attribute *attrs[2];
-	struct device_attribute sysfs_metric_id;
+	struct kobj_attribute sysfs_metric_id;
 
 	struct kref ref;
 	struct rcu_head rcu;
-- 
2.35.1



