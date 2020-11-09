Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF1102ABAF7
	for <lists+stable@lfdr.de>; Mon,  9 Nov 2020 14:27:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731140AbgKINQV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 08:16:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:43308 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387466AbgKINQU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Nov 2020 08:16:20 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1364F206D8;
        Mon,  9 Nov 2020 13:16:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604927779;
        bh=RvtglgkjK8v6GrPDnqdopI5OLfj6V1mtOQlb7pKog7Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oe/ZqdtMgRCX1ImnqXaCruXNjZdxPMoYpQe7SrW6ZjR4/k16Y7/ad2UQiblfzAhso
         vU/m7LcoLfKhavlylslia+aXjaWJwrFXGbhEj+0cmmdHXHyF8ZeXJTGDB2oIVrW/x4
         9JNaTOdXBmIIVe1zJ1dyIqInm/FJL8lKaNUZb6xE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chris Wilson <chris@chris-wilson.co.uk>,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
        <ville.syrjala@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>
Subject: [PATCH 5.9 019/133] drm/i915: Restore ILK-M RPS support
Date:   Mon,  9 Nov 2020 13:54:41 +0100
Message-Id: <20201109125031.641290503@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201109125030.706496283@linuxfoundation.org>
References: <20201109125030.706496283@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ville Syrjälä <ville.syrjala@linux.intel.com>

commit 5cbd7685b22823ebf432ec71eac1691b71c41037 upstream.

Restore RPS for ILK-M. We lost it when an extra HAS_RPS()
check appeared in intel_rps_enable().

Unfortunaltey this just makes the performance worse on my
ILK because intel_ips insists on limiting the GPU freq to
the minimum. If we don't do the RPS init then intel_ips will
not limit the frequency for whatever reason. Either it can't
get at some required information and thus makes wrong decisions,
or we mess up some weights/etc. and cause it to make the wrong
decisions when RPS init has been done, or the entire thing is
just wrong. Would require a bunch of reverse engineering to
figure out what's going on.

Cc: stable@vger.kernel.org
Cc: Chris Wilson <chris@chris-wilson.co.uk>
Fixes: 9c878557b1eb ("drm/i915/gt: Use the RPM config register to determine clk frequencies")
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20201021131443.25616-1-ville.syrjala@linux.intel.com
Reviewed-by: Chris Wilson <chris@chris-wilson.co.uk>
(cherry picked from commit 2bf06370bcfb0dea5655e9a5ad460c7f7dca7739)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/i915_pci.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/gpu/drm/i915/i915_pci.c
+++ b/drivers/gpu/drm/i915/i915_pci.c
@@ -389,6 +389,7 @@ static const struct intel_device_info il
 	GEN5_FEATURES,
 	PLATFORM(INTEL_IRONLAKE),
 	.is_mobile = 1,
+	.has_rps = true,
 	.display.has_fbc = 1,
 };
 


