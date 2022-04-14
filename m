Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4249C50124B
	for <lists+stable@lfdr.de>; Thu, 14 Apr 2022 17:07:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345333AbiDNNp5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Apr 2022 09:45:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245229AbiDNNiU (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Apr 2022 09:38:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D4379D064;
        Thu, 14 Apr 2022 06:31:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C3BEAB8296A;
        Thu, 14 Apr 2022 13:31:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CF2EC385A5;
        Thu, 14 Apr 2022 13:31:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649943101;
        bh=FYy2NuQYAT8A88IIsa/Kesb6XY03e4b5Gwo9kUxcGzI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ic7odhyj69O0NJmtQfwFbpK3eYI/SYveCQ4Qdww5XdH6U175hu8tcd0pOmwebuRUB
         whCtwwIkB3+MOmvVmBczX3PFi5IEbz+06RIKpQQ8tkqQ8CLHVMKnBRhxp7zricyIIz
         AO9C+g5k2glacIxb/A0n06ilEKzZLiP1VnyGQJDQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Gwendal Grignou <gwendal@chromium.org>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        Jiri Kosina <jkosina@suse.cz>
Subject: [PATCH 5.4 034/475] HID: intel-ish-hid: Use dma_alloc_coherent for firmware update
Date:   Thu, 14 Apr 2022 15:06:59 +0200
Message-Id: <20220414110856.110964373@linuxfoundation.org>
X-Mailer: git-send-email 2.35.2
In-Reply-To: <20220414110855.141582785@linuxfoundation.org>
References: <20220414110855.141582785@linuxfoundation.org>
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
 


