Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E1EC6A0968
	for <lists+stable@lfdr.de>; Thu, 23 Feb 2023 14:05:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234291AbjBWNFi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Feb 2023 08:05:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233819AbjBWNFh (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Feb 2023 08:05:37 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26F7049880
        for <stable@vger.kernel.org>; Thu, 23 Feb 2023 05:05:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 73A5ECE1FEB
        for <stable@vger.kernel.org>; Thu, 23 Feb 2023 13:05:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DF4CC433D2;
        Thu, 23 Feb 2023 13:05:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1677157532;
        bh=bq7juG6ZPZ+eTRGOH+maY2oituv+3GGs4w80wdlurb4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GrPRmcB8kuB3IzxqcHf3uPHprxuw28k06r3sK5HwopRWvH2AsDqRgq6faLRoAcP82
         loVLD7FfSXw7x4bD2RJXL1ItdJJaC86Wg/y+u/HEcdXG6NTXKbPac27Uenhy5B9AfT
         +06nTH7KUeXqtN/e6ihIDdlr6SEJcL/THcXdIk+o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Zheng Wang <zyytlz.wz@163.com>,
        Zhenyu Wang <zhenyuw@linux.intel.com>,
        Ovidiu Panait <ovidiu.panait@eng.windriver.com>
Subject: [PATCH 4.19 07/11] drm/i915/gvt: fix double free bug in split_2MB_gtt_entry
Date:   Thu, 23 Feb 2023 14:04:48 +0100
Message-Id: <20230223130424.340753788@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230223130424.079732181@linuxfoundation.org>
References: <20230223130424.079732181@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zheng Wang <zyytlz.wz@163.com>

commit 4a61648af68f5ba4884f0e3b494ee1cabc4b6620 upstream.

If intel_gvt_dma_map_guest_page failed, it will call
ppgtt_invalidate_spt, which will finally free the spt.
But the caller function ppgtt_populate_spt_by_guest_entry
does not notice that, it will free spt again in its error
path.

Fix this by canceling the mapping of DMA address and freeing sub_spt.
Besides, leave the handle of spt destroy to caller function instead
of callee function when error occurs.

Fixes: b901b252b6cf ("drm/i915/gvt: Add 2M huge gtt support")
Signed-off-by: Zheng Wang <zyytlz.wz@163.com>
Reviewed-by: Zhenyu Wang <zhenyuw@linux.intel.com>
Signed-off-by: Zhenyu Wang <zhenyuw@linux.intel.com>
Link: http://patchwork.freedesktop.org/patch/msgid/20221229165641.1192455-1-zyytlz.wz@163.com
Signed-off-by: Ovidiu Panait <ovidiu.panait@eng.windriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/gvt/gtt.c |   17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

--- a/drivers/gpu/drm/i915/gvt/gtt.c
+++ b/drivers/gpu/drm/i915/gvt/gtt.c
@@ -1155,10 +1155,8 @@ static int split_2MB_gtt_entry(struct in
 	for_each_shadow_entry(sub_spt, &sub_se, sub_index) {
 		ret = intel_gvt_hypervisor_dma_map_guest_page(vgpu,
 				start_gfn + sub_index, PAGE_SIZE, &dma_addr);
-		if (ret) {
-			ppgtt_invalidate_spt(spt);
-			return ret;
-		}
+		if (ret)
+			goto err;
 		sub_se.val64 = se->val64;
 
 		/* Copy the PAT field from PDE. */
@@ -1177,6 +1175,17 @@ static int split_2MB_gtt_entry(struct in
 	ops->set_pfn(se, sub_spt->shadow_page.mfn);
 	ppgtt_set_shadow_entry(spt, se, index);
 	return 0;
+err:
+	/* Cancel the existing addess mappings of DMA addr. */
+	for_each_present_shadow_entry(sub_spt, &sub_se, sub_index) {
+		gvt_vdbg_mm("invalidate 4K entry\n");
+		ppgtt_invalidate_pte(sub_spt, &sub_se);
+	}
+	/* Release the new allocated spt. */
+	trace_spt_change(sub_spt->vgpu->id, "release", sub_spt,
+		sub_spt->guest_page.gfn, sub_spt->shadow_page.type);
+	ppgtt_free_spt(sub_spt);
+	return ret;
 }
 
 static int split_64KB_gtt_entry(struct intel_vgpu *vgpu,


