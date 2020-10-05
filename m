Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 834E5283A83
	for <lists+stable@lfdr.de>; Mon,  5 Oct 2020 17:35:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727922AbgJEPfF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Oct 2020 11:35:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:35294 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728311AbgJEPef (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Oct 2020 11:34:35 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 20A31208C7;
        Mon,  5 Oct 2020 15:34:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601912074;
        bh=iyT1QENsl+rPkzxQfuec79ZZOqJ0a27M2paHPe0It90=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wZ3/lj+KVMyCmygMIQ30nxtl6h6WRS7NazWykFJZkgF26obSZvPN7KiPN/KBeMTqA
         FwIpYNp96heo/jcN+8xoy9rkfS3NMGgsqHOSmtaNHWb/jl83yaNfPZsv+aSHuwHW1C
         1YH1HYLAdy27Jo8j6qWhE4BWwvkc46T0++Xwhp1M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alejandro Sior <aho@sior.be>,
        Hang Yuan <hang.yuan@intel.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>
Subject: [PATCH 5.8 79/85] drm/i915/gvt: Fix port number for BDW on EDID region setup
Date:   Mon,  5 Oct 2020 17:27:15 +0200
Message-Id: <20201005142118.532151246@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201005142114.732094228@linuxfoundation.org>
References: <20201005142114.732094228@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhenyu Wang <zhenyuw@linux.intel.com>

commit 28284943ac94014767ecc2f7b3c5747c4a5617a0 upstream.

Current BDW virtual display port is initialized as PORT_B, so need
to use same port for VFIO EDID region, otherwise invalid EDID blob
pointer is assigned which caused kernel null pointer reference. We
might evaluate actual display hotplug for BDW to make this function
work as expected, anyway this is always required to be fixed first.

Reported-by: Alejandro Sior <aho@sior.be>
Cc: Alejandro Sior <aho@sior.be>
Fixes: 0178f4ce3c3b ("drm/i915/gvt: Enable vfio edid for all GVT supported platform")
Reviewed-by: Hang Yuan <hang.yuan@intel.com>
Signed-off-by: Zhenyu Wang <zhenyuw@linux.intel.com>
Link: http://patchwork.freedesktop.org/patch/msgid/20200914030302.2775505-1-zhenyuw@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/gvt/vgpu.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/i915/gvt/vgpu.c
+++ b/drivers/gpu/drm/i915/gvt/vgpu.c
@@ -367,6 +367,7 @@ void intel_gvt_destroy_idle_vgpu(struct
 static struct intel_vgpu *__intel_gvt_create_vgpu(struct intel_gvt *gvt,
 		struct intel_vgpu_creation_params *param)
 {
+	struct drm_i915_private *dev_priv = gvt->gt->i915;
 	struct intel_vgpu *vgpu;
 	int ret;
 
@@ -434,7 +435,10 @@ static struct intel_vgpu *__intel_gvt_cr
 	if (ret)
 		goto out_clean_sched_policy;
 
-	ret = intel_gvt_hypervisor_set_edid(vgpu, PORT_D);
+	if (IS_BROADWELL(dev_priv))
+		ret = intel_gvt_hypervisor_set_edid(vgpu, PORT_B);
+	else
+		ret = intel_gvt_hypervisor_set_edid(vgpu, PORT_D);
 	if (ret)
 		goto out_clean_sched_policy;
 


