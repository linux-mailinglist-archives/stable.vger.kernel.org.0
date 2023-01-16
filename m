Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C435B66C957
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 17:49:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233788AbjAPQtW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 11:49:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233881AbjAPQrz (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 11:47:55 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52C812A146
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:35:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E4A7F6104D
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:35:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 059BBC433EF;
        Mon, 16 Jan 2023 16:35:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673886929;
        bh=lXac1krLyvWXItOa1usDZ9GlDirmZxdVVgKum/nsJUA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=alPG0vhb0VSZPdfamtSdw0C98y6pA9XTYGY85oYHEu/Vn24vqpsuiPegUdZuNW2O1
         pm0KVc8X0IEeZVeiqKYW595dm+yqG9wobahNnAmMnbqC590d3XwE6UrtMbzDbqF0r+
         b4JWkz9yU633+VivRdv9RoYWgNHkITtuB4Y/DbeE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Dan Carpenter <dan.carpenter@oracle.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 585/658] drm/i915: unpin on error in intel_vgpu_shadow_mm_pin()
Date:   Mon, 16 Jan 2023 16:51:13 +0100
Message-Id: <20230116154936.254470989@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154909.645460653@linuxfoundation.org>
References: <20230116154909.645460653@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <error27@gmail.com>

[ Upstream commit 3792fc508c095abd84b10ceae12bd773e61fdc36 ]

Call intel_vgpu_unpin_mm() on this error path.

Fixes: 418741480809 ("drm/i915/gvt: Adding ppgtt to GVT GEM context after shadow pdps settled.")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Zhenyu Wang <zhenyuw@linux.intel.com>
Link: http://patchwork.freedesktop.org/patch/msgid/Y3OQ5tgZIVxyQ/WV@kili
Reviewed-by: Zhenyu Wang <zhenyuw@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/gvt/scheduler.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/i915/gvt/scheduler.c b/drivers/gpu/drm/i915/gvt/scheduler.c
index 058dcd541644..c1dc225d8436 100644
--- a/drivers/gpu/drm/i915/gvt/scheduler.c
+++ b/drivers/gpu/drm/i915/gvt/scheduler.c
@@ -632,6 +632,7 @@ static int prepare_workload(struct intel_vgpu_workload *workload)
 
 	if (workload->shadow_mm->type != INTEL_GVT_MM_PPGTT ||
 	    !workload->shadow_mm->ppgtt_mm.shadowed) {
+		intel_vgpu_unpin_mm(workload->shadow_mm);
 		gvt_vgpu_err("workload shadow ppgtt isn't ready\n");
 		return -EINVAL;
 	}
-- 
2.35.1



