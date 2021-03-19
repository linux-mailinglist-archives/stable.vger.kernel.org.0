Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67A35341C3A
	for <lists+stable@lfdr.de>; Fri, 19 Mar 2021 13:20:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230229AbhCSMTn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Mar 2021 08:19:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:57030 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230185AbhCSMT2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Mar 2021 08:19:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A38EA64F6A;
        Fri, 19 Mar 2021 12:19:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616156368;
        bh=X5B+o+xzVt9zkYthJAuK+tmlw687uNO3CEy98pry+LU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=goLlRzonw8UuwcR/CV4hvb1xJEKb3qwOUfLEM8gDpi/FeOz8HEvWdQLoo0/bZ/BC2
         X7MK52WRxC5Bj+iN820MfN8enIRrunY2um2F9EnwDI4nvtBkpUfCUkx7CkYB8xOsX5
         cQ9WCpOGmSkQ3ndjSFs518maWOXMrERfHCydkFMU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alejandro Sior <aho@sior.be>, Hang Yuan <hang.yuan@intel.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Colin Xu <colin.xu@intel.com>
Subject: [PATCH 5.4 11/18] drm/i915/gvt: Fix port number for BDW on EDID region setup
Date:   Fri, 19 Mar 2021 13:18:49 +0100
Message-Id: <20210319121745.833814082@linuxfoundation.org>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210319121745.449875976@linuxfoundation.org>
References: <20210319121745.449875976@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Colin Xu <colin.xu@intel.com>

From: Zhenyu Wang <zhenyuw@linux.intel.com>

commit 28284943ac94014767ecc2f7b3c5747c4a5617a0 upstream

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
(cherry picked from commit 28284943ac94014767ecc2f7b3c5747c4a5617a0)
Signed-off-by: Colin Xu <colin.xu@intel.com>
Cc: <stable@vger.kernel.org> # 5.4.y
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/gvt/vgpu.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/i915/gvt/vgpu.c
+++ b/drivers/gpu/drm/i915/gvt/vgpu.c
@@ -432,8 +432,9 @@ static struct intel_vgpu *__intel_gvt_cr
 	if (ret)
 		goto out_clean_sched_policy;
 
-	/*TODO: add more platforms support */
-	if (IS_SKYLAKE(gvt->dev_priv) || IS_KABYLAKE(gvt->dev_priv))
+	if (IS_BROADWELL(gvt->dev_priv))
+		ret = intel_gvt_hypervisor_set_edid(vgpu, PORT_B);
+	else
 		ret = intel_gvt_hypervisor_set_edid(vgpu, PORT_D);
 	if (ret)
 		goto out_clean_sched_policy;


