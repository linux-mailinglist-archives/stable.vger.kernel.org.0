Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07C642F9EB8
	for <lists+stable@lfdr.de>; Mon, 18 Jan 2021 12:51:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390929AbhARLuT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Jan 2021 06:50:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:39540 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390482AbhARLqp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Jan 2021 06:46:45 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5E8E9222B3;
        Mon, 18 Jan 2021 11:46:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610970389;
        bh=Gg6PwU+DaG0jicgYy+tMOcNo0mdKuM1yOqb00f8dMWU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z6Htn9ti3uCqx8ouSl1A0DgYfwVFc63WIk+lreu01aem2AKoJPPQ/PSf10ZiGlrWt
         sZ3pQz1jN7CP72D1jO1oqJ15DVi47md813N2SNyWr19VsVKP2+U0DHN0NtS0Hq11am
         b7LKj85qR8WZrT05dxt6dbtgSosWDK4sc3+bDLZI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chris Wilson <chris@chris-wilson.co.uk>,
        Mika Kuoppala <mika.kuoppala@linux.intel.com>,
        Prathap Kumar Valsan <prathap.kumar.valsan@intel.com>,
        Akeem G Abodunrin <akeem.g.abodunrin@intel.com>,
        Bloomfield Jon <jon.bloomfield@intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Jani Nikula <jani.nikula@intel.com>
Subject: [PATCH 5.10 142/152] drm/i915/gt: Restore clear-residual mitigations for Ivybridge, Baytrail
Date:   Mon, 18 Jan 2021 12:35:17 +0100
Message-Id: <20210118113359.526297329@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210118113352.764293297@linuxfoundation.org>
References: <20210118113352.764293297@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chris Wilson <chris@chris-wilson.co.uk>

commit 09aa9e45863e9e25dfbf350bae89fc3c2964482c upstream.

The mitigation is required for all gen7 platforms, now that it does not
cause GPU hangs, restore it for Ivybridge and Baytrail.

Fixes: 47f8253d2b89 ("drm/i915/gen7: Clear all EU/L3 residual contexts")
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Mika Kuoppala <mika.kuoppala@linux.intel.com>
Cc: Prathap Kumar Valsan <prathap.kumar.valsan@intel.com>
Cc: Akeem G Abodunrin <akeem.g.abodunrin@intel.com>
Cc: Bloomfield Jon <jon.bloomfield@intel.com>
Reviewed-by: Akeem G Abodunrin <akeem.g.abodunrin@intel.com>
Reviewed-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20210111225220.3483-2-chris@chris-wilson.co.uk
(cherry picked from commit 008ead6ef8f588a8c832adfe9db201d9be5fd410)
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/gt/intel_ring_submission.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/i915/gt/intel_ring_submission.c
+++ b/drivers/gpu/drm/i915/gt/intel_ring_submission.c
@@ -1291,7 +1291,7 @@ int intel_ring_submission_setup(struct i
 
 	GEM_BUG_ON(timeline->hwsp_ggtt != engine->status_page.vma);
 
-	if (IS_HASWELL(engine->i915) && engine->class == RENDER_CLASS) {
+	if (IS_GEN(engine->i915, 7) && engine->class == RENDER_CLASS) {
 		err = gen7_ctx_switch_bb_init(engine);
 		if (err)
 			goto err_ring_unpin;


