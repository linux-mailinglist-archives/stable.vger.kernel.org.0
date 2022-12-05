Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 478A16433C9
	for <lists+stable@lfdr.de>; Mon,  5 Dec 2022 20:39:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234600AbiLETjb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Dec 2022 14:39:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234603AbiLETjN (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Dec 2022 14:39:13 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3A76DFA8
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 11:36:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 619E461335
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 19:36:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76EB1C433D7;
        Mon,  5 Dec 2022 19:36:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670268981;
        bh=BdjOTldohBvTZY4JVOEt+AEvpAULx76lOKL2SAdMeqM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lz4hO6pPZ7fq12qoBSXw1AMA0S8tNRk/xif/hIqKSW0sYEf8I/7PphHsJWGYSpYu9
         BNwFHhVVsAlVA2xle7fbVglV+HZ3ixsbged6jonvtrwSysTzSxuYnhUWRI9y10lAKF
         EUtk/uasvClK+bz7vljJJQppqp3EQWZslcCiOZ3c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Janusz Krzysztofik <janusz.krzysztofik@linux.intel.com>,
        Andrzej Hajda <andrzej.hajda@intel.com>,
        Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Subject: [PATCH 5.15 083/120] drm/i915: Fix negative value passed as remaining time
Date:   Mon,  5 Dec 2022 20:10:23 +0100
Message-Id: <20221205190809.089476777@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221205190806.528972574@linuxfoundation.org>
References: <20221205190806.528972574@linuxfoundation.org>
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

From: Janusz Krzysztofik <janusz.krzysztofik@linux.intel.com>

commit a8899b8728013c7b2456f0bfa20e5fea85ee0fd1 upstream.

Commit b97060a99b01 ("drm/i915/guc: Update intel_gt_wait_for_idle to work
with GuC") extended the API of intel_gt_retire_requests_timeout() with an
extra argument 'remaining_timeout', intended for passing back unconsumed
portion of requested timeout when 0 (success) is returned.  However, when
request retirement happens to succeed despite an error returned by a call
to dma_fence_wait_timeout(), that error code (a negative value) is passed
back instead of remaining time.  If we then pass that negative value
forward as requested timeout to intel_uc_wait_for_idle(), an explicit BUG
will be triggered.

If request retirement succeeds but an error code is passed back via
remaininig_timeout, we may have no clue on how much of the initial timeout
might have been left for spending it on waiting for GuC to become idle.
OTOH, since all pending requests have been successfully retired, that
error code has been already ignored by intel_gt_retire_requests_timeout(),
then we shouldn't fail.

Assume no more time has been left on error and pass 0 timeout value to
intel_uc_wait_for_idle() to give it a chance to return success if GuC is
already idle.

v3: Don't fail on any error passed back via remaining_timeout.

v2: Fix the issue on the caller side, not the provider.

Fixes: b97060a99b01 ("drm/i915/guc: Update intel_gt_wait_for_idle to work with GuC")
Signed-off-by: Janusz Krzysztofik <janusz.krzysztofik@linux.intel.com>
Cc: stable@vger.kernel.org # v5.15+
Reviewed-by: Andrzej Hajda <andrzej.hajda@intel.com>
Signed-off-by: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20221121145655.75141-2-janusz.krzysztofik@linux.intel.com
(cherry picked from commit f235dbd5b768e238d365fd05d92de5a32abc1c1f)
Signed-off-by: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/gt/intel_gt.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/i915/gt/intel_gt.c
+++ b/drivers/gpu/drm/i915/gt/intel_gt.c
@@ -650,8 +650,13 @@ int intel_gt_wait_for_idle(struct intel_
 			return -EINTR;
 	}
 
-	return timeout ? timeout : intel_uc_wait_for_idle(&gt->uc,
-							  remaining_timeout);
+	if (timeout)
+		return timeout;
+
+	if (remaining_timeout < 0)
+		remaining_timeout = 0;
+
+	return intel_uc_wait_for_idle(&gt->uc, remaining_timeout);
 }
 
 int intel_gt_init(struct intel_gt *gt)


