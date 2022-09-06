Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 87C685AEC8A
	for <lists+stable@lfdr.de>; Tue,  6 Sep 2022 16:28:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241498AbiIFOUd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Sep 2022 10:20:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241966AbiIFOTI (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Sep 2022 10:19:08 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D975AE1E;
        Tue,  6 Sep 2022 06:50:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0354CB818D0;
        Tue,  6 Sep 2022 13:48:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D52BC433D6;
        Tue,  6 Sep 2022 13:48:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662472101;
        bh=VQLh+a20xEIZQ+P8D/7MgSC1pEMZ2OICGNln5U9ZaTU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=leIKeICS4LQIoZQloqVLRbPuUcWdqp8Fgl1oxxvDcQpoWyAfwEkwoczvwAYKoGvc6
         w3EAT7DMH4KIu11Pizb220EzUAzScDtYGc43wR1vwytVA0epb2vvxVVvDYS4crvQpA
         1x1Z6FvX7avdBslam7CiqQGJ3AsKN+QxpC3hIB+E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>,
        Matthew Brost <matthew.brost@intel.com>,
        John Harrison <john.c.harrison@intel.com>,
        John Harrison <John.C.Harrison@Intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>
Subject: [PATCH 5.19 149/155] drm/i915/guc: clear stalled request after a reset
Date:   Tue,  6 Sep 2022 15:31:37 +0200
Message-Id: <20220906132835.711944497@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220906132829.417117002@linuxfoundation.org>
References: <20220906132829.417117002@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>

commit 4595a25443447b9542b2a5ee7961eb290e94b496 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/gt/uc/intel_guc_submission.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/gpu/drm/i915/gt/uc/intel_guc_submission.c
+++ b/drivers/gpu/drm/i915/gt/uc/intel_guc_submission.c
@@ -4011,6 +4011,13 @@ static inline void guc_init_lrc_mapping(
 	xa_destroy(&guc->context_lookup);
 
 	/*
+	 * A reset might have occurred while we had a pending stalled request,
+	 * so make sure we clean that up.
+	 */
+	guc->stalled_request = NULL;
+	guc->submission_stall_reason = STALL_NONE;
+
+	/*
 	 * Some contexts might have been pinned before we enabled GuC
 	 * submission, so we need to add them to the GuC bookeeping.
 	 * Also, after a reset the of the GuC we want to make sure that the


