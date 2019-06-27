Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A7A9357FCF
	for <lists+stable@lfdr.de>; Thu, 27 Jun 2019 12:01:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726308AbfF0KBY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Jun 2019 06:01:24 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:39576 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726292AbfF0KBX (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Jun 2019 06:01:23 -0400
Received: by mail-wm1-f66.google.com with SMTP id z23so5026682wma.4
        for <stable@vger.kernel.org>; Thu, 27 Jun 2019 03:01:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=R/89hwy3H2VANmKcZ4Na2wLJ+fU+uvXkm66A/DCgQuI=;
        b=FB36+Uf/LA6adXnLb+NP4ZGvb8FuHs6uocNvEX1r7yXRIoIwMFuYoCFF3GinShd+sk
         XF6XsHd1k7NX4u8XyV6x3ZvAyIsbtJAj5X9uq8a/0r7bcssLOTVZZ02JLgjZBVZuInh/
         mBgn6XF+XaKg4kgdR3tRo9Uw8P3qCrkmejtWC5tw1ppQ2XMDgHeJmGtnIKq6ppMigdZF
         7kPSJDCASkkIIx5yBTImrrIVlNENS4FK1upfg69f4C201zb9R1DJ4mevFKEIwgK6siPI
         f72uH5lg2YVtGNHN7bDVvZa71XkccPtsh1o9j7nwnG37ScwZ+vmC27Z1fToBrbJWV+8R
         Bn7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=R/89hwy3H2VANmKcZ4Na2wLJ+fU+uvXkm66A/DCgQuI=;
        b=l/BDgJitE8lZSH05pc8nBMul7yGSvMvCW+zZT9wuwZIXgzkVs8sKMKpbH0h1q2F+5Y
         7qjVFT90WJxg6l1lP0jTRCikmHyUuf83DPo+0FUKi6F9pT34S4cuQuDYjQyFkGIK44GW
         GNjX2F/PdAVltRICEMp4eE5Z+DFxbqv/X/Ge8CfNSRbX/JVlDgspAgu6SZmiOHHlgjLt
         TV5NYPYFWj7m6PBZ6BqGol+hpoFIz6RMMKUXV7FNjTI+5mhQyESozynI7Wk78Ns+vgve
         SWcj0hdkn5f2KNERlLFI1KQ+xbSat6v7z8zbM2srxaS8ve5eZa5Kya+/xYVLTkdmYGCZ
         UBXQ==
X-Gm-Message-State: APjAAAWZXpBCsh4RFvQEMxHr80DFw0n/4FgHsj6PckHT07dYjg431h81
        g0ELrVTlEBK6IpPQKuJQI/lurmQE/jM=
X-Google-Smtp-Source: APXvYqyirSGqG0kw7m0pX9ZJ9agydqa+PX9T0XHbvCv96zNoHCLwss9ReQRT0gkJ8Gr8APHnABpuVQ==
X-Received: by 2002:a1c:f20f:: with SMTP id s15mr2511636wmc.33.1561629680994;
        Thu, 27 Jun 2019 03:01:20 -0700 (PDT)
Received: from kristrev-XPS-15-9570.lan ([193.213.155.210])
        by smtp.gmail.com with ESMTPSA id u6sm6049699wml.9.2019.06.27.03.01.19
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 27 Jun 2019 03:01:20 -0700 (PDT)
From:   Kristian Evensen <kristian.evensen@gmail.com>
To:     stable@vger.kernel.org
Cc:     Kristian Evensen <kristian.evensen@gmail.com>,
        syzbot+b68605d7fadd21510de1@syzkaller.appspotmail.com,
        =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>
Subject: [PATCH] qmi_wwan: Fix out-of-bounds read
Date:   Thu, 27 Jun 2019 12:01:05 +0200
Message-Id: <20190627100105.11517-1-kristian.evensen@gmail.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 904d88d743b0c94092c5117955eab695df8109e8 upstream.

The syzbot reported

 Call Trace:
  __dump_stack lib/dump_stack.c:77 [inline]
  dump_stack+0xca/0x13e lib/dump_stack.c:113
  print_address_description+0x67/0x231 mm/kasan/report.c:188
  __kasan_report.cold+0x1a/0x32 mm/kasan/report.c:317
  kasan_report+0xe/0x20 mm/kasan/common.c:614
  qmi_wwan_probe+0x342/0x360 drivers/net/usb/qmi_wwan.c:1417
  usb_probe_interface+0x305/0x7a0 drivers/usb/core/driver.c:361
  really_probe+0x281/0x660 drivers/base/dd.c:509
  driver_probe_device+0x104/0x210 drivers/base/dd.c:670
  __device_attach_driver+0x1c2/0x220 drivers/base/dd.c:777
  bus_for_each_drv+0x15c/0x1e0 drivers/base/bus.c:454

Caused by too many confusing indirections and casts.
id->driver_info is a pointer stored in a long.  We want the
pointer here, not the address of it.

Thanks-to: Hillf Danton <hdanton@sina.com>
Reported-by: syzbot+b68605d7fadd21510de1@syzkaller.appspotmail.com
Cc: Kristian Evensen <kristian.evensen@gmail.com>
Fixes: e4bf63482c30 ("qmi_wwan: Add quirk for Quectel dynamic config")
Signed-off-by: Bjørn Mork <bjorn@mork.no>

[Upstream commit did not apply because I shuffled two lines in the
backport. The fixes tag for 4.14 is 3a6a5107ceb3.]

Signed-off-by: Kristian Evensen <kristian.evensen@gmail.com>
---
 drivers/net/usb/qmi_wwan.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/usb/qmi_wwan.c b/drivers/net/usb/qmi_wwan.c
index c2d6c501d..063daa343 100644
--- a/drivers/net/usb/qmi_wwan.c
+++ b/drivers/net/usb/qmi_wwan.c
@@ -1395,14 +1395,14 @@ static int qmi_wwan_probe(struct usb_interface *intf,
 		return -ENODEV;
 	}
 
-	info = (void *)&id->driver_info;
-
 	/* Several Quectel modems supports dynamic interface configuration, so
 	 * we need to match on class/subclass/protocol. These values are
 	 * identical for the diagnostic- and QMI-interface, but bNumEndpoints is
 	 * different. Ignore the current interface if the number of endpoints
 	 * equals the number for the diag interface (two).
 	 */
+	info = (void *)id->driver_info;
+
 	if (info->data & QMI_WWAN_QUIRK_QUECTEL_DYNCFG) {
 		if (desc->bNumEndpoints == 2)
 			return -ENODEV;
-- 
2.20.1

