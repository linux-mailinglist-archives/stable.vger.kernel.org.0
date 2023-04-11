Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D08746DDBFA
	for <lists+stable@lfdr.de>; Tue, 11 Apr 2023 15:24:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229648AbjDKNYH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Apr 2023 09:24:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbjDKNYG (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Apr 2023 09:24:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABDA81BC
        for <stable@vger.kernel.org>; Tue, 11 Apr 2023 06:24:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4876D62641
        for <stable@vger.kernel.org>; Tue, 11 Apr 2023 13:24:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58065C433EF;
        Tue, 11 Apr 2023 13:24:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681219444;
        bh=mEQQC9Iige7LjXWt4PInBSQshqAkf26L8J0NM6GE6uc=;
        h=Subject:To:Cc:From:Date:From;
        b=mrZsm7qgm/skW/sb7IY18PS1puJofa1aogCm0WKKafh2cVjaEwWdatGgYevTt8WGT
         Vv7LqiI3iN2fROoJMrnJy0jXNH/CoD3nOOHLna9VVeQ7hG2pjesRpt69V2dyE8H3aH
         Rpblbcy5vbHIe2RObrDSG6foZ0KIIKT/9awYisOw=
Subject: FAILED: patch "[PATCH] drm/i915: fix race condition UAF in" failed to apply to 5.15-stable tree
To:     lm0963hack@gmail.com, andi.shyti@linux.intel.com,
        jani.nikula@intel.com, stable@vger.kernel.org,
        tvrtko.ursulin@intel.com, umesh.nerlige.ramappa@intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 11 Apr 2023 15:24:01 +0200
Message-ID: <2023041101-slackness-maturing-0041@gregkh>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

To reproduce the conflict and resubmit, you may use the following commands:

git fetch https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/ linux-5.15.y
git checkout FETCH_HEAD
git cherry-pick -x dc30c011469165d57af9adac5baff7d767d20e5c
# <resolve conflicts, build, test, etc.>
git commit -s
git send-email --to '<stable@vger.kernel.org>' --in-reply-to '2023041101-slackness-maturing-0041@gregkh' --subject-prefix 'PATCH 5.15.y' HEAD^..

Possible dependencies:

dc30c0114691 ("drm/i915: fix race condition UAF in i915_perf_add_config_ioctl")
2fec539112e8 ("i915/perf: Replace DRM_DEBUG with driver specific drm_dbg call")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From dc30c011469165d57af9adac5baff7d767d20e5c Mon Sep 17 00:00:00 2001
From: Min Li <lm0963hack@gmail.com>
Date: Tue, 28 Mar 2023 17:36:27 +0800
Subject: [PATCH] drm/i915: fix race condition UAF in
 i915_perf_add_config_ioctl

Userspace can guess the id value and try to race oa_config object creation
with config remove, resulting in a use-after-free if we dereference the
object after unlocking the metrics_lock.  For that reason, unlocking the
metrics_lock must be done after we are done dereferencing the object.

Signed-off-by: Min Li <lm0963hack@gmail.com>
Fixes: f89823c21224 ("drm/i915/perf: Implement I915_PERF_ADD/REMOVE_CONFIG interface")
Cc: <stable@vger.kernel.org> # v4.14+
Reviewed-by: Andi Shyti <andi.shyti@linux.intel.com>
Reviewed-by: Umesh Nerlige Ramappa <umesh.nerlige.ramappa@intel.com>
Signed-off-by: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20230328093627.5067-1-lm0963hack@gmail.com
[tursulin: Manually added stable tag.]
(cherry picked from commit 49f6f6483b652108bcb73accd0204a464b922395)
Signed-off-by: Jani Nikula <jani.nikula@intel.com>

diff --git a/drivers/gpu/drm/i915/i915_perf.c b/drivers/gpu/drm/i915/i915_perf.c
index 283a4a3c6862..004074936300 100644
--- a/drivers/gpu/drm/i915/i915_perf.c
+++ b/drivers/gpu/drm/i915/i915_perf.c
@@ -4638,13 +4638,13 @@ int i915_perf_add_config_ioctl(struct drm_device *dev, void *data,
 		err = oa_config->id;
 		goto sysfs_err;
 	}
-
-	mutex_unlock(&perf->metrics_lock);
+	id = oa_config->id;
 
 	drm_dbg(&perf->i915->drm,
 		"Added config %s id=%i\n", oa_config->uuid, oa_config->id);
+	mutex_unlock(&perf->metrics_lock);
 
-	return oa_config->id;
+	return id;
 
 sysfs_err:
 	mutex_unlock(&perf->metrics_lock);

