Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A1F214ABD31
	for <lists+stable@lfdr.de>; Mon,  7 Feb 2022 12:59:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381106AbiBGLjy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Feb 2022 06:39:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1386318AbiBGLeX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Feb 2022 06:34:23 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71210C043181;
        Mon,  7 Feb 2022 03:34:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EC03C60A69;
        Mon,  7 Feb 2022 11:34:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DEB9BC004E1;
        Mon,  7 Feb 2022 11:34:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644233662;
        bh=+47cr8N7Htw4ywLt3V8sL2iOcTtpPvwzUNFzThO3/TY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sIGzIqSWd69oa1ICWHmWNpxAi3TmYbY1hZPLwSnju8GcMXImRJWHqXGPFaR4/wvmW
         Y4lHW4Mt22HwkHTEqT7uWZkvv+3n2jkb1Il9dvakpwXGHiQXwFpEf7XVyA54h/vAVP
         8Md/kzXyWBAZdPSNG7E5KbiCBUa4BJ/QtBX/wvHI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Matthew Brost <matthew.brost@intel.com>,
        John Harrison <John.C.Harrison@Intel.com>,
        Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Subject: [PATCH 5.16 081/126] drm/i915: Lock timeline mutex directly in error path of eb_pin_timeline
Date:   Mon,  7 Feb 2022 12:06:52 +0100
Message-Id: <20220207103806.903419880@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220207103804.053675072@linuxfoundation.org>
References: <20220207103804.053675072@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Matthew Brost <matthew.brost@intel.com>

commit 5ae13c305ef8cb54efc4f0ba4565709b9f320fed upstream.

Don't use the interruptable version of the timeline mutex lock in the
error path of eb_pin_timeline as the cleanup must always happen.

v2:
 (John Harrison)
  - Don't check for interrupt during mutex lock
v3:
 (Tvrtko)
  - A comment explaining why lock helper isn't used

Fixes: 544460c33821 ("drm/i915: Multi-BB execbuf")
Signed-off-by: Matthew Brost <matthew.brost@intel.com>
Reviewed-by: John Harrison <John.C.Harrison@Intel.com>
Signed-off-by: John Harrison <John.C.Harrison@Intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20220111163929.14017-1-matthew.brost@intel.com
(cherry picked from commit cb935c4618bd2ff9058feee4af7088446da6a763)
Signed-off-by: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/gem/i915_gem_execbuffer.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/i915/gem/i915_gem_execbuffer.c
+++ b/drivers/gpu/drm/i915/gem/i915_gem_execbuffer.c
@@ -2372,9 +2372,14 @@ static int eb_pin_timeline(struct i915_e
 				      timeout) < 0) {
 			i915_request_put(rq);
 
-			tl = intel_context_timeline_lock(ce);
+			/*
+			 * Error path, cannot use intel_context_timeline_lock as
+			 * that is user interruptable and this clean up step
+			 * must be done.
+			 */
+			mutex_lock(&ce->timeline->mutex);
 			intel_context_exit(ce);
-			intel_context_timeline_unlock(tl);
+			mutex_unlock(&ce->timeline->mutex);
 
 			if (nonblock)
 				return -EWOULDBLOCK;


