Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A6B94F3A6C
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 17:01:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381392AbiDELpO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 07:45:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354668AbiDEKPE (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 06:15:04 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AF5C6C1FC;
        Tue,  5 Apr 2022 03:02:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C7CE2B81C83;
        Tue,  5 Apr 2022 10:02:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34A57C385A1;
        Tue,  5 Apr 2022 10:02:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649152938;
        bh=FYy2NuQYAT8A88IIsa/Kesb6XY03e4b5Gwo9kUxcGzI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W4QSI0eo5TkekaQyKimMuXFkAh8+siqnB3BLq2CGd7vMUkDEN8+xly8ljrzPIgugs
         06Rcc6yZQKznH50cPU4Brwouyl+IJUc1ocHgz2Wsm8XRrXHLs/DnyeboQZIyRmj1ho
         i9bZUm1HSn01tzBz84dkHxEuN4Lna4biwTi+7z+o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Gwendal Grignou <gwendal@chromium.org>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        Jiri Kosina <jkosina@suse.cz>
Subject: [PATCH 5.10 044/599] HID: intel-ish-hid: Use dma_alloc_coherent for firmware update
Date:   Tue,  5 Apr 2022 09:25:38 +0200
Message-Id: <20220405070300.139280160@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070258.802373272@linuxfoundation.org>
References: <20220405070258.802373272@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gwendal Grignou <gwendal@chromium.org>

commit f97ec5d75e9261a5da78dc28a8955b7cc0c4468b upstream.

Allocating memory with kmalloc and GPF_DMA32 is not allowed, the
allocator will ignore the attribute.

Instead, use dma_alloc_coherent() API as we allocate a small amount of
memory to transfer firmware fragment to the ISH.

On Arcada chromebook, after the patch the warning:
"Unexpected gfp: 0x4 (GFP_DMA32). Fixing up to gfp: 0xcc0 (GFP_KERNEL).  Fix your code!"
is gone. The ISH firmware is loaded properly and we can interact with
the ISH:
> ectool  --name cros_ish version
...
Build info:    arcada_ish_v2.0.3661+3c1a1c1ae0 2022-02-08 05:37:47 @localhost
Tool version:  v2.0.12300-900b03ec7f 2022-02-08 10:01:48 @localhost

Fixes: commit 91b228107da3 ("HID: intel-ish-hid: ISH firmware loader client driver")
Signed-off-by: Gwendal Grignou <gwendal@chromium.org>
Acked-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Cc: stable@vger.kernel.org
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/intel-ish-hid/ishtp-fw-loader.c |   29 ++--------------------------
 1 file changed, 3 insertions(+), 26 deletions(-)

--- a/drivers/hid/intel-ish-hid/ishtp-fw-loader.c
+++ b/drivers/hid/intel-ish-hid/ishtp-fw-loader.c
@@ -656,21 +656,12 @@ static int ish_fw_xfer_direct_dma(struct
 	 */
 	payload_max_size &= ~(L1_CACHE_BYTES - 1);
 
-	dma_buf = kmalloc(payload_max_size, GFP_KERNEL | GFP_DMA32);
+	dma_buf = dma_alloc_coherent(devc, payload_max_size, &dma_buf_phy, GFP_KERNEL);
 	if (!dma_buf) {
 		client_data->flag_retry = true;
 		return -ENOMEM;
 	}
 
-	dma_buf_phy = dma_map_single(devc, dma_buf, payload_max_size,
-				     DMA_TO_DEVICE);
-	if (dma_mapping_error(devc, dma_buf_phy)) {
-		dev_err(cl_data_to_dev(client_data), "DMA map failed\n");
-		client_data->flag_retry = true;
-		rv = -ENOMEM;
-		goto end_err_dma_buf_release;
-	}
-
 	ldr_xfer_dma_frag.fragment.hdr.command = LOADER_CMD_XFER_FRAGMENT;
 	ldr_xfer_dma_frag.fragment.xfer_mode = LOADER_XFER_MODE_DIRECT_DMA;
 	ldr_xfer_dma_frag.ddr_phys_addr = (u64)dma_buf_phy;
@@ -690,14 +681,7 @@ static int ish_fw_xfer_direct_dma(struct
 		ldr_xfer_dma_frag.fragment.size = fragment_size;
 		memcpy(dma_buf, &fw->data[fragment_offset], fragment_size);
 
-		dma_sync_single_for_device(devc, dma_buf_phy,
-					   payload_max_size,
-					   DMA_TO_DEVICE);
-
-		/*
-		 * Flush cache here because the dma_sync_single_for_device()
-		 * does not do for x86.
-		 */
+		/* Flush cache to be sure the data is in main memory. */
 		clflush_cache_range(dma_buf, payload_max_size);
 
 		dev_dbg(cl_data_to_dev(client_data),
@@ -720,15 +704,8 @@ static int ish_fw_xfer_direct_dma(struct
 		fragment_offset += fragment_size;
 	}
 
-	dma_unmap_single(devc, dma_buf_phy, payload_max_size, DMA_TO_DEVICE);
-	kfree(dma_buf);
-	return 0;
-
 end_err_resp_buf_release:
-	/* Free ISH buffer if not done already, in error case */
-	dma_unmap_single(devc, dma_buf_phy, payload_max_size, DMA_TO_DEVICE);
-end_err_dma_buf_release:
-	kfree(dma_buf);
+	dma_free_coherent(devc, payload_max_size, dma_buf, dma_buf_phy);
 	return rv;
 }
 


