Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0387437C23A
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 17:07:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233036AbhELPIG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 11:08:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:58780 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231848AbhELPGH (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 11:06:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B336F6195C;
        Wed, 12 May 2021 15:00:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620831653;
        bh=2a+sJCPebuCxx3jCRwfCF++Z3m2zAqv98+geW3+9BEo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GQX9tRPNj6fmydQNECPI5URZIIf9JWfmOOE5iiSyf859M4ZOLAkXs25XzTpvf4a6C
         t0BLf1PGLch1LJPFfXjgDGXIb97RLufwQdMuQ7bs8cbiXZeJlo0ak78PvfCgaJYMzk
         EAEzXsaUJhp8SkYDq6ECGMf+jtRwf+JRPZN7K8u4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 207/244] drm/i915/gvt: Fix error code in intel_gvt_init_device()
Date:   Wed, 12 May 2021 16:49:38 +0200
Message-Id: <20210512144749.617282750@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144743.039977287@linuxfoundation.org>
References: <20210512144743.039977287@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit 329328ec6a87f2c1275f50d979d55513de458409 ]

The intel_gvt_init_vgpu_type_groups() function is only called from
intel_gvt_init_device().  If it fails then the intel_gvt_init_device()
prints the error code and propagates it back again.  That's a bug
because false is zero/success.  The fix is to modify it to return zero
or negative error codes and make everything consistent.

Fixes: c5d71cb31723 ("drm/i915/gvt: Move vGPU type related code into gvt file")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Zhenyu Wang <zhenyuw@linux.intel.com>
Link: http://patchwork.freedesktop.org/patch/msgid/YHaFQtk/DIVYK1u5@mwanda
Reviewed-by: Zhenyu Wang <zhenyuw@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/gvt/gvt.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/i915/gvt/gvt.c b/drivers/gpu/drm/i915/gvt/gvt.c
index 8f37eefa0a02..a738c7e456dd 100644
--- a/drivers/gpu/drm/i915/gvt/gvt.c
+++ b/drivers/gpu/drm/i915/gvt/gvt.c
@@ -128,7 +128,7 @@ static bool intel_get_gvt_attrs(struct attribute ***type_attrs,
 	return true;
 }
 
-static bool intel_gvt_init_vgpu_type_groups(struct intel_gvt *gvt)
+static int intel_gvt_init_vgpu_type_groups(struct intel_gvt *gvt)
 {
 	int i, j;
 	struct intel_vgpu_type *type;
@@ -146,7 +146,7 @@ static bool intel_gvt_init_vgpu_type_groups(struct intel_gvt *gvt)
 		gvt_vgpu_type_groups[i] = group;
 	}
 
-	return true;
+	return 0;
 
 unwind:
 	for (j = 0; j < i; j++) {
@@ -154,7 +154,7 @@ unwind:
 		kfree(group);
 	}
 
-	return false;
+	return -ENOMEM;
 }
 
 static void intel_gvt_cleanup_vgpu_type_groups(struct intel_gvt *gvt)
@@ -362,7 +362,7 @@ int intel_gvt_init_device(struct drm_i915_private *dev_priv)
 		goto out_clean_thread;
 
 	ret = intel_gvt_init_vgpu_type_groups(gvt);
-	if (ret == false) {
+	if (ret) {
 		gvt_err("failed to init vgpu type groups: %d\n", ret);
 		goto out_clean_types;
 	}
-- 
2.30.2



