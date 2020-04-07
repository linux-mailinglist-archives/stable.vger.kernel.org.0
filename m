Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D14C01A073A
	for <lists+stable@lfdr.de>; Tue,  7 Apr 2020 08:26:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726934AbgDGG05 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Apr 2020 02:26:57 -0400
Received: from mail-pj1-f66.google.com ([209.85.216.66]:50930 "EHLO
        mail-pj1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726030AbgDGG05 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Apr 2020 02:26:57 -0400
Received: by mail-pj1-f66.google.com with SMTP id v13so322508pjb.0
        for <stable@vger.kernel.org>; Mon, 06 Apr 2020 23:26:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=FS3G1ShJi4gT+C9XSPET6pEmKQVhbKi/xe3AKM9kl8w=;
        b=bXvWxkwXOmKX7rm5V1HV3/fLIaJsQr8J9tmjlso+Ymj3CFEJ4s1Rv/YjoU0eNG22qA
         qRs6SkIEPX/ePAop6EsyCXLKMfIJILpx/RA7dDXkHJSwvEjWVubodE1z4+C5df+0rpRi
         IUmpe+clg9+jFKUEj8KhSCO+HHaCvufeFQIhh0lfc12VnAIzajgiVj8Apt99tfHoB3w/
         6ADR5chtjI17Gc6L1Ep0cTrpSsQHCDlnjpUA798fQhSCXQgtkvmxr1dZHCBIea98Tjdo
         7IMkRSMUxX+zRlLkU7Am57ec0H7yKQa+I4qDc6PuKuyw9K2f2onMZ6vt5xGOoxtEv6/M
         yHEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=FS3G1ShJi4gT+C9XSPET6pEmKQVhbKi/xe3AKM9kl8w=;
        b=oA+NypsggtiwJmF1E1PJrIuLdBoE5ZcAw5OU36Un6UWlr6NWpS0VwWue18swSDto7L
         7Hpw/q9vUSffvvkqYzAAP4As3QAwo2pRxL7SxW6nfpr2FBK92RrHKyQ95HUNK8uHR1Tl
         yxvA9p5uRDdywf46DcnRfZlbT8QNHxnU1jLs3W2qnHeNRysbEa5OmbOvb9iqqqFv2+xW
         tHF8P8KlIKUVST2dGmYF9C44up/qBgk7DmtURKFK9ECb17/gQxM5nRFFyDeDsZLG8nqt
         zfifQzeEPcDWaMiuuQQrXSwr4IU/PJ8vTVgU+nCVS7NnOFeON2Eepe8RngBDXujAXSVJ
         wQ7Q==
X-Gm-Message-State: AGi0PuZaSWh8uGf+uyK4gElImSTwZa1YwA4dCAH14mFU1q9p5inCZR1C
        zncSc6BKygXMqoFj6Z93nNCb411x
X-Google-Smtp-Source: APiQypK1PqINDyWz56vaHNvXf6vjIo+mGPsFkDoaQZB7V6S9EmcS6z0cOWlFaJFhAz9DF8fNwnkUNQ==
X-Received: by 2002:a17:90a:1acd:: with SMTP id p71mr988655pjp.112.1586240815477;
        Mon, 06 Apr 2020 23:26:55 -0700 (PDT)
Received: from sultan-box.localdomain (static-198-54-129-52.cust.tzulo.com. [198.54.129.52])
        by smtp.gmail.com with ESMTPSA id y9sm13554620pfo.135.2020.04.06.23.26.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Apr 2020 23:26:54 -0700 (PDT)
From:   Sultan Alsawaf <sultan@kerneltoast.com>
X-Google-Original-From: Sultan Alsawaf
To:     stable@vger.kernel.org
Cc:     Jani Nikula <jani.nikula@linux.intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        Sultan Alsawaf <sultan@kerneltoast.com>
Subject: [PATCH 1/1] drm/i915: Fix ref->mutex deadlock in i915_active_wait()
Date:   Mon,  6 Apr 2020 23:26:22 -0700
Message-Id: <20200407062622.6443-2-sultan@kerneltoast.com>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200407062622.6443-1-sultan@kerneltoast.com>
References: <20200407062622.6443-1-sultan@kerneltoast.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sultan Alsawaf <sultan@kerneltoast.com>

The following deadlock exists in i915_active_wait() due to a double lock
on ref->mutex (call chain listed in order from top to bottom):
 i915_active_wait();
 mutex_lock_interruptible(&ref->mutex); <-- ref->mutex first acquired
 i915_active_request_retire();
 node_retire();
 active_retire();
 mutex_lock_nested(&ref->mutex, SINGLE_DEPTH_NESTING); <-- DEADLOCK

Fix the deadlock by skipping the second ref->mutex lock when
active_retire() is called through i915_active_request_retire().

Fixes: 12c255b5dad1 ("drm/i915: Provide an i915_active.acquire callback")
Cc: <stable@vger.kernel.org> # 5.4.x
Signed-off-by: Sultan Alsawaf <sultan@kerneltoast.com>
---
 drivers/gpu/drm/i915/i915_active.c | 27 +++++++++++++++++++++++----
 drivers/gpu/drm/i915/i915_active.h |  4 ++--
 2 files changed, 25 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/i915/i915_active.c b/drivers/gpu/drm/i915/i915_active.c
index 48e16ad93bbd..cfc77c08a273 100644
--- a/drivers/gpu/drm/i915/i915_active.c
+++ b/drivers/gpu/drm/i915/i915_active.c
@@ -120,13 +120,17 @@ static inline void debug_active_assert(struct i915_active *ref) { }
 
 #endif
 
+#define I915_ACTIVE_RETIRE_NOLOCK BIT(0)
+
 static void
 __active_retire(struct i915_active *ref)
 {
 	struct active_node *it, *n;
 	struct rb_root root;
 	bool retire = false;
+	unsigned long bits;
 
+	ref = ptr_unpack_bits(ref, &bits, 2);
 	lockdep_assert_held(&ref->mutex);
 
 	/* return the unused nodes to our slabcache -- flushing the allocator */
@@ -138,7 +142,8 @@ __active_retire(struct i915_active *ref)
 		retire = true;
 	}
 
-	mutex_unlock(&ref->mutex);
+	if (!(bits & I915_ACTIVE_RETIRE_NOLOCK))
+		mutex_unlock(&ref->mutex);
 	if (!retire)
 		return;
 
@@ -155,13 +160,18 @@ __active_retire(struct i915_active *ref)
 static void
 active_retire(struct i915_active *ref)
 {
+	struct i915_active *ref_packed = ref;
+	unsigned long bits;
+
+	ref = ptr_unpack_bits(ref, &bits, 2);
 	GEM_BUG_ON(!atomic_read(&ref->count));
 	if (atomic_add_unless(&ref->count, -1, 1))
 		return;
 
 	/* One active may be flushed from inside the acquire of another */
-	mutex_lock_nested(&ref->mutex, SINGLE_DEPTH_NESTING);
-	__active_retire(ref);
+	if (!(bits & I915_ACTIVE_RETIRE_NOLOCK))
+		mutex_lock_nested(&ref->mutex, SINGLE_DEPTH_NESTING);
+	__active_retire(ref_packed);
 }
 
 static void
@@ -170,6 +180,14 @@ node_retire(struct i915_active_request *base, struct i915_request *rq)
 	active_retire(node_from_active(base)->ref);
 }
 
