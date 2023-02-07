Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8EB2968D7A6
	for <lists+stable@lfdr.de>; Tue,  7 Feb 2023 14:01:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232035AbjBGNB6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Feb 2023 08:01:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232059AbjBGNBk (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Feb 2023 08:01:40 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 817E739296
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 05:01:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 42B3FB8198C
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 13:01:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62946C433D2;
        Tue,  7 Feb 2023 13:01:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675774866;
        bh=MT5JkZjZc9WeqPjOlzoWk5RT3zQ6IrQnEFFQdbRW8uU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=e4xP/Cl2ODIk1NigdrQ2zAA3wO3AO1z63vXm335klqjtWeyFcyArccGSbksS7gtrA
         P9ee9kNWJbc7X86ylNMeKJaB1oijs0EGsFxgAxP27l/xldpPKtw4UcrhDo8saTCQCS
         V8Mkhn8qtQZ5rCTF7uL3IaVozCphQ1qGdtJ+agPw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, John Harrison <John.C.Harrison@Intel.com>,
        Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>,
        Tvrtko Ursulin <tvrtko.ursulin@intel.com>,
        Matthew Brost <matthew.brost@intel.com>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Matt Roper <matthew.d.roper@intel.com>,
        Umesh Nerlige Ramappa <umesh.nerlige.ramappa@intel.com>,
        Michael Cheng <michael.cheng@intel.com>,
        Lucas De Marchi <lucas.demarchi@intel.com>,
        Tejas Upadhyay <tejaskumarx.surendrakumar.upadhyay@intel.com>,
        Chris Wilson <chris.p.wilson@intel.com>,
        Bruce Chang <yu.bruce.chang@intel.com>,
        Alan Previn <alan.previn.teres.alexis@intel.com>,
        Matthew Auld <matthew.auld@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 060/208] drm/i915/guc: Fix locking when searching for a hung request
Date:   Tue,  7 Feb 2023 13:55:14 +0100
Message-Id: <20230207125637.012048324@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230207125634.292109991@linuxfoundation.org>
References: <20230207125634.292109991@linuxfoundation.org>
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

From: John Harrison <John.C.Harrison@Intel.com>

[ Upstream commit 87b04e53daf806945c415e94de9f90943d434aed ]

intel_guc_find_hung_context() was not acquiring the correct spinlock
before searching the request list. So fix that up. While at it, add
some extra whitespace padding for readability.

Fixes: dc0dad365c5e ("drm/i915/guc: Fix for error capture after full GPU reset with GuC")
Signed-off-by: John Harrison <John.C.Harrison@Intel.com>
Reviewed-by: Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>
Acked-by: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: Jani Nikula <jani.nikula@linux.intel.com>
Cc: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Cc: Rodrigo Vivi <rodrigo.vivi@intel.com>
Cc: Matt Roper <matthew.d.roper@intel.com>
Cc: Umesh Nerlige Ramappa <umesh.nerlige.ramappa@intel.com>
Cc: Michael Cheng <michael.cheng@intel.com>
Cc: Lucas De Marchi <lucas.demarchi@intel.com>
Cc: Tejas Upadhyay <tejaskumarx.surendrakumar.upadhyay@intel.com>
Cc: Chris Wilson <chris.p.wilson@intel.com>
Cc: Bruce Chang <yu.bruce.chang@intel.com>
Cc: Alan Previn <alan.previn.teres.alexis@intel.com>
Cc: Matthew Auld <matthew.auld@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20230127002842.3169194-2-John.C.Harrison@Intel.com
(cherry picked from commit d1c3717501bcf56536e8b8c1bdaf5cd5357f6bb2)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/gt/uc/intel_guc_submission.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/gpu/drm/i915/gt/uc/intel_guc_submission.c b/drivers/gpu/drm/i915/gt/uc/intel_guc_submission.c
index 1a23e901cc66..259162002c3a 100644
--- a/drivers/gpu/drm/i915/gt/uc/intel_guc_submission.c
+++ b/drivers/gpu/drm/i915/gt/uc/intel_guc_submission.c
@@ -4587,6 +4587,8 @@ void intel_guc_find_hung_context(struct intel_engine_cs *engine)
 
 	xa_lock_irqsave(&guc->context_lookup, flags);
 	xa_for_each(&guc->context_lookup, index, ce) {
+		bool found;
+
 		if (!kref_get_unless_zero(&ce->ref))
 			continue;
 
@@ -4603,10 +4605,18 @@ void intel_guc_find_hung_context(struct intel_engine_cs *engine)
 				goto next;
 		}
 
+		found = false;
+		spin_lock(&ce->guc_state.lock);
 		list_for_each_entry(rq, &ce->guc_state.requests, sched.link) {
 			if (i915_test_request_state(rq) != I915_REQUEST_ACTIVE)
 				continue;
 
+			found = true;
+			break;
+		}
+		spin_unlock(&ce->guc_state.lock);
+
+		if (found) {
 			intel_engine_set_hung_context(engine, ce);
 
 			/* Can only cope with one hang at a time... */
@@ -4614,6 +4624,7 @@ void intel_guc_find_hung_context(struct intel_engine_cs *engine)
 			xa_lock(&guc->context_lookup);
 			goto done;
 		}
+
 next:
 		intel_context_put(ce);
 		xa_lock(&guc->context_lookup);
-- 
2.39.0



