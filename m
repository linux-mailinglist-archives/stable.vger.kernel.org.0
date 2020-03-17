Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EE64B18808A
	for <lists+stable@lfdr.de>; Tue, 17 Mar 2020 12:11:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727161AbgCQLLH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Mar 2020 07:11:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:54170 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728543AbgCQLLH (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Mar 2020 07:11:07 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A1FAF20658;
        Tue, 17 Mar 2020 11:11:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584443465;
        bh=mFKKfWcFB/9Jb1MTNHl5+8C5MTPIV+2hOeqpObc2q2g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ihJe8eIHDMo1HYKXbMaVvBkayBnCgFcOaRNYecHIL6YqxAzmt0cHicIMvSG34tXld
         uRdtCNHkh0u3eg3Xe64EkWUrjRtwTJhvuweGzrC9tfYJhKB6VmamnSMpqyxRdxMOeu
         jOspd6Uxri4lBg+hUI715IqLttJag7PfeKe7tNa8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chris Wilson <chris@chris-wilson.co.uk>,
        Tvrtko Ursulin <tvrtko.ursulin@intel.com>,
        Mika Kuoppala <mika.kuoppala@linux.intel.com>,
        Matthew Auld <matthew.auld@intel.com>,
        Jani Nikula <jani.nikula@intel.com>
Subject: [PATCH 5.5 089/151] drm/i915/gt: Close race between cacheline_retire and free
Date:   Tue, 17 Mar 2020 11:54:59 +0100
Message-Id: <20200317103332.771651153@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200317103326.593639086@linuxfoundation.org>
References: <20200317103326.593639086@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chris Wilson <chris@chris-wilson.co.uk>

commit 8ea6bb8e4d47e07518e5dba4f5cb77e210f0df82 upstream.

If the cacheline may still be busy, atomically mark it for future
release, and only if we can determine that it will never be used again,
immediately free it.

Closes: https://gitlab.freedesktop.org/drm/intel/issues/1392
Fixes: ebece7539242 ("drm/i915: Keep timeline HWSP allocated until idle across the system")
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Cc: Mika Kuoppala <mika.kuoppala@linux.intel.com>
Cc: Matthew Auld <matthew.auld@intel.com>
Reviewed-by: Mika Kuoppala <mika.kuoppala@linux.intel.com>
Cc: <stable@vger.kernel.org> # v5.2+
Link: https://patchwork.freedesktop.org/patch/msgid/20200306154647.3528345-1-chris@chris-wilson.co.uk
(cherry picked from commit 2d4bd971f5baa51418625f379a69f5d58b5a0450)
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/gt/intel_timeline.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/i915/gt/intel_timeline.c
+++ b/drivers/gpu/drm/i915/gt/intel_timeline.c
@@ -197,11 +197,15 @@ static void cacheline_release(struct int
 
 static void cacheline_free(struct intel_timeline_cacheline *cl)
 {
+	if (!i915_active_acquire_if_busy(&cl->active)) {
+		__idle_cacheline_free(cl);
+		return;
+	}
+
 	GEM_BUG_ON(ptr_test_bit(cl->vaddr, CACHELINE_FREE));
 	cl->vaddr = ptr_set_bit(cl->vaddr, CACHELINE_FREE);
 
-	if (i915_active_is_idle(&cl->active))
-		__idle_cacheline_free(cl);
+	i915_active_release(&cl->active);
 }
 
 int intel_timeline_init(struct intel_timeline *timeline,


