Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8C8E6E0364
	for <lists+stable@lfdr.de>; Thu, 13 Apr 2023 02:52:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229817AbjDMAwH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Apr 2023 20:52:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229685AbjDMAwG (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Apr 2023 20:52:06 -0400
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4485729A;
        Wed, 12 Apr 2023 17:51:57 -0700 (PDT)
Received: by mail-pl1-f174.google.com with SMTP id lh8so339273plb.1;
        Wed, 12 Apr 2023 17:51:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681347117; x=1683939117;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=J2YsOnNMLvy/s09ui3ik3WufFA8bZNHkf1/NJw8wPa0=;
        b=MtRhEfLw2GPgeW2uHx5LUf2fl2L9w7dxu9yhzRgh11o6oucVLhC5elG+ZnEE/T8v6R
         l29zzH3r4msCEn+3Tnr6Hks89TLLUpJstwL7u1ovthXg4gvBVyS/MWrVseAb+lzuu1zv
         DgkTHznByDGY5MqlHANizZzH43HRZGbdwYQYD/wr6BMFU0egW/oXMqqVZaPWgY6HBlDs
         FmRq+9NGv+A6IlUU+P+ohAKSFLdHDYMtK8UojjXUYFqCPAR7e9yQrjR/AbqTASpUBm+f
         VwIXRz+GsbxiK408bCnh+uymfI6VMk+ODaDyM4yFZ0+9xkybZ7bcUb0UgnTx8H6tvQnT
         tKsg==
X-Gm-Message-State: AAQBX9c910lA/yBqd/GgDzK2apQ5iqtZfkz5iOcvnjFCRJ4kKNfeyBr0
        3GwNotXnwuniQslNtqQGBqM=
X-Google-Smtp-Source: AKy350ZRJ2va9yPx8S9CYEIjX6o6bLnyj+t5NChCwfCIw6KVozEmidyq0/T5xClL7m4tsJawZggEvg==
X-Received: by 2002:a17:902:f30d:b0:19e:e001:6a75 with SMTP id c13-20020a170902f30d00b0019ee0016a75mr299671ple.6.1681347117040;
        Wed, 12 Apr 2023 17:51:57 -0700 (PDT)
Received: from localhost ([116.128.244.169])
        by smtp.gmail.com with ESMTPSA id o12-20020a1709026b0c00b001a229e52c1asm167658plk.231.2023.04.12.17.51.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Apr 2023 17:51:56 -0700 (PDT)
From:   Hongyu Xie <xiehongyu1@kylinos.cn>
To:     mathias.nyman@linux.intel.com, mathias.nyman@intel.com,
        gregkh@linuxfoundation.org
Cc:     linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Hongyu Xie <xiehongyu1@kylinos.cn>, stable@vger.kernel.org,
        sunke <sunke@kylinos.cn>
Subject: [RESEND PATCH -next v2] usb: xhci: do not free an empty cmd ring
Date:   Thu, 13 Apr 2023 08:51:52 +0800
Message-Id: <20230413005152.30505-1-xiehongyu1@kylinos.cn>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
        autolearn_force=no version=3.4.6
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

