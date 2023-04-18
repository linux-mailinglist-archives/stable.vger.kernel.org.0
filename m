Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B8C56E6357
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 14:39:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231826AbjDRMjq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 08:39:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231828AbjDRMjq (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 08:39:46 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E4621387B
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 05:39:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B15A3632F9
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 12:39:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3572C433D2;
        Tue, 18 Apr 2023 12:39:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681821584;
        bh=qY49jfaNI9VJnlXD3doIFUrmfJSmxxwCzY+M+ycKbq4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=F4GaCLVisuJlFDyD3sieE5Wi5nTp49wTE0biXI6rrm7C7GoF3/cxxoj5WQPMaE2wd
         x9Z4tsHHaxcmdTzPZt1dZ1fFq0ISZltRlOqyZMCbA6DsFpChbKZ5wXmz4cRaiPDmTL
         jgX1cwtZRUV1WI29fsgyKPFe8YfBGbGNdnaD6Hng=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Min Li <lm0963hack@gmail.com>,
        Andi Shyti <andi.shyti@linux.intel.com>,
        Umesh Nerlige Ramappa <umesh.nerlige.ramappa@intel.com>,
        Tvrtko Ursulin <tvrtko.ursulin@intel.com>,
        Jani Nikula <jani.nikula@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 56/91] drm/i915: fix race condition UAF in i915_perf_add_config_ioctl
Date:   Tue, 18 Apr 2023 14:22:00 +0200
Message-Id: <20230418120307.546526568@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230418120305.520719816@linuxfoundation.org>
References: <20230418120305.520719816@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Min Li <lm0963hack@gmail.com>

[ Upstream commit dc30c011469165d57af9adac5baff7d767d20e5c ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/i915_perf.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_perf.c b/drivers/gpu/drm/i915/i915_perf.c
index 4b57cc10bd68e..774d45142091b 100644
--- a/drivers/gpu/drm/i915/i915_perf.c
+++ b/drivers/gpu/drm/i915/i915_perf.c
@@ -4220,13 +4220,13 @@ int i915_perf_add_config_ioctl(struct drm_device *dev, void *data,
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
-- 
2.39.2



