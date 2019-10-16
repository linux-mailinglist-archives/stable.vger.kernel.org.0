Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5151AD9EDD
	for <lists+stable@lfdr.de>; Thu, 17 Oct 2019 00:04:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406781AbfJPWDE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Oct 2019 18:03:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:54432 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2438498AbfJPV7b (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 16 Oct 2019 17:59:31 -0400
Received: from localhost (unknown [192.55.54.58])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 183AA21D7C;
        Wed, 16 Oct 2019 21:59:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571263171;
        bh=TZAzt8b0InQqkoVFvO0WAITq7FHov/uXFi2a0LWBaNE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f+gaMMpPvZML7tZziMlcLG/BEbj2gW8f10u3dIkV51RdfN3Xg0FKhxJPiQ/6FVwdh
         y/yuSFTLjKJ8tlX7+u++zQfZSAr/mvbkA9x1nFRhpEzoUsxYk9OaBCQrvsugLVH43S
         gp/9JHu+z4XoiJ6NcSUYarzHRZFFpti0FNkknu9Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kenneth Graunke <kenneth@whitecape.org>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>
Subject: [PATCH 5.3 098/112] drm/i915: Whitelist COMMON_SLICE_CHICKEN2
Date:   Wed, 16 Oct 2019 14:51:30 -0700
Message-Id: <20191016214906.224784666@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191016214844.038848564@linuxfoundation.org>
References: <20191016214844.038848564@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kenneth Graunke <kenneth@whitecape.org>

commit 282b7fd5f5ab4eba499e1162c1e2802c6d0bb82e upstream.

This allows userspace to use "legacy" mode for push constants, where
they are committed at 3DPRIMITIVE or flush time, rather than being
committed at 3DSTATE_BINDING_TABLE_POINTERS_XS time.  Gen6-8 and Gen11
both use the "legacy" behavior - only Gen9 works in the "new" way.

Conflating push constants with binding tables is painful for userspace,
we would like to be able to avoid doing so.

Signed-off-by: Kenneth Graunke <kenneth@whitecape.org>
Cc: stable@vger.kernel.org
Reviewed-by: Chris Wilson <chris@chris-wilson.co.uk>
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Link: https://patchwork.freedesktop.org/patch/msgid/20190911014801.26821-1-kenneth@whitecape.org
(cherry picked from commit 0606259e3b3a1220a0f04a92a1654a3f674f47ee)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/gt/intel_workarounds.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/gpu/drm/i915/gt/intel_workarounds.c
+++ b/drivers/gpu/drm/i915/gt/intel_workarounds.c
@@ -1042,6 +1042,9 @@ static void gen9_whitelist_build(struct
 
 	/* WaAllowUMDToModifyHDCChicken1:skl,bxt,kbl,glk,cfl */
 	whitelist_reg(w, GEN8_HDC_CHICKEN1);
+
+	/* WaSendPushConstantsFromMMIO:skl,bxt */
+	whitelist_reg(w, COMMON_SLICE_CHICKEN2);
 }
 
 static void skl_whitelist_build(struct intel_engine_cs *engine)


