Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 986891C0A20
	for <lists+stable@lfdr.de>; Fri,  1 May 2020 00:11:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726784AbgD3WKv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Apr 2020 18:10:51 -0400
Received: from mail.zx2c4.com ([192.95.5.64]:43689 "EHLO mail.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726336AbgD3WKu (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 30 Apr 2020 18:10:50 -0400
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTP id 5b2fc6ad;
        Thu, 30 Apr 2020 21:58:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=from:to:cc
        :subject:date:message-id:mime-version:content-transfer-encoding;
         s=mail; bh=aJFrtx6lQiBbgvKXPLew//Y8Ivk=; b=lHSlfuScgujAfXJtyKYA
        1RfqTOsRlND8ZJBESNTBjJ3IbgUyajG5cOXCrHYltelH69//dV1x/XPeXX0CwW+k
        71LXbj/jJ2Gin8s/PKsrAEarzTAHG3r05Zr0d8J5ztjLV6r/9/J8jAVclxG9/AmO
        qZ3vfzKjL59/YIUuSJv9y42mR27ZmItkPkAlpMdz+8FG7km7xNnFbTc89TIpOvR3
        aaPDDUGNxwP+d2F4hwlEjS6TaRD05C47OxTxwwFssa43xeY+EVn9WzaMYHqxJycL
        x5ydiSJeP5h3jGy2+hWAoaEV8pvtNtW2yTu4lEqijWGcY5j/AsHNqEdYirvth3iL
        iQ==
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 4ee62b72 (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
        Thu, 30 Apr 2020 21:58:52 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     linux-kernel@vger.kernel.org, intel-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org, bigeasy@linutronix.de,
        tglx@linutronix.de, chris@chris-wilson.co.uk
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>, stable@vger.kernel.org
Subject: [PATCH] drm/i915: check to see if SIMD registers are available before using SIMD
Date:   Thu, 30 Apr 2020 16:10:16 -0600
Message-Id: <20200430221016.3866-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Sometimes it's not okay to use SIMD registers, the conditions for which
have changed subtly from kernel release to kernel release. Usually the
pattern is to check for may_use_simd() and then fallback to using
something slower in the unlikely case SIMD registers aren't available.
So, this patch fixes up i915's accelerated memcpy routines to fallback
to boring memcpy if may_use_simd() is false.

Cc: stable@vger.kernel.org
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
---
 drivers/gpu/drm/i915/i915_memcpy.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/gpu/drm/i915/i915_memcpy.c b/drivers/gpu/drm/i915/i915_memcpy.c
index fdd550405fd3..7c0e022586bc 100644
--- a/drivers/gpu/drm/i915/i915_memcpy.c
+++ b/drivers/gpu/drm/i915/i915_memcpy.c
@@ -24,6 +24,7 @@
 
 #include <linux/kernel.h>
 #include <asm/fpu/api.h>
+#include <asm/simd.h>
 
 #include "i915_memcpy.h"
 
@@ -38,6 +39,12 @@ static DEFINE_STATIC_KEY_FALSE(has_movntdqa);
 #ifdef CONFIG_AS_MOVNTDQA
 static void __memcpy_ntdqa(void *dst, const void *src, unsigned long len)
 {
+	if (unlikely(!may_use_simd())) {
+		memcpy(dst, src, len);
+		return;
+	}
+
+
 	kernel_fpu_begin();
 
 	while (len >= 4) {
@@ -67,6 +74,11 @@ static void __memcpy_ntdqa(void *dst, const void *src, unsigned long len)
 
 static void __memcpy_ntdqu(void *dst, const void *src, unsigned long len)
 {
+	if (unlikely(!may_use_simd())) {
+		memcpy(dst, src, len);
+		return;
+	}
+
 	kernel_fpu_begin();
 
 	while (len >= 4) {
-- 
2.26.2

