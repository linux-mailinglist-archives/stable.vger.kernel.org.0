Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8EEBB420F7C
	for <lists+stable@lfdr.de>; Mon,  4 Oct 2021 15:34:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237833AbhJDNfR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Oct 2021 09:35:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:47290 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237858AbhJDNdP (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Oct 2021 09:33:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9817763228;
        Mon,  4 Oct 2021 13:15:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633353302;
        bh=OX65UY3n6udOwqxSX2gucVF8CzSQqHWhXYlhOWOw4uM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OaMJce5Gi+KU2In08KoKA5AGE7GyqKUbh71TDTiDJLIihkTkNwd5vYPCUq4Sgg5gI
         7iIVjv4BFfMAU9JPIs2uTfe6NuZJs/JXsgxrzc3OWPrZGH0qegZwzF1Z3lgr6oVKoh
         6mNGGFzBx2+Qsy6pmwIlTx6ec3Rxnf1/AJVKoKyU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhenyu Wang <zhenyuw@linux.intel.com>,
        Zhi A Wang <zhi.a.wang@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 075/172] drm/i915/gvt: fix the usage of ww lock in gvt scheduler.
Date:   Mon,  4 Oct 2021 14:52:05 +0200
Message-Id: <20211004125047.421057978@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211004125044.945314266@linuxfoundation.org>
References: <20211004125044.945314266@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhi A Wang <zhi.wang.linux2@gmail.com>

[ Upstream commit d168cd797982db9db617113644c87b8f5f3cf27e ]

As the APIs related to ww lock in i915 was changed recently, the usage of
ww lock in GVT-g scheduler needs to be changed accrodingly. We noticed a
deadlock when GVT-g scheduler submits the workload to i915. After some
investigation, it seems the way of how to use ww lock APIs has been
changed. Releasing a ww now requires a explicit i915_gem_ww_ctx_fini().

Fixes: 67f1120381df ("drm/i915/gvt: Introduce per object locking in GVT scheduler.")
Cc: Zhenyu Wang <zhenyuw@linux.intel.com>
Signed-off-by: Zhi A Wang <zhi.a.wang@intel.com>
Signed-off-by: Zhenyu Wang <zhenyuw@linux.intel.com>
Link: http://patchwork.freedesktop.org/patch/msgid/20210826143834.25410-1-zhi.a.wang@intel.com
Acked-by: Zhenyu Wang <zhenyuw@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/gvt/scheduler.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/i915/gvt/scheduler.c b/drivers/gpu/drm/i915/gvt/scheduler.c
index 734c37c5e347..527b59b86312 100644
--- a/drivers/gpu/drm/i915/gvt/scheduler.c
+++ b/drivers/gpu/drm/i915/gvt/scheduler.c
@@ -576,7 +576,7 @@ static int prepare_shadow_batch_buffer(struct intel_vgpu_workload *workload)
 
 			/* No one is going to touch shadow bb from now on. */
 			i915_gem_object_flush_map(bb->obj);
-			i915_gem_object_unlock(bb->obj);
+			i915_gem_ww_ctx_fini(&ww);
 		}
 	}
 	return 0;
@@ -630,7 +630,7 @@ static int prepare_shadow_wa_ctx(struct intel_shadow_wa_ctx *wa_ctx)
 		return ret;
 	}
 
-	i915_gem_object_unlock(wa_ctx->indirect_ctx.obj);
+	i915_gem_ww_ctx_fini(&ww);
 
 	/* FIXME: we are not tracking our pinned VMA leaving it
 	 * up to the core to fix up the stray pin_count upon
-- 
2.33.0



