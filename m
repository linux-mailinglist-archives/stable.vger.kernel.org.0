Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B01185AE713
	for <lists+stable@lfdr.de>; Tue,  6 Sep 2022 14:01:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232944AbiIFMAd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Sep 2022 08:00:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232951AbiIFMAZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Sep 2022 08:00:25 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A88642AED
        for <stable@vger.kernel.org>; Tue,  6 Sep 2022 05:00:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0A8FE614DB
        for <stable@vger.kernel.org>; Tue,  6 Sep 2022 12:00:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1598EC433C1;
        Tue,  6 Sep 2022 12:00:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662465622;
        bh=NcVCjCiYN9ZLuV5g3V9SCRvSOYzksUiRPgrnriC7vVs=;
        h=Subject:To:Cc:From:Date:From;
        b=zH5qYQVL9kKiaFinipcOXIrp14oFY1G49zOLkX4p+k+aNABbAhkPh+be139xa69c6
         r9r9YEMyPXIp7UnfSyyk4SjwBBMVHEKYNwNSs/b0sMBIXWx0IkfuEePFoyz//XaLHc
         AFydkEPXxNK5wKT8uwewy1yjK47v6Vat+BBix6QQ=
Subject: FAILED: patch "[PATCH] drm/i915/guc: clear stalled request after a reset" failed to apply to 5.15-stable tree
To:     daniele.ceraolospurio@intel.com, John.C.Harrison@Intel.com,
        john.c.harrison@intel.com, matthew.brost@intel.com,
        rodrigo.vivi@intel.com, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 06 Sep 2022 13:59:36 +0200
Message-ID: <16624655768841@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

4595a2544344 ("drm/i915/guc: clear stalled request after a reset")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 4595a25443447b9542b2a5ee7961eb290e94b496 Mon Sep 17 00:00:00 2001
From: Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>
Date: Thu, 11 Aug 2022 14:08:12 -0700
Subject: [PATCH] drm/i915/guc: clear stalled request after a reset

If the GuC CTs are full and we need to stall the request submission
while waiting for space, we save the stalled request and where the stall
occurred; when the CTs have space again we pick up the request submission
from where we left off.

If a full GT reset occurs, the state of all contexts is cleared and all
non-guilty requests are unsubmitted, therefore we need to restart the
stalled request submission from scratch. To make sure that we do so,
clear the saved request after a reset.

Fixes note: the patch that introduced the bug is in 5.15, but no
officially supported platform had GuC submission enabled by default
in that kernel, so the backport to that particular version (and only
that one) can potentially be skipped.

Fixes: 925dc1cf58ed ("drm/i915/guc: Implement GuC submission tasklet")
Signed-off-by: Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: John Harrison <john.c.harrison@intel.com>
Cc: <stable@vger.kernel.org> # v5.15+
Reviewed-by: John Harrison <John.C.Harrison@Intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20220811210812.3239621-1-daniele.ceraolospurio@intel.com
(cherry picked from commit f922fbb0f2ad1fd3e3186f39c46673419e6d9281)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>

diff --git a/drivers/gpu/drm/i915/gt/uc/intel_guc_submission.c b/drivers/gpu/drm/i915/gt/uc/intel_guc_submission.c
index 76916aed897a..834c707d1877 100644
--- a/drivers/gpu/drm/i915/gt/uc/intel_guc_submission.c
+++ b/drivers/gpu/drm/i915/gt/uc/intel_guc_submission.c
@@ -4026,6 +4026,13 @@ static inline void guc_init_lrc_mapping(struct intel_guc *guc)
 	/* make sure all descriptors are clean... */
 	xa_destroy(&guc->context_lookup);
 
+	/*
+	 * A reset might have occurred while we had a pending stalled request,
+	 * so make sure we clean that up.
+	 */
+	guc->stalled_request = NULL;
+	guc->submission_stall_reason = STALL_NONE;
+
 	/*
 	 * Some contexts might have been pinned before we enabled GuC
 	 * submission, so we need to add them to the GuC bookeeping.

