Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E416319CE14
	for <lists+stable@lfdr.de>; Fri,  3 Apr 2020 03:13:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388971AbgDCBNw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Apr 2020 21:13:52 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:43821 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731783AbgDCBNw (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Apr 2020 21:13:52 -0400
Received: by mail-pf1-f193.google.com with SMTP id f206so2651365pfa.10;
        Thu, 02 Apr 2020 18:13:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=a4w6WNUXo0OrnIhl+pN95pim8+mHdrQuMjAwNVyujGg=;
        b=Cl6oxazqwil6UKwahFv6KFn7LXSZt8iHP/QsrKl6rvYj5FScx9Cl79/OqvpItS+e1a
         wfJB3vjipRbG10zLOKy7Rm2AuH3ZEMPQn896o7k5sktqj2cbxYZSzsnQa11J/Y+pBfG0
         5MOFkx3gvmZrGUKFqUzPhDOLB6WQHxdBFOrsMezSZ8tn5OGpAvK4+JPfw+OKDqI7Dca5
         4Cs+TEcvicUO5XVfCbyDSTS6SmXnao7fILJ5ZmBQMda2Ai0hO0fpB7KKRUhNiEyB2edg
         8AA+K29FMj3XBQeyw9uOujT7vCxpmH1kM3YxM6HbXhF38qPxs/0YpkY7uEvPpmrdbmxj
         1QgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :mime-version:content-transfer-encoding;
        bh=a4w6WNUXo0OrnIhl+pN95pim8+mHdrQuMjAwNVyujGg=;
        b=UhsK3QTrsJ8Elsw7vfx7NKuieXKmv+ZZEn5UWkfFWtmSgXQsimRXZVTMRfadDo8jaF
         Bpo1qGUeFAwAIvg+o6Nj+YJIKsFDYWMlFr3SGGzkUB5tNeyZbtrf8zM0QrhPcRz/h3Nb
         dX0WpEX0RVNf4uN63eTFgzKG9lgOwkAhsG+FIGIiVsyRTQXUshgtOZiXCJgrDcgr5psH
         NbuuXyUVDd0Sqx0LnbDgWqqHET82cO1MrorOTbpGmwNgL2Z2xixcv977sjpzGW3SsIDO
         zm8/B+1HE6OO2rvQze1rMo52sRGJ/0WPlXwlej0ge8mTMd3gsUkyIElrfccYH4TF7sIw
         Y4dw==
X-Gm-Message-State: AGi0Publusf45axHbe/Pqk/dkaNuxPcwm4t8QeTZau8r1SJr+1GKzJHm
        J9x7stc2uP1WZYoRiMTFDTw=
X-Google-Smtp-Source: APiQypK39T0+9ouLdDrpyYewtv4qEZi+u8NpoIYxybwCP33HGcnVFkE1wM5WuBtYGZekQehZhljX/Q==
X-Received: by 2002:a62:7c82:: with SMTP id x124mr6202533pfc.280.1585876430597;
        Thu, 02 Apr 2020 18:13:50 -0700 (PDT)
Received: from sultan-box.localdomain (static-198-54-129-52.cust.tzulo.com. [198.54.129.52])
        by smtp.gmail.com with ESMTPSA id b189sm4630053pfa.209.2020.04.02.18.13.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Apr 2020 18:13:49 -0700 (PDT)
From:   Sultan Alsawaf <sultan@kerneltoast.com>
X-Google-Original-From: Sultan Alsawaf
Cc:     Sultan Alsawaf <sultan@kerneltoast.com>, stable@vger.kernel.org,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Matthew Auld <matthew.auld@intel.com>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] drm/i915: Fix use-after-free due to intel_context_pin/unpin race
Date:   Thu,  2 Apr 2020 18:13:18 -0700
Message-Id: <20200403011318.2280-1-sultan@kerneltoast.com>
X-Mailer: git-send-email 2.26.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sultan Alsawaf <sultan@kerneltoast.com>

The retire and active callbacks can run simultaneously, allowing
intel_context_pin() and intel_context_unpin() to run at the same time,
trashing the ring and page tables. In 5.4, this was more noticeable
because intel_ring_unpin() would set ring->vaddr to NULL and cause a
clean NULL-pointer-dereference panic, but in newer kernels the
use-after-free goes unnoticed.

The NULL-pointer-dereference looks like this:
BUG: unable to handle page fault for address: 0000000000003448
RIP: 0010:gen8_emit_flush_render+0x163/0x190
Call Trace:
 execlists_request_alloc+0x25/0x40
 __i915_request_create+0x1f4/0x2c0
 i915_request_create+0x71/0xc0
 i915_gem_do_execbuffer+0xb98/0x1a80
 ? preempt_count_add+0x68/0xa0
 ? _raw_spin_lock+0x13/0x30
 ? _raw_spin_unlock+0x16/0x30
 i915_gem_execbuffer2_ioctl+0x1de/0x3c0
 ? i915_gem_busy_ioctl+0x7f/0x1d0
 ? i915_gem_execbuffer_ioctl+0x2d0/0x2d0
 drm_ioctl_kernel+0xb2/0x100
 drm_ioctl+0x209/0x360
 ? i915_gem_execbuffer_ioctl+0x2d0/0x2d0
 ksys_ioctl+0x87/0xc0
 __x64_sys_ioctl+0x16/0x20
 do_syscall_64+0x4e/0x150
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

Protect the retire callback with ref->mutex to complement the active
callback and fix the corruption.

Fixes: 12c255b5dad1 ("drm/i915: Provide an i915_active.acquire callback")
Cc: <stable@vger.kernel.org>
Signed-off-by: Sultan Alsawaf <sultan@kerneltoast.com>
---
 drivers/gpu/drm/i915/i915_active.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/i915/i915_active.c b/drivers/gpu/drm/i915/i915_active.c
index c4048628188a..0478bcf061b5 100644
--- a/drivers/gpu/drm/i915/i915_active.c
+++ b/drivers/gpu/drm/i915/i915_active.c
@@ -148,8 +148,10 @@ __active_retire(struct i915_active *ref)
 	spin_unlock_irqrestore(&ref->tree_lock, flags);
 
 	/* After the final retire, the entire struct may be freed */
+	mutex_lock(&ref->mutex);
 	if (ref->retire)
 		ref->retire(ref);
+	mutex_unlock(&ref->mutex);
 
 	/* ... except if you wait on it, you must manage your own references! */
 	wake_up_var(ref);
-- 
2.26.0

