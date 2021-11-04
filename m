Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDD8644549D
	for <lists+stable@lfdr.de>; Thu,  4 Nov 2021 15:13:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231267AbhKDOQ0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Nov 2021 10:16:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:44820 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231311AbhKDOQZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 4 Nov 2021 10:16:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C737C60F39;
        Thu,  4 Nov 2021 14:13:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636035227;
        bh=d9W2bJ8u9CmBWoEr8NEtdlUSedLn2VTb0hCSP8C870E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aqvpomHjnQ1fU22nBP2upMMGE9b7pKIiPQTxgIVcB8ceabVjoz9FjMe7rGLR2JIfA
         2ry2pKBjXhqhY0GGqau9VPQr7hlEkJLYYTxNEQSn8NAawlg6Uwopp7jJLncHLZB3Uf
         QW0IKR7ig0cySiRPA7n302s0gvgtNHc3kd0JM7vQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Matthew Brost <matthew.brost@intel.com>,
        Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        John Harrison <John.C.Harrison@Intel.com>
Subject: [PATCH 5.15 11/12] Revert "drm/i915/gt: Propagate change in error status to children on unhold"
Date:   Thu,  4 Nov 2021 15:12:37 +0100
Message-Id: <20211104141159.923851880@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211104141159.551636584@linuxfoundation.org>
References: <20211104141159.551636584@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Matthew Brost <matthew.brost@intel.com>

commit ac653dd7996edf1770959e11a078312928bd7315 upstream.

Propagating errors to dependent fences is broken and can lead to errors
from one client ending up in another. In commit 3761baae908a ("Revert
"drm/i915: Propagate errors on awaiting already signaled fences""), we
attempted to get rid of fence error propagation but missed the case
added in commit 8e9f84cf5cac ("drm/i915/gt: Propagate change in error
status to children on unhold"). Revert that one too. This error was
found by an up-and-coming selftest which triggers a reset during
request cancellation and verifies that subsequent requests complete
successfully.

v2:
 (Daniel Vetter)
  - Use revert
v3:
 (Jason)
  - Update commit message

v4 (Daniele):
 - fix checkpatch error in commit message.

Signed-off-by: Matthew Brost <matthew.brost@intel.com>
Signed-off-by: Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>
Reviewed-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Signed-off-by: John Harrison <John.C.Harrison@Intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20210909164744.31249-8-matthew.brost@intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/gt/intel_execlists_submission.c |    4 ----
 1 file changed, 4 deletions(-)

--- a/drivers/gpu/drm/i915/gt/intel_execlists_submission.c
+++ b/drivers/gpu/drm/i915/gt/intel_execlists_submission.c
@@ -2140,10 +2140,6 @@ static void __execlists_unhold(struct i9
 			if (p->flags & I915_DEPENDENCY_WEAK)
 				continue;
 
-			/* Propagate any change in error status */
-			if (rq->fence.error)
-				i915_request_set_error_once(w, rq->fence.error);
-
 			if (w->engine != rq->engine)
 				continue;
 


