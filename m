Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2CD29B5C56
	for <lists+stable@lfdr.de>; Wed, 18 Sep 2019 08:25:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730125AbfIRGZ2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Sep 2019 02:25:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:46418 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730119AbfIRGZ2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 18 Sep 2019 02:25:28 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2D97021920;
        Wed, 18 Sep 2019 06:25:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568787927;
        bh=ZTUphmE03XaBp9fDIUsiN3a9wnL7X2zb0W0aAFjFfLA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mNQeiOhmWNv5dILYSRAe3CqtPIHPRK99kznBJ0yQ2Cb2SbNdvqEciO62HL0RjCxiM
         JA6w85qCrTLN7U7VWAZLKGXWUO3vkIXVf7M/C7mG3C5ptNgaPr5AX81GenMzaDzxEu
         wVp9hvvIe/EuKR5gOyBOmjieU7B80exNLdhjLwz8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jason Ekstrand <jason@jlekstrand.net>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        denys.kostin@globallogic.com,
        Mika Kuoppala <mika.kuoppala@linux.intel.com>,
        Jani Nikula <jani.nikula@intel.com>
Subject: [PATCH 5.2 34/85] drm/i915: Restore relaxed padding (OCL_OOB_SUPPRES_ENABLE) for skl+
Date:   Wed, 18 Sep 2019 08:18:52 +0200
Message-Id: <20190918061235.226630357@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190918061234.107708857@linuxfoundation.org>
References: <20190918061234.107708857@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chris Wilson <chris@chris-wilson.co.uk>

commit 2eb0964eec5f1d99f9eaf4963eee267acc72b615 upstream.

This bit was fliped on for "syncing dependencies between camera and
graphics". BSpec has no recollection why, and it is causing
unrecoverable GPU hangs with Vulkan compute workloads.

>From BSpec, setting bit5 to 0 enables relaxed padding requirements for
buffers, 1D and 2D non-array, non-MSAA, non-mip-mapped linear surfaces;
and *must* be set to 0h on skl+ to ensure "Out of Bounds" case is
suppressed.

Reported-by: Jason Ekstrand <jason@jlekstrand.net>
Suggested-by: Jason Ekstrand <jason@jlekstrand.net>
Bugzilla: https://bugs.freedesktop.org/show_bug.cgi?id=110998
Fixes: 8424171e135c ("drm/i915/gen9: h/w w/a: syncing dependencies between camera and graphics")
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Tested-by: denys.kostin@globallogic.com
Cc: Jason Ekstrand <jason@jlekstrand.net>
Cc: Mika Kuoppala <mika.kuoppala@linux.intel.com>
Cc: <stable@vger.kernel.org> # v4.1+
Reviewed-by: Mika Kuoppala <mika.kuoppala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20190904100707.7377-1-chris@chris-wilson.co.uk
(cherry picked from commit 9d7b01e93526efe79dbf75b69cc5972b5a4f7b37)
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/intel_workarounds.c |    5 -----
 1 file changed, 5 deletions(-)

--- a/drivers/gpu/drm/i915/intel_workarounds.c
+++ b/drivers/gpu/drm/i915/intel_workarounds.c
@@ -294,11 +294,6 @@ static void gen9_ctx_workarounds_init(st
 			  FLOW_CONTROL_ENABLE |
 			  PARTIAL_INSTRUCTION_SHOOTDOWN_DISABLE);
 
-	/* Syncing dependencies between camera and graphics:skl,bxt,kbl */
-	if (!IS_COFFEELAKE(i915))
-		WA_SET_BIT_MASKED(HALF_SLICE_CHICKEN3,
-				  GEN9_DISABLE_OCL_OOB_SUPPRESS_LOGIC);
-
 	/* WaEnableYV12BugFixInHalfSliceChicken7:skl,bxt,kbl,glk,cfl */
 	/* WaEnableSamplerGPGPUPreemptionSupport:skl,bxt,kbl,cfl */
 	WA_SET_BIT_MASKED(GEN9_HALF_SLICE_CHICKEN7,


