Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BAEC93D629C
	for <lists+stable@lfdr.de>; Mon, 26 Jul 2021 18:27:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234596AbhGZPge (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Jul 2021 11:36:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:54512 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234138AbhGZPgN (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Jul 2021 11:36:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EF72360F5B;
        Mon, 26 Jul 2021 16:16:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627316201;
        bh=5wdlEF6rCgr23EGjUgsMjp/gncIToHvNq7/xXYZhwu8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xWRThEza9Cx/RNJNngaQprolJ4pYL0UEp+YT0fgEPsffRsasnee0ocQLAx7DvYN+L
         w184QSzPGCUpF2wnu4ArQV9vIQVgaQXFAnn9bLFvF4Vjj/9hkKE6bl7u56TOohJMKU
         s9R4kpHcOfZapAFcVl84EVC1JkZK7i58IHE20T64=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhenyu Wang <zhenyuw@linux.intel.com>,
        Colin Xu <colin.xu@intel.com>
Subject: [PATCH 5.13 221/223] drm/i915/gvt: Clear d3_entered on elsp cmd submission.
Date:   Mon, 26 Jul 2021 17:40:13 +0200
Message-Id: <20210726153853.411098907@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210726153846.245305071@linuxfoundation.org>
References: <20210726153846.245305071@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Colin Xu <colin.xu@intel.com>

commit c90b4503ccf42d9d367e843c223df44aa550e82a upstream.

d3_entered flag is used to mark for vgpu_reset a previous power
transition from D3->D0, typically for VM resume from S3, so that gvt
could skip PPGTT invalidation in current vgpu_reset during resuming.

In case S0ix exit, although there is D3->D0, guest driver continue to
use vgpu as normal, with d3_entered set, until next shutdown/reboot or
power transition.

If a reboot follows a S0ix exit, device power state transite as:
D0->D3->D0->D0(reboot), while system power state transites as:
S0->S0 (reboot). There is no vgpu_reset until D0(reboot), thus
d3_entered won't be cleared, the vgpu_reset will skip PPGTT invalidation
however those PPGTT entries are no longer valid. Err appears like:

gvt: vgpu 2: vfio_pin_pages failed for gfn 0xxxxx, ret -22
gvt: vgpu 2: fail: spt xxxx guest entry 0xxxxx type 2
gvt: vgpu 2: fail: shadow page xxxx guest entry 0xxxxx type 2.

Give gvt a chance to clear d3_entered on elsp cmd submission so that the
states before & after S0ix enter/exit are consistent.

Fixes: ba25d977571e ("drm/i915/gvt: Do not destroy ppgtt_mm during vGPU D3->D0.")
Reviewed-by: Zhenyu Wang <zhenyuw@linux.intel.com>
Signed-off-by: Colin Xu <colin.xu@intel.com>
Signed-off-by: Zhenyu Wang <zhenyuw@linux.intel.com>
Link: http://patchwork.freedesktop.org/patch/msgid/20210707004531.4873-1-colin.xu@intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/gvt/handlers.c |   15 +++++++++++++++
 1 file changed, 15 insertions(+)

--- a/drivers/gpu/drm/i915/gvt/handlers.c
+++ b/drivers/gpu/drm/i915/gvt/handlers.c
@@ -1977,6 +1977,21 @@ static int elsp_mmio_write(struct intel_
 	if (drm_WARN_ON(&i915->drm, !engine))
 		return -EINVAL;
 
+	/*
+	 * Due to d3_entered is used to indicate skipping PPGTT invalidation on
+	 * vGPU reset, it's set on D0->D3 on PCI config write, and cleared after
+	 * vGPU reset if in resuming.
+	 * In S0ix exit, the device power state also transite from D3 to D0 as
+	 * S3 resume, but no vGPU reset (triggered by QEMU devic model). After
+	 * S0ix exit, all engines continue to work. However the d3_entered
+	 * remains set which will break next vGPU reset logic (miss the expected
+	 * PPGTT invalidation).
+	 * Engines can only work in D0. Thus the 1st elsp write gives GVT a
+	 * chance to clear d3_entered.
+	 */
+	if (vgpu->d3_entered)
+		vgpu->d3_entered = false;
+
 	execlist = &vgpu->submission.execlist[engine->id];
 
 	execlist->elsp_dwords.data[3 - execlist->elsp_dwords.index] = data;


