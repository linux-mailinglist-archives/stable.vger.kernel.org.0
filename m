Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0DB7F4AE93F
	for <lists+stable@lfdr.de>; Wed,  9 Feb 2022 06:28:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230208AbiBIFZj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Feb 2022 00:25:39 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:35692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243551AbiBIFKI (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Feb 2022 00:10:08 -0500
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D71EBC03C1AA
        for <stable@vger.kernel.org>; Tue,  8 Feb 2022 21:09:58 -0800 (PST)
Received: by mail-pj1-x1035.google.com with SMTP id qe15so1144224pjb.3
        for <stable@vger.kernel.org>; Tue, 08 Feb 2022 21:09:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=K7WjQexE7ZDpA7zHN6m2ERri6AV+Et3U5OenHKEPyrU=;
        b=BJ58G+X37odzzbXCgs40u/3k8glX78t4hWeURfRDVWblbuz+8DUkYrh2vdy/3wQ3jb
         swqNwiZ9G1mkhif2Nz4fyQr4qeJlNnWAX/SCCVkWq1uMgOBqjZrSuOiOMcwgfNAJR5Hv
         Fs76iR9bVic1gyeMLl0WxdxBEje/4V2f5IzU8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=K7WjQexE7ZDpA7zHN6m2ERri6AV+Et3U5OenHKEPyrU=;
        b=jbclIZZMvRlEvD2RSgZg7nmnxlPbnVvehJ2WZA41+eIfpAcx7KXuZlP4vbEDAoSLOz
         v1T3vXUaDh2ORgbL26sPcAWUJ8F2oAiXpjme15nsrMWHlLJI2muOpvUa8ub/CryKayJn
         yf9y9tL6OJ2ASq4kyYw0lGTNCm4XSBhwVAwi5gd1IktBS/gR1KSBse4NJtny2rAZqUMS
         GWu8MISaZ2dVzwad7eJlLY2OZbnn2/5Yy2gOwxizRzIxsTCR5HPMyRO2v5/cpc57Y+ym
         ze5WvqABHx7n7qpcLbmflgoGQth+JJ1c1ZRGoeERa+CymUd6P4OG3GG5PAoWJoPR+zTq
         3fhQ==
X-Gm-Message-State: AOAM532fAGcTKpVMQ5bKQ8XF34fPKDEixICu6KG2FAq8b1pQIW+wkZ6e
        0+coschCe88NZiqv5RfGWMd08w==
X-Google-Smtp-Source: ABdhPJx3S1QquuDtFJmJhMfIZGLLbHbN5C0YLI0RtgddhImg9/QO6Qv+E3JDJW5oHwefTPf1h+5kbQ==
X-Received: by 2002:a17:90a:1c90:: with SMTP id t16mr683300pjt.198.1644383398178;
        Tue, 08 Feb 2022 21:09:58 -0800 (PST)
Received: from localhost ([2620:15c:202:201:cfa3:16c3:b442:6437])
        by smtp.gmail.com with UTF8SMTPSA id rj1sm4600412pjb.49.2022.02.08.21.09.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Feb 2022 21:09:56 -0800 (PST)
From:   Gwendal Grignou <gwendal@chromium.org>
To:     srinivas.pandruvada@linux.intel.com, jikos@kernel.org
Cc:     linux-input@vger.kernel.org,
        Gwendal Grignou <gwendal@chromium.org>, stable@vger.kernel.org
Subject: [PATCH] HID: intel-ish-hid: Use dma_alloc_coherent for firmware update
Date:   Tue,  8 Feb 2022 21:09:47 -0800
Message-Id: <20220209050947.2119465-1-gwendal@chromium.org>
X-Mailer: git-send-email 2.35.0.263.gb82422642f-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
Cc: stable@vger.kernel.org
---
 drivers/hid/intel-ish-hid/ishtp-fw-loader.c | 29 +++------------------
 1 file changed, 3 insertions(+), 26 deletions(-)

diff --git a/drivers/hid/intel-ish-hid/ishtp-fw-loader.c b/drivers/hid/intel-ish-hid/ishtp-fw-loader.c
index e24988586710..16aa030af845 100644
--- a/drivers/hid/intel-ish-hid/ishtp-fw-loader.c
+++ b/drivers/hid/intel-ish-hid/ishtp-fw-loader.c
@@ -661,21 +661,12 @@ static int ish_fw_xfer_direct_dma(struct ishtp_cl_data *client_data,
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
@@ -695,14 +686,7 @@ static int ish_fw_xfer_direct_dma(struct ishtp_cl_data *client_data,
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
@@ -725,15 +709,8 @@ static int ish_fw_xfer_direct_dma(struct ishtp_cl_data *client_data,
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
 
-- 
2.35.0.263.gb82422642f-goog

