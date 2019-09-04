Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0CDE8A902D
	for <lists+stable@lfdr.de>; Wed,  4 Sep 2019 21:37:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389345AbfIDSIH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Sep 2019 14:08:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:50780 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389717AbfIDSIH (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Sep 2019 14:08:07 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7FF312087E;
        Wed,  4 Sep 2019 18:08:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567620486;
        bh=UzcHAmeVGD68ESeG2+GzPUb01ujJEsRYWeCT0/a0gUk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NBYabfAs3nSsLuaKoghOuJkBREcobNssa5K+cT1QWfFN23Yy1wrcPNdpEJdvssn/6
         udBkAKg2tcr1Q7rrR3fsHIxn8vPwZh/OMpOLJ0YpteucTajowOSGnmU7T3/Wt0bkcJ
         JCOdxXUEcmJaeIlwa8VldE56r9KMgxsKs88jSIgk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lyude Paul <lyude@redhat.com>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Jani Nikula <jani.nikula@intel.com>
Subject: [PATCH 4.19 75/93] drm/i915: Call dma_set_max_seg_size() in i915_driver_hw_probe()
Date:   Wed,  4 Sep 2019 19:54:17 +0200
Message-Id: <20190904175309.560645681@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190904175302.845828956@linuxfoundation.org>
References: <20190904175302.845828956@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lyude Paul <lyude@redhat.com>

commit 32f0a982650b123bdab36865617d3e03ebcacf3b upstream.

Currently, we don't call dma_set_max_seg_size() for i915 because we
intentionally do not limit the segment length that the device supports.
However, this results in a warning being emitted if we try to map
anything larger than SZ_64K on a kernel with CONFIG_DMA_API_DEBUG_SG
enabled:

[    7.751926] DMA-API: i915 0000:00:02.0: mapping sg segment longer
than device claims to support [len=98304] [max=65536]
[    7.751934] WARNING: CPU: 5 PID: 474 at kernel/dma/debug.c:1220
debug_dma_map_sg+0x20f/0x340

This was originally brought up on
https://bugs.freedesktop.org/show_bug.cgi?id=108517 , and the consensus
there was it wasn't really useful to set a limit (and that dma-debug
isn't really all that useful for i915 in the first place). Unfortunately
though, CONFIG_DMA_API_DEBUG_SG is enabled in the debug configs for
various distro kernels. Since a WARN_ON() will disable automatic problem
reporting (and cause any CI with said option enabled to start
complaining), we really should just fix the problem.

Note that as me and Chris Wilson discussed, the other solution for this
would be to make DMA-API not make such assumptions when a driver hasn't
explicitly set a maximum segment size. But, taking a look at the commit
which originally introduced this behavior, commit 78c47830a5cb
("dma-debug: check scatterlist segments"), there is an explicit mention
of this assumption and how it applies to devices with no segment size:

	Conversely, devices which are less limited than the rather
	conservative defaults, or indeed have no limitations at all
	(e.g. GPUs with their own internal MMU), should be encouraged to
	set appropriate dma_parms, as they may get more efficient DMA
	mapping performance out of it.

So unless there's any concerns (I'm open to discussion!), let's just
follow suite and call dma_set_max_seg_size() with UINT_MAX as our limit
to silence any warnings.

Changes since v3:
* Drop patch for enabling CONFIG_DMA_API_DEBUG_SG in CI. It looks like
  just turning it on causes the kernel to spit out bogus WARN_ONs()
  during some igt tests which would otherwise require teaching igt to
  disable the various DMA-API debugging options causing this. This is
  too much work to be worth it, since DMA-API debugging is useless for
  us. So, we'll just settle with this single patch to squelch WARN_ONs()
  during driver load for users that have CONFIG_DMA_API_DEBUG_SG turned
  on for some reason.
* Move dma_set_max_seg_size() call into i915_driver_hw_probe() - Chris
  Wilson

Signed-off-by: Lyude Paul <lyude@redhat.com>
Reviewed-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: <stable@vger.kernel.org> # v4.18+
Link: https://patchwork.freedesktop.org/patch/msgid/20190823205251.14298-1-lyude@redhat.com
(cherry picked from commit acd674af95d3f627062007429b9c195c6b32361d)
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/i915_drv.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/gpu/drm/i915/i915_drv.c
+++ b/drivers/gpu/drm/i915/i915_drv.c
@@ -1120,6 +1120,12 @@ static int i915_driver_init_hw(struct dr
 
 	pci_set_master(pdev);
 
+	/*
+	 * We don't have a max segment size, so set it to the max so sg's
+	 * debugging layer doesn't complain
+	 */
+	dma_set_max_seg_size(&pdev->dev, UINT_MAX);
+
 	/* overlay on gen2 is broken and can't address above 1G */
 	if (IS_GEN2(dev_priv)) {
 		ret = dma_set_coherent_mask(&pdev->dev, DMA_BIT_MASK(30));


