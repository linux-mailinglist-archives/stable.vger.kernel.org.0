Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 833926C9942
	for <lists+stable@lfdr.de>; Mon, 27 Mar 2023 03:11:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230232AbjC0BLZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 26 Mar 2023 21:11:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229710AbjC0BLY (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 26 Mar 2023 21:11:24 -0400
Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1322D44B4;
        Sun, 26 Mar 2023 18:11:23 -0700 (PDT)
Received: by mail-pj1-f46.google.com with SMTP id f6-20020a17090ac28600b0023b9bf9eb63so6994060pjt.5;
        Sun, 26 Mar 2023 18:11:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679879482;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vmJi4cd9E3LuQLBQkpjSR2WRmb7t+xEFx2C9FhzFnrE=;
        b=frQ25MFgWUj38ODtjHaMDruoym+RYIP/9gGYDv2Ie7xUP3b3wLnUemg45sf9g47NMr
         2Jt9jxaApCEUbZXrno3mk03mRh8O+JkvduQKO1bU9NlZ7CLwSmT6S1FH23ohXqdiP8ee
         cLdresclHoSCOBkrx+PHyMH0J8UUcr+H8ftOy3ubG58aKNpGeVvWZNCfsN2EJhme/2DD
         Fjl70+lCsOYiNV8ZAPYmOftxej8nLtXz9z6tM934OZ53/4aULk3BIVFthcaX5HvFHSl/
         cQ1/fsRzsVh/BL327bBvVlBAmU9MY2IZywGkogH1V/cr8hANtohX/Pv4FkiRzFsdh5sk
         X62w==
X-Gm-Message-State: AAQBX9fmhLgVjuCk8QgCfE9+CggNRv0R3BKmWj9RCvScnuV/D4SHuV+h
        SDCPorrqEZoIYVRMVevb4zrv/YOZsSs=
X-Google-Smtp-Source: AKy350ZmcjxuuWlsUW3U+QP/gnmOWo4wk+/tt8BPoG50jCce8Nnrhm/w4+F+Mg2Z5/5kh2T9U8oGtQ==
X-Received: by 2002:a17:90a:8:b0:23f:ebf2:d3e9 with SMTP id 8-20020a17090a000800b0023febf2d3e9mr10720441pja.6.1679879482397;
        Sun, 26 Mar 2023 18:11:22 -0700 (PDT)
Received: from localhost ([116.128.244.169])
        by smtp.gmail.com with ESMTPSA id a12-20020a65640c000000b0050aeaf9f25csm16959791pgv.27.2023.03.26.18.11.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Mar 2023 18:11:22 -0700 (PDT)
From:   Hongyu Xie <xiehongyu1@kylinos.cn>
To:     mathias.nyman@intel.com, gregkh@linuxfoundation.org
Cc:     linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Hongyu Xie <xiehongyu1@kylinos.cn>, stable@vger.kernel.org,
        sunke <sunke@kylinos.cn>
Subject: [PATCH -next v2] usb: xhci: do not free an empty cmd ring
Date:   Mon, 27 Mar 2023 09:11:17 +0800
Message-Id: <20230327011117.33953-1-xiehongyu1@kylinos.cn>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=0.7 required=5.0 tests=FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

It was first found on HUAWEI Kirin 9006C platform with a builtin xhci
controller during stress cycle test(stress-ng, glmark2, x11perf, S4...).

phase one:
[26788.706878] PM: dpm_run_callback(): platform_pm_thaw+0x0/0x68 returns -12
[26788.706878] PM: Device xhci-hcd.1.auto failed to thaw async: error -12
...
phase two:
[28650.583496] [2023:01:19 04:43:29]Unable to handle kernel NULL pointer dereference at virtual address 0000000000000028
...
[28650.583526] user pgtable: 4k pages, 39-bit VAs, pgdp=000000027862a000
[28650.583557] [0000000000000028] pgd=0000000000000000
...
[28650.583587] pc : xhci_suspend+0x154/0x5b0
[28650.583618] lr : xhci_suspend+0x148/0x5b0
[28650.583618] sp : ffffffc01c7ebbd0
[28650.583618] x29: ffffffc01c7ebbd0 x28: ffffffec834d0000
[28650.583618] x27: ffffffc0106a3cc8 x26: ffffffb2c540c848
[28650.583618] x25: 0000000000000000 x24: ffffffec82ee30b0
[28650.583618] x23: ffffffb43b31c2f8 x22: 0000000000000000
[28650.583618] x21: 0000000000000000 x20: ffffffb43b31c000
[28650.583648] x19: ffffffb43b31c2a8 x18: 0000000000000001
[28650.583648] x17: 0000000000000803 x16: 00000000fffffffe
[28650.583648] x15: 0000000000001000 x14: ffffffb150b67e00
[28650.583648] x13: 00000000f0000000 x12: 0000000000000001
[28650.583648] x11: 0000000000000000 x10: 0000000000000a80
[28650.583648] x9 : ffffffc01c7eba00 x8 : ffffffb43ad10ae0
[28650.583648] x7 : ffffffb84cd98dc0 x6 : 0000000cceb6a101
[28650.583679] x5 : 00ffffffffffffff x4 : 0000000000000001
[28650.583679] x3 : 0000000000000011 x2 : 0000000000e2cfa8
[28650.583679] x1 : 00000000823535e1 x0 : 0000000000000000

gdb:
(gdb) l *(xhci_suspend+0x154)
0xffffffc010b6cd44 is in xhci_suspend (/.../drivers/usb/host/xhci.c:854).
849	{
850		struct xhci_ring *ring;
851		struct xhci_segment *seg;
852
853		ring = xhci->cmd_ring;
854		seg = ring->deq_seg;
(gdb) disassemble 0xffffffc010b6cd44
...
0xffffffc010b6cd40 <+336>:	ldr	x22, [x19, #160]
0xffffffc010b6cd44 <+340>:	ldr	x20, [x22, #40]
0xffffffc010b6cd48 <+344>:	mov	w1, #0x0                   	// #0

During phase one, platform_pm_thaw called xhci_plat_resume which called
xhci_resume. The rest possible calling routine might be
xhci_resume->xhci_init->xhci_mem_init, and xhci->cmd_ring was cleaned in
xhci_mem_cleanup before xhci_mem_init returned -ENOMEM.

During phase two, systemd was tring to hibernate again and called
xhci_suspend, then xhci_clear_command_ring dereferenced xhci->cmd_ring
which was already NULL.

So if xhci->cmd_ring is NULL, xhci_clear_command_ring just return.

Fixes: 898213200cba ("xhci: Fix command ring replay after resume.")
Cc: stable@vger.kernel.org # 2.6.27+
Co-developed-by: sunke <sunke@kylinos.cn>
Signed-off-by: sunke <sunke@kylinos.cn>
Signed-off-by: Hongyu Xie <xiehongyu1@kylinos.cn>
---

v2: add fixes

 drivers/usb/host/xhci.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
index 6183ce8574b1..faa0a63671f6 100644
--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -920,6 +920,11 @@ static void xhci_clear_command_ring(struct xhci_hcd *xhci)
 	struct xhci_ring *ring;
 	struct xhci_segment *seg;
 
+	if (!xhci->cmd_ring) {
+		xhci_err(xhci, "Empty cmd ring");
+		return;
+	}
+
 	ring = xhci->cmd_ring;
 	seg = ring->deq_seg;
 	do {
-- 
2.34.1

