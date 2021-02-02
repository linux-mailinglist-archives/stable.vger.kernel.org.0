Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C914830CB6A
	for <lists+stable@lfdr.de>; Tue,  2 Feb 2021 20:24:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233461AbhBBTXq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Feb 2021 14:23:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:45176 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233588AbhBBOAP (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Feb 2021 09:00:15 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0AB9864FF9;
        Tue,  2 Feb 2021 13:46:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612273612;
        bh=FLazDel+EGWbez2TXlyBvQQCh0fX2MJ10fHvld50euw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hbUEy0DhrezvWEhg7+YDySBiV9eER+/77nCDQpxlj4s777Wn3vJZltMZ5GlZbTQCR
         C51jbD/fYGwVEEqCpv9VlKdSE5BCuysmJAQL5nomRsZDzeQv5oAyPpBh4Tg1BhYsoO
         S6MGAH6x8PXTHLHqbFIhGtvUxUtZSuTxsDktmkq8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tvrtko Ursulin <tvrtko.ursulin@intel.com>,
        Umesh Nerlige Ramappa <umesh.nerlige.ramappa@intel.com>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Jani Nikula <jani.nikula@intel.com>
Subject: [PATCH 5.4 28/61] drm/i915: Check for all subplatform bits
Date:   Tue,  2 Feb 2021 14:38:06 +0100
Message-Id: <20210202132947.660366169@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210202132946.480479453@linuxfoundation.org>
References: <20210202132946.480479453@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Umesh Nerlige Ramappa <umesh.nerlige.ramappa@intel.com>

commit 8f6d08c9af284d74276da6681348e4673f13caea upstream.

Current code is checking only 2 bits in the subplatform, but actually 3
bits are allocated for the field. Check all 3 bits.

Fixes: 805446c8347c ("drm/i915: Introduce concept of a sub-platform")
Cc: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Signed-off-by: Umesh Nerlige Ramappa <umesh.nerlige.ramappa@intel.com>
Reviewed-by: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Link: https://patchwork.freedesktop.org/patch/msgid/20210121161936.746591-1-tvrtko.ursulin@linux.intel.com
(cherry picked from commit 27b695ee1af9bb36605e67055874ec081306ac28)
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/i915_drv.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/i915/i915_drv.h
+++ b/drivers/gpu/drm/i915/i915_drv.h
@@ -1894,7 +1894,7 @@ intel_subplatform(const struct intel_run
 {
 	const unsigned int pi = __platform_mask_index(info, p);
 
-	return info->platform_mask[pi] & INTEL_SUBPLATFORM_BITS;
+	return info->platform_mask[pi] & ((1 << INTEL_SUBPLATFORM_BITS) - 1);
 }
 
 static __always_inline bool


