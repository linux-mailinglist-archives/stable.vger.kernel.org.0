Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01B5338F052
	for <lists+stable@lfdr.de>; Mon, 24 May 2021 18:01:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234824AbhEXQCh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 12:02:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:46884 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235800AbhEXQBK (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 May 2021 12:01:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DBC6B61991;
        Mon, 24 May 2021 15:46:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621871207;
        bh=+nPiw6xVU6hNfmq6v7MeBK/V0yme+EwadyF3lBeU0Hs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jZbc3upJgFH8gWSRVDsSrKRbUm8/GyQn6d22TYwqrLy9ietswp4u58c8fRwT4gvJx
         5+UdkU/FDh9sbeahVK7o+tK9HTst2cvlwSAnc1t9ZTNmfGJgchC0x2AdxGMvEygMMQ
         WZUcX/kvRYAUfXizR4uWFe35Z2enX4RpQNYfyUmg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Manuel Bentele <development@manuel-bentele.de>,
        Simon Rettberg <simon.rettberg@rz.uni-freiburg.de>,
        Dave Airlie <airlied@redhat.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Jani Nikula <jani.nikula@intel.com>
Subject: [PATCH 5.12 122/127] drm/i915/gt: Disable HiZ Raw Stall Optimization on broken gen7
Date:   Mon, 24 May 2021 17:27:19 +0200
Message-Id: <20210524152338.999803726@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210524152334.857620285@linuxfoundation.org>
References: <20210524152334.857620285@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Simon Rettberg <simon.rettberg@rz.uni-freiburg.de>

commit 023dfa9602f561952c0e19d74f66614a56d7e57a upstream.

When resetting CACHE_MODE registers, don't enable HiZ Raw Stall
Optimization on Ivybridge GT1 and Baytrail, as it causes severe glitches
when rendering any kind of 3D accelerated content.
This optimization is disabled on these platforms by default according to
official documentation from 01.org.

Fixes: ef99a60ffd9b ("drm/i915/gt: Clear CACHE_MODE prior to clearing residuals")
BugLink: https://gitlab.freedesktop.org/drm/intel/-/issues/3081
BugLink: https://gitlab.freedesktop.org/drm/intel/-/issues/3404
BugLink: https://gitlab.freedesktop.org/drm/intel/-/issues/3071
Reviewed-by: Manuel Bentele <development@manuel-bentele.de>
Signed-off-by: Simon Rettberg <simon.rettberg@rz.uni-freiburg.de>
Reviewed-by: Dave Airlie <airlied@redhat.com>
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
[Rodrigo removed invalid Fixes line]
Link: https://patchwork.freedesktop.org/patch/msgid/20210426161124.2b7fd708@dellnichtsogutkiste
(cherry picked from commit 929b734ad34b717d6a1b8de97f53bb5616040147)
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/gt/gen7_renderclear.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/i915/gt/gen7_renderclear.c
+++ b/drivers/gpu/drm/i915/gt/gen7_renderclear.c
@@ -397,7 +397,10 @@ static void emit_batch(struct i915_vma *
 	gen7_emit_pipeline_invalidate(&cmds);
 	batch_add(&cmds, MI_LOAD_REGISTER_IMM(2));
 	batch_add(&cmds, i915_mmio_reg_offset(CACHE_MODE_0_GEN7));
-	batch_add(&cmds, 0xffff0000);
+	batch_add(&cmds, 0xffff0000 |
+			((IS_IVB_GT1(i915) || IS_VALLEYVIEW(i915)) ?
+			 HIZ_RAW_STALL_OPT_DISABLE :
+			 0));
 	batch_add(&cmds, i915_mmio_reg_offset(CACHE_MODE_1));
 	batch_add(&cmds, 0xffff0000 | PIXEL_SUBSPAN_COLLECT_OPT_DISABLE);
 	gen7_emit_pipeline_invalidate(&cmds);


