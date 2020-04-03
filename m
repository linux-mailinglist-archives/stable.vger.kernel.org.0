Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0DA4A19CF51
	for <lists+stable@lfdr.de>; Fri,  3 Apr 2020 06:30:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726999AbgDCEaQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Apr 2020 00:30:16 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:40594 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725851AbgDCEaP (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Apr 2020 00:30:15 -0400
Received: by mail-pl1-f196.google.com with SMTP id h11so2216914plk.7;
        Thu, 02 Apr 2020 21:30:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=sja6m3Mw9LjC7BK1j0HHPXQY4FKYL2Fx6diFCtiS1PE=;
        b=h19/LNG3aBIRLqbyGckbtmcU+95XD0pxnfS64bhodTfzfjfXtnq/TJ+KQUfwxKbkb2
         kkgsoBc0I4Esz0idHIfXX/maFUNkfgjkxmvwWyEHF/tK7o6GzBSQKbWx15oClB8LB0YW
         zfEkUEWqzsljCZu9yhzAomn5U5idlMHsYHL0cjeoQ0+lCpgvmUdVNuNnD1axnRaeqAih
         +R/MIFoqiTu794LHqc04TGNEU9rTEuqOoFWKgez+AbafEHmyK/4s7DGBYfx/bfEcg/K2
         CwSr78KY+rGtCsqe8IEmG6QvsDePGLfBLBMewml61bnXUTmCpjjqDUKsON5NLcjL/FQP
         Ty5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=sja6m3Mw9LjC7BK1j0HHPXQY4FKYL2Fx6diFCtiS1PE=;
        b=ijY8UUISPPM6URsJuhnwF9j3VLekN8yTJ1qAjphfQkAxLK7HDYyUAq2mARkEMHmPQK
         z0u5hBIqrJC63IXy9hY23Bj0jHjBhUXs0lovBEBu9FKcSlaH8QVHVxyjVE8+AW3Kga5j
         D4gGU275ydK9VznpFDqN7VU/5dVUh5s+a/HiuhWq+gzrAcunmuND5DKq2sqW1SZWlD0R
         9nFVJq3+VS4BRzg/MW3ktkT+v9WaHlG9yohRzzSnQe3c0FDjHTZvh3BLYNU/JNPNtjsj
         nSQGpvIAVfvkxMpr9CvlN7pc2EySgwV2zIZ1V2V9mJjJCxW5Eq7n27Hx4BkBsW7161n6
         O2dg==
X-Gm-Message-State: AGi0PuaJ1o2OSVqneh2UEfnLn19NS+AhFAmohO1USloxzMAkIT9bmobU
        u9CPoOYPwIYx5ujtHz5z5YDLCVCy
X-Google-Smtp-Source: APiQypKymBolWpSQuKDcfRDNRhf9oi/2EuBelOfhbRc/eR/CsqYbdLKKIyexzCRlujj5Uqa9h055gQ==
X-Received: by 2002:a17:902:ac8d:: with SMTP id h13mr6193580plr.267.1585888214837;
        Thu, 02 Apr 2020 21:30:14 -0700 (PDT)
Received: from sultan-box.localdomain (static-198-54-129-52.cust.tzulo.com. [198.54.129.52])
        by smtp.gmail.com with ESMTPSA id k20sm4368281pgn.62.2020.04.02.21.30.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Apr 2020 21:30:14 -0700 (PDT)
From:   Sultan Alsawaf <sultan@kerneltoast.com>
X-Google-Original-From: Sultan Alsawaf
Cc:     Sultan Alsawaf <sultan@kerneltoast.com>, stable@vger.kernel.org,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Tvrtko Ursulin <tvrtko.ursulin@intel.com>,
        Mika Kuoppala <mika.kuoppala@linux.intel.com>,
        Matthew Auld <matthew.auld@intel.com>,
        Lionel Landwerlin <lionel.g.landwerlin@intel.com>,
        intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2] drm/i915: Fix use-after-free due to intel_context_pin/unpin race
Date:   Thu,  2 Apr 2020 21:29:44 -0700
Message-Id: <20200403042948.2533-1-sultan@kerneltoast.com>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200403011318.2280-1-sultan@kerneltoast.com>
References: <20200403011318.2280-1-sultan@kerneltoast.com>
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

Protect __intel_context_retire() with active->mutex (i.e., ref->mutex)
to complement the active callback and fix the corruption.

Fixes: 12c255b5dad1 ("drm/i915: Provide an i915_active.acquire callback")
Cc: <stable@vger.kernel.org>
Signed-off-by: Sultan Alsawaf <sultan@kerneltoast.com>
---
v2: Reduce the scope of the mutex lock to only __intel_context_retire()
    and mark it as a function that may sleep so it doesn't run in
    atomic context

 drivers/gpu/drm/i915/gt/intel_context.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/i915/gt/intel_context.c b/drivers/gpu/drm/i915/gt/intel_context.c
index 57e8a051ddc2..9b9be8058881 100644
--- a/drivers/gpu/drm/i915/gt/intel_context.c
+++ b/drivers/gpu/drm/i915/gt/intel_context.c
@@ -221,6 +221,7 @@ static void __intel_context_retire(struct i915_active *active)
 
 	CE_TRACE(ce, "retire\n");
 
+	mutex_lock(&active->mutex);
 	set_bit(CONTEXT_VALID_BIT, &ce->flags);
 	if (ce->state)
 		__context_unpin_state(ce->state);
@@ -229,6 +230,7 @@ static void __intel_context_retire(struct i915_active *active)
 	__ring_retire(ce->ring);
 
 	intel_context_put(ce);
+	mutex_unlock(&active->mutex);
 }
 
 static int __intel_context_active(struct i915_active *active)
@@ -288,7 +290,8 @@ intel_context_init(struct intel_context *ce,
 	mutex_init(&ce->pin_mutex);
 
 	i915_active_init(&ce->active,
-			 __intel_context_active, __intel_context_retire);
+			 __intel_context_active,
+			 i915_active_may_sleep(__intel_context_retire));
 }
 
 void intel_context_fini(struct intel_context *ce)
-- 
2.26.0

