Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 417882D9EE0
	for <lists+stable@lfdr.de>; Mon, 14 Dec 2020 19:25:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728099AbgLNSUM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Dec 2020 13:20:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:46968 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2502342AbgLNRif (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Dec 2020 12:38:35 -0500
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chris Wilson <chris@chris-wilson.co.uk>,
        Mika Kuoppala <mika.kuoppala@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>
Subject: [PATCH 5.9 094/105] drm/i915/gt: Cancel the preemption timeout on responding to it
Date:   Mon, 14 Dec 2020 18:29:08 +0100
Message-Id: <20201214172559.799394182@linuxfoundation.org>
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

commit 0fe8bf4d3edce7aad6c14b9d5d92ff54dc19f0ba upstream.

We currently presume that the engine reset is successful, cancelling the
expired preemption timer in the process. However, engine resets can
fail, leaving the timeout still pending and we will then respond to the
timeout again next time the tasklet fires. What we want is for the
failed engine reset to be promoted to a full device reset, which is
kicked by the heartbeat once the engine stops processing events.

Closes: https://gitlab.freedesktop.org/drm/intel/-/issues/1168
Fixes: 3a7a92aba8fb ("drm/i915/execlists: Force preemption")
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: <stable@vger.kernel.org> # v5.5+
Reviewed-by: Mika Kuoppala <mika.kuoppala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20201204151234.19729-2-chris@chris-wilson.co.uk
(cherry picked from commit d997e240ceecb4f732611985d3a939ad1bfc1893)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/gt/intel_lrc.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/i915/gt/intel_lrc.c
+++ b/drivers/gpu/drm/i915/gt/intel_lrc.c
@@ -3172,8 +3172,10 @@ static void execlists_submission_tasklet
 		spin_unlock_irqrestore(&engine->active.lock, flags);
 
 		/* Recheck after serialising with direct-submission */
-		if (unlikely(timeout && preempt_timeout(engine)))
+		if (unlikely(timeout && preempt_timeout(engine))) {
+			cancel_timer(&engine->execlists.preempt);
 			execlists_reset(engine, "preemption time out");
+		}
 	}
 }
 


