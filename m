Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 825343AA44
	for <lists+stable@lfdr.de>; Sun,  9 Jun 2019 19:18:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730985AbfFIQuw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Jun 2019 12:50:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:50850 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731800AbfFIQuv (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 9 Jun 2019 12:50:51 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BFFB5205ED;
        Sun,  9 Jun 2019 16:50:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560099051;
        bh=ADXFPHjgl+ccxMtpa4MvsrasXGZXkMLCvfHm6GALKhA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=chxZFgeM4Y2x6Eo/jxPIwGmbREQn9ULSMqIY4rT2wS5OxYjLk+6wI9qF8G0VDB0Ke
         ZvA5mJFnpngUgJhZBx7mhopJ8cdtmUGcgvriC+64u6d1izoUiE+MQyF7Fj3hOxIYdZ
         FvBya/nMzzPsW2FZ7YyqlXB6UYVnXDizb2CfbH70=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chris Wilson <chris@chris-wilson.co.uk>,
        Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Subject: [PATCH 4.14 30/35] drm/i915: Fix I915_EXEC_RING_MASK
Date:   Sun,  9 Jun 2019 18:42:36 +0200
Message-Id: <20190609164127.242175368@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190609164125.377368385@linuxfoundation.org>
References: <20190609164125.377368385@linuxfoundation.org>
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
@@ -853,7 +853,7 @@ struct drm_i915_gem_execbuffer2 {
 	 * struct drm_i915_gem_exec_fence *fences.
 	 */
 	__u64 cliprects_ptr;
-#define I915_EXEC_RING_MASK              (7<<0)
+#define I915_EXEC_RING_MASK              (0x3f)
 #define I915_EXEC_DEFAULT                (0<<0)
 #define I915_EXEC_RENDER                 (1<<0)
 #define I915_EXEC_BSD                    (2<<0)


