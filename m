Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57F6744182C
	for <lists+stable@lfdr.de>; Mon,  1 Nov 2021 10:42:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233140AbhKAJpA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Nov 2021 05:45:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:47850 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233973AbhKAJnp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Nov 2021 05:43:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6FEE66138F;
        Mon,  1 Nov 2021 09:28:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635758935;
        bh=pftJJztMx9mEXzw0BReef5HWBHEZB86eJ/PNIDrrdiE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t9BIabGv/ZDa6S6WKqpW5mChflUgS4aT7B9s4A+Kz3dB1/w+ZSGa97cbcCUnDATo/
         AQGdAYG1yNOMUHZQ2xpVa76EDRRNKR+Z93RWj3f/jdC0iy8Am/giqb4y5YpkHa2WrZ
         /wigJYQyfEWS76OTN91oOciF5eJHClNe6DKUAp00=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        =?UTF-8?q?Thomas=20Hellstr=C3=B6m?= 
        <thomas.hellstrom@linux.intel.com>,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
        <ville.syrjala@linux.intel.com>, Dave Airlie <airlied@redhat.com>,
        Jani Nikula <jani.nikula@intel.com>
Subject: [PATCH 5.14 045/125] drm/i915: Catch yet another unconditioal clflush
Date:   Mon,  1 Nov 2021 10:16:58 +0100
Message-Id: <20211101082541.697543505@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211101082533.618411490@linuxfoundation.org>
References: <20211101082533.618411490@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ville Syrjälä <ville.syrjala@linux.intel.com>

commit 9761ffb8f1090289b908590039e2c363cc35cf45 upstream.

Replace the unconditional clflush() with drm_clflush_virt_range()
which does the wbinvd() fallback when clflush is not available.

This time no justification is given for the clflush in the
offending commit.

Cc: stable@vger.kernel.org
Cc: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Cc: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Fixes: 2c8ab3339e39 ("drm/i915: Pin timeline map after first timeline pin, v4.")
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20211014090941.12159-4-ville.syrjala@linux.intel.com
Reviewed-by: Dave Airlie <airlied@redhat.com>
(cherry picked from commit 9ced12182d0d8401d821e9602e56e276459900fc)
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/gt/intel_timeline.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/i915/gt/intel_timeline.c
+++ b/drivers/gpu/drm/i915/gt/intel_timeline.c
@@ -64,7 +64,7 @@ intel_timeline_pin_map(struct intel_time
 
 	timeline->hwsp_map = vaddr;
 	timeline->hwsp_seqno = memset(vaddr + ofs, 0, TIMELINE_SEQNO_BYTES);
-	clflush(vaddr + ofs);
+	drm_clflush_virt_range(vaddr + ofs, TIMELINE_SEQNO_BYTES);
 
 	return 0;
 }


