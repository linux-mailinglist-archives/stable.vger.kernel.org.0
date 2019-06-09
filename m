Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1BE473AAB4
	for <lists+stable@lfdr.de>; Sun,  9 Jun 2019 19:21:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730432AbfFIQq0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Jun 2019 12:46:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:44610 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730426AbfFIQqZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 9 Jun 2019 12:46:25 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8BD342081C;
        Sun,  9 Jun 2019 16:46:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560098785;
        bh=ROIPTP72i2EtjIl4JUnQR11SQqZXGgz2RDHIzQPV2EM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YP1CeFeJEcFHDhXis58jnfCOncGS9FmNdfAZ55NdJ9oBfbFpl8qY8xZ/qhUobJu4l
         PPau9uoetCpsQU1wf+8Qfm7H5MNohmm0s4i6P9rLG0pIFbjBKKuCxPSFWt3tyV8o0N
         ifz688aG75ioUGL3dqQL0Wvi6K8NvEbKYWBhNPlI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chris Wilson <chris@chris-wilson.co.uk>,
        Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Subject: [PATCH 5.1 60/70] drm/i915: Fix I915_EXEC_RING_MASK
Date:   Sun,  9 Jun 2019 18:42:11 +0200
Message-Id: <20190609164132.502693982@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190609164127.541128197@linuxfoundation.org>
References: <20190609164127.541128197@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chris Wilson <chris@chris-wilson.co.uk>

commit d90c06d57027203f73021bb7ddb30b800d65c636 upstream.

This was supposed to be a mask of all known rings, but it is being used
by execbuffer to filter out invalid rings, and so is instead mapping high
unused values onto valid rings. Instead of a mask of all known rings,
we need it to be the mask of all possible rings.

Fixes: 549f7365820a ("drm/i915: Enable SandyBridge blitter ring")
Fixes: de1add360522 ("drm/i915: Decouple execbuf uAPI from internal implementation")
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Cc: <stable@vger.kernel.org> # v4.6+
Reviewed-by: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20190301140404.26690-21-chris@chris-wilson.co.uk
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/uapi/drm/i915_drm.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/uapi/drm/i915_drm.h
+++ b/include/uapi/drm/i915_drm.h
@@ -972,7 +972,7 @@ struct drm_i915_gem_execbuffer2 {
 	 * struct drm_i915_gem_exec_fence *fences.
 	 */
 	__u64 cliprects_ptr;
-#define I915_EXEC_RING_MASK              (7<<0)
+#define I915_EXEC_RING_MASK              (0x3f)
 #define I915_EXEC_DEFAULT                (0<<0)
 #define I915_EXEC_RENDER                 (1<<0)
 #define I915_EXEC_BSD                    (2<<0)


