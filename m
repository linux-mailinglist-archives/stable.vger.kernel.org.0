Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A4D04454D4
	for <lists+stable@lfdr.de>; Thu,  4 Nov 2021 15:15:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232148AbhKDOSB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 4 Nov 2021 10:18:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:45372 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231340AbhKDORa (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 4 Nov 2021 10:17:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8291960F39;
        Thu,  4 Nov 2021 14:14:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636035293;
        bh=3QhjiIyMNUgU0MFVpRBEiZu9fRWapBRgsTDDiBQJMCc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CUypTPUZrIvzH5WYt1qCNJHoOyC/f58/Fxu6TDB84IitlOnOMEE6RY8Zx9JmKOGSP
         Ja0C8zDutTGKnYobLTSHEx8GNA9hCFi4vTEAPY4TdrzTTPUAeOF1NKVwGGV/70e100
         QfKXJLDIGCb16LY1WmiOFaBnh4fltzHQ3CccRsUo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Matthew Brost <matthew.brost@intel.com>,
        Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        John Harrison <John.C.Harrison@Intel.com>
Subject: [PATCH 5.14 14/16] Revert "drm/i915/gt: Propagate change in error status to children on unhold"
Date:   Thu,  4 Nov 2021 15:12:45 +0100
Message-Id: <20211104141200.337794785@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211104141159.863820939@linuxfoundation.org>
References: <20211104141159.863820939@linuxfoundation.org>
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
@@ -2091,10 +2091,6 @@ static void __execlists_unhold(struct i9
 			if (p->flags & I915_DEPENDENCY_WEAK)
 				continue;
 
-			/* Propagate any change in error status */
-			if (rq->fence.error)
-				i915_request_set_error_once(w, rq->fence.error);
-
 			if (w->engine != rq->engine)
 				continue;
 


