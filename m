Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA4A36DEFC1
	for <lists+stable@lfdr.de>; Wed, 12 Apr 2023 10:53:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231446AbjDLIxl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Apr 2023 04:53:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231448AbjDLIxb (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Apr 2023 04:53:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4C537A9E
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 01:53:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D6C3B63194
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 08:52:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E82B1C4339B;
        Wed, 12 Apr 2023 08:52:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681289572;
        bh=k44ZqPRxcmRmrvO5MxLFUNiM3u4TTJqvTBK7ixFUNak=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jC+S2dpIrFDMB2/SnWHP1p+9msf2aPNIwdswgHmKutStUEWxHT07sdrlqkPbunpMK
         kyrosDLnDkZpH3Ny/PBftqWoweaji6cgvY2jHBiFGrUBEEoEYangpfCV/S2tAWKOiY
         us0JkypQs3PjM3DTha1CgIucZKMIkxMrNxRVF6WM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Tvrtko Ursulin <tvrtko.ursulin@intel.com>,
        Matthew Auld <matthew.auld@intel.com>,
        Jani Nikula <jani.nikula@intel.com>
Subject: [PATCH 6.2 149/173] drm/i915: Fix context runtime accounting
Date:   Wed, 12 Apr 2023 10:34:35 +0200
Message-Id: <20230412082844.114295291@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230412082838.125271466@linuxfoundation.org>
References: <20230412082838.125271466@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tvrtko Ursulin <tvrtko.ursulin@intel.com>

commit dc3421560a67361442f33ec962fc6dd48895a0df upstream.

When considering whether to mark one context as stopped and another as
started we need to look at whether the previous and new _contexts_ are
different and not just requests. Otherwise the software tracked context
start time was incorrectly updated to the most recent lite-restore time-
stamp, which was in some cases resulting in active time going backward,
until the context switch (typically the heartbeat pulse) would synchronise
with the hardware tracked context runtime. Easiest use case to observe
this behaviour was with a full screen clients with close to 100% engine
load.

Signed-off-by: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Fixes: bb6287cb1886 ("drm/i915: Track context current active time")
Cc: <stable@vger.kernel.org> # v5.19+
Reviewed-by: Matthew Auld <matthew.auld@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20230320151423.1708436-1-tvrtko.ursulin@linux.intel.com
[tursulin: Fix spelling in commit msg.]
(cherry picked from commit b3e70051879c665acdd3a1ab50d0ed58d6a8001f)
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/gt/intel_execlists_submission.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/i915/gt/intel_execlists_submission.c
+++ b/drivers/gpu/drm/i915/gt/intel_execlists_submission.c
@@ -2018,6 +2018,8 @@ process_csb(struct intel_engine_cs *engi
 	 * inspecting the queue to see if we need to resumbit.
 	 */
 	if (*prev != *execlists->active) { /* elide lite-restores */
+		struct intel_context *prev_ce = NULL, *active_ce = NULL;
+
 		/*
 		 * Note the inherent discrepancy between the HW runtime,
 		 * recorded as part of the context switch, and the CPU
@@ -2029,9 +2031,15 @@ process_csb(struct intel_engine_cs *engi
 		 * and correct overselves later when updating from HW.
 		 */
 		if (*prev)
-			lrc_runtime_stop((*prev)->context);
+			prev_ce = (*prev)->context;
 		if (*execlists->active)
-			lrc_runtime_start((*execlists->active)->context);
+			active_ce = (*execlists->active)->context;
+		if (prev_ce != active_ce) {
+			if (prev_ce)
+				lrc_runtime_stop(prev_ce);
+			if (active_ce)
+				lrc_runtime_start(active_ce);
+		}
 		new_timeslice(execlists);
 	}
 


