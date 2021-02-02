Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE19430C01E
	for <lists+stable@lfdr.de>; Tue,  2 Feb 2021 14:50:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232750AbhBBNtx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Feb 2021 08:49:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:38220 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232665AbhBBNrt (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Feb 2021 08:47:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6742A64F9A;
        Tue,  2 Feb 2021 13:42:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612273322;
        bh=hl2DDHucC2R88wa5cqog4n3A36paPwNoybWeEjJ60iU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gLqalmvHVp6+4BiArfKem8hQkdlWVqf1kLjrQBoU77Ykc7pBzy9sVkfbIIu9lUgCD
         71zAOgW9dzI+z9TjhXN3gtPMA/Xh2MMXCRymyFzA+Ag+VDn/tEcAKeZl29S0UBMo2O
         +4DERvlJeGisSIjmd4QohWBxliRHzFVghgtnT7ls=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tvrtko Ursulin <tvrtko.ursulin@intel.com>,
        Umesh Nerlige Ramappa <umesh.nerlige.ramappa@intel.com>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Jani Nikula <jani.nikula@intel.com>
Subject: [PATCH 5.10 063/142] drm/i915: Check for all subplatform bits
Date:   Tue,  2 Feb 2021 14:37:06 +0100
Message-Id: <20210202133000.318913172@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210202132957.692094111@linuxfoundation.org>
References: <20210202132957.692094111@linuxfoundation.org>
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
@@ -1347,7 +1347,7 @@ intel_subplatform(const struct intel_run
 {
 	const unsigned int pi = __platform_mask_index(info, p);
 
-	return info->platform_mask[pi] & INTEL_SUBPLATFORM_BITS;
+	return info->platform_mask[pi] & ((1 << INTEL_SUBPLATFORM_BITS) - 1);
 }
 
 static __always_inline bool


