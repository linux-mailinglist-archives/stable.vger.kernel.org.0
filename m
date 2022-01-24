Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9EDDF49808D
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 14:12:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242891AbiAXNMh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 08:12:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242813AbiAXNMg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 08:12:36 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C742C06173B
        for <stable@vger.kernel.org>; Mon, 24 Jan 2022 05:12:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 42C1CB80F98
        for <stable@vger.kernel.org>; Mon, 24 Jan 2022 13:12:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52B3DC340E1;
        Mon, 24 Jan 2022 13:12:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643029954;
        bh=2ALel0y7j2VsoFPpP4zhOjjv0v6XYl8J6/XTwtmpREU=;
        h=Subject:To:Cc:From:Date:From;
        b=M1qw4IoguFbPToHQZ3kg627UHHVIOVxnrDIc+HH1B+tqRJBeRSBCyYN6R+VhMqWBx
         5VXtqMV9rO8W2wCCK134uadfIduHv0zyrWNgfhWGhanxOGJWZMhlTp5c3cS4O0n/WR
         Nhh3DUj90zGsSe6cOj9a/ZcTk65YEnDXRM/pNdyE=
Subject: FAILED: patch "[PATCH] misc: at25: Check proper value of chip length in FRAM case" failed to apply to 5.15-stable tree
To:     andriy.shevchenko@linux.intel.com, arnd@arndb.de,
        gregkh@linuxfoundation.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 24 Jan 2022 14:12:31 +0100
Message-ID: <164302995120086@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 58589a75bba96f43b62d8069b35be081bc00d7c3 Mon Sep 17 00:00:00 2001
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Date: Thu, 25 Nov 2021 23:27:29 +0200
Subject: [PATCH] misc: at25: Check proper value of chip length in FRAM case

Obviously the byte_len value should be checked from the chip
and not from at25->chip.

Fixes: fd307a4ad332 ("nvmem: prepare basics for FRAM support")
Acked-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://lore.kernel.org/r/20211125212729.86585-4-andriy.shevchenko@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

diff --git a/drivers/misc/eeprom/at25.c b/drivers/misc/eeprom/at25.c
index f0b0efc30ee6..e21216541b0f 100644
--- a/drivers/misc/eeprom/at25.c
+++ b/drivers/misc/eeprom/at25.c
@@ -433,9 +433,9 @@ static int at25_probe(struct spi_device *spi)
 			dev_err(&spi->dev, "Error: unsupported size (id %02x)\n", id[7]);
 			return -ENODEV;
 		}
-		chip.byte_len = int_pow(2, id[7] - 0x21 + 4) * 1024;
 
-		if (at25->chip.byte_len > 64 * 1024)
+		chip.byte_len = int_pow(2, id[7] - 0x21 + 4) * 1024;
+		if (chip.byte_len > 64 * 1024)
 			at25->chip.flags |= EE_ADDR3;
 		else
 			at25->chip.flags |= EE_ADDR2;

