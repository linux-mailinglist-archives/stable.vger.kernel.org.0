Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D6C465D99C
	for <lists+stable@lfdr.de>; Wed,  4 Jan 2023 17:26:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233838AbjADQ0c (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Jan 2023 11:26:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239916AbjADQ0O (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Jan 2023 11:26:14 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7031013F31
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 08:26:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1FB58B81733
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 16:26:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81564C433EF;
        Wed,  4 Jan 2023 16:26:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672849570;
        bh=2ggg8c2Xye8irSg9Anz7c2jzhmN6TIIeT0IWYrrQExA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aJOgP7k34prtPyOEyYmXXtxbpf7JFMbYZMdEhP5omN9abYgeYpnFqm4QIxlS/GM5n
         NTE8RAQz4hgsES81b6IF+s5uOUdKIQXKRMMnBajm1AA8hNLfmJKnLwn3YH1icxnkkW
         3h+6ph2q7GCDlN/aL3k6aEdFHXmp285f+AEmztBA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Helge Deller <deller@gmx.de>
Subject: [PATCH 6.0 121/177] parisc: Fix locking in pdc_iodc_print() firmware call
Date:   Wed,  4 Jan 2023 17:06:52 +0100
Message-Id: <20230104160511.308769907@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230104160507.635888536@linuxfoundation.org>
References: <20230104160507.635888536@linuxfoundation.org>
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

From: Helge Deller <deller@gmx.de>

commit 7236aae5f81f3efbd93d0601e74fc05994bc2580 upstream.

Utilize pdc_lock spinlock to protect parallel modifications of the
iodc_dbuf[] buffer, check length to prevent buffer overflow of
iodc_dbuf[], drop the iodc_retbuf[] buffer and fix some wrong
indentings.

Signed-off-by: Helge Deller <deller@gmx.de>
Cc: <stable@vger.kernel.org> # 6.0+
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/parisc/kernel/firmware.c | 24 +++++++++++++-----------
 1 file changed, 13 insertions(+), 11 deletions(-)

diff --git a/arch/parisc/kernel/firmware.c b/arch/parisc/kernel/firmware.c
index 6a7e315bcc2e..a115315d88e6 100644
--- a/arch/parisc/kernel/firmware.c
+++ b/arch/parisc/kernel/firmware.c
@@ -1288,9 +1288,8 @@ void pdc_io_reset_devices(void)
 
 #endif /* defined(BOOTLOADER) */
 
-/* locked by pdc_console_lock */
-static int __attribute__((aligned(8)))   iodc_retbuf[32];
-static char __attribute__((aligned(64))) iodc_dbuf[4096];
+/* locked by pdc_lock */
+static char iodc_dbuf[4096] __page_aligned_bss;
 
 /**
  * pdc_iodc_print - Console print using IODC.
@@ -1307,6 +1306,9 @@ int pdc_iodc_print(const unsigned char *str, unsigned count)
 	unsigned int i;
 	unsigned long flags;
 
+	count = min_t(unsigned int, count, sizeof(iodc_dbuf));
+
+	spin_lock_irqsave(&pdc_lock, flags);
 	for (i = 0; i < count;) {
 		switch(str[i]) {
 		case '\n':
@@ -1322,12 +1324,11 @@ int pdc_iodc_print(const unsigned char *str, unsigned count)
 	}
 
 print:
-        spin_lock_irqsave(&pdc_lock, flags);
-        real32_call(PAGE0->mem_cons.iodc_io,
-                    (unsigned long)PAGE0->mem_cons.hpa, ENTRY_IO_COUT,
-                    PAGE0->mem_cons.spa, __pa(PAGE0->mem_cons.dp.layers),
-                    __pa(iodc_retbuf), 0, __pa(iodc_dbuf), i, 0);
-        spin_unlock_irqrestore(&pdc_lock, flags);
+	real32_call(PAGE0->mem_cons.iodc_io,
+		(unsigned long)PAGE0->mem_cons.hpa, ENTRY_IO_COUT,
+		PAGE0->mem_cons.spa, __pa(PAGE0->mem_cons.dp.layers),
+		__pa(pdc_result), 0, __pa(iodc_dbuf), i, 0);
+	spin_unlock_irqrestore(&pdc_lock, flags);
 
 	return i;
 }
@@ -1354,10 +1355,11 @@ int pdc_iodc_getc(void)
 	real32_call(PAGE0->mem_kbd.iodc_io,
 		    (unsigned long)PAGE0->mem_kbd.hpa, ENTRY_IO_CIN,
 		    PAGE0->mem_kbd.spa, __pa(PAGE0->mem_kbd.dp.layers), 
-		    __pa(iodc_retbuf), 0, __pa(iodc_dbuf), 1, 0);
+		    __pa(pdc_result), 0, __pa(iodc_dbuf), 1, 0);
 
 	ch = *iodc_dbuf;
-	status = *iodc_retbuf;
+	/* like convert_to_wide() but for first return value only: */
+	status = *(int *)&pdc_result;
 	spin_unlock_irqrestore(&pdc_lock, flags);
 
 	if (status == 0)
-- 
2.39.0



