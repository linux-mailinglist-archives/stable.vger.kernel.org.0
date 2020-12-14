Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0C612D9EC9
	for <lists+stable@lfdr.de>; Mon, 14 Dec 2020 19:20:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2440782AbgLNSSr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Dec 2020 13:18:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:49636 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2502365AbgLNRi7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Dec 2020 12:38:59 -0500
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chris Wilson <chris@chris-wilson.co.uk>,
        Mika Kuoppala <mika.kuoppala@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>
Subject: [PATCH 5.9 093/105] drm/i915/gt: Ignore repeated attempts to suspend request flow across reset
Date:   Mon, 14 Dec 2020 18:29:07 +0100
Message-Id: <20201214172559.749769840@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201214172555.280929671@linuxfoundation.org>
References: <20201214172555.280929671@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chris Wilson <chris@chris-wilson.co.uk>

commit 5419d93ffd774127b195b8543b063b2b4fa5aea9 upstream.

Before reseting the engine, we suspend the execution of the guilty
request, so that we can continue execution with a new context while we
slowly compress the captured error state for the guilty context. However,
if the reset fails, we will promptly attempt to reset the same request
again, and discover the ongoing capture. Ignore the second attempt to
suspend and capture the same request.

Closes: https://gitlab.freedesktop.org/drm/intel/-/issues/1168
Fixes: 32ff621fd744 ("drm/i915/gt: Allow temporary suspension of inflight requests")
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: <stable@vger.kernel.org> # v5.7+
Reviewed-by: Mika Kuoppala <mika.kuoppala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20201204151234.19729-1-chris@chris-wilson.co.uk
(cherry picked from commit b969540500bce60cf1cdfff5464388af32b9a553)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/gt/intel_lrc.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/gpu/drm/i915/gt/intel_lrc.c
+++ b/drivers/gpu/drm/i915/gt/intel_lrc.c
@@ -2788,6 +2788,9 @@ static void __execlists_hold(struct i915
 static bool execlists_hold(struct intel_engine_cs *engine,
 			   struct i915_request *rq)
 {
+	if (i915_request_on_hold(rq))
+		return false;
+
 	spin_lock_irq(&engine->active.lock);
 
 	if (i915_request_completed(rq)) { /* too late! */