+static void
+node_retire_nolock(struct i915_active_request *base, struct i915_request *rq)
+{
+	struct i915_active *ref = node_from_active(base)->ref;
+
+	active_retire(ptr_pack_bits(ref, I915_ACTIVE_RETIRE_NOLOCK, 2));
+}
+
 static struct i915_active_request *
 active_instance(struct i915_active *ref, struct intel_timeline *tl)
 {
@@ -421,7 +439,8 @@ int i915_active_wait(struct i915_active *ref)
 			break;
 		}
 
-		err = i915_active_request_retire(&it->base, BKL(ref));
+		err = i915_active_request_retire(&it->base, BKL(ref),
+						 node_retire_nolock);
 		if (err)
 			break;
 	}
diff --git a/drivers/gpu/drm/i915/i915_active.h b/drivers/gpu/drm/i915/i915_active.h
index f95058f99057..0ad7ef60d15f 100644
--- a/drivers/gpu/drm/i915/i915_active.h
+++ b/drivers/gpu/drm/i915/i915_active.h
@@ -309,7 +309,7 @@ i915_active_request_isset(const struct i915_active_request *active)
  */
 static inline int __must_check
 i915_active_request_retire(struct i915_active_request *active,
-			   struct mutex *mutex)
+			   struct mutex *mutex, i915_active_retire_fn retire)
 {
 	struct i915_request *request;
 	long ret;
@@ -327,7 +327,7 @@ i915_active_request_retire(struct i915_active_request *active,
 	list_del_init(&active->link);
 	RCU_INIT_POINTER(active->request, NULL);
 
-	active->retire(active, request);
+	retire(active, request);
 
 	return 0;
 }
-- 
2.26.0

