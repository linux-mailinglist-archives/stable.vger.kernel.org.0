Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3EF0354040A
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 18:47:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243262AbiFGQq7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 12:46:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232878AbiFGQq6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 12:46:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B554F5527
        for <stable@vger.kernel.org>; Tue,  7 Jun 2022 09:46:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1705061849
        for <stable@vger.kernel.org>; Tue,  7 Jun 2022 16:46:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F83CC385A5;
        Tue,  7 Jun 2022 16:46:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654620416;
        bh=qgYIUBmlV4PfX8jqaZbIg2/3Q6mNImC3CzEIUFp8QhU=;
        h=Subject:To:Cc:From:Date:From;
        b=xGlz9Nb13cbUyOVx0NK2OT4fnhB/usqmOEbrapT0jLp9d8lZucp0ZmK+V3731c3gg
         CGunnT6NVIxTe5Z4vzM9KbufLHYbR6yWeXi6haZdwN+18jrJIAMcx0IWbY9wkDbDoM
         TpyH8s71BVaWh9nwvLzAxuZ2OxDitL0NlcL8+beI=
Subject: FAILED: patch "[PATCH] tty: n_gsm: Fix packet data hex dump output" failed to apply to 5.4-stable tree
To:     tony@atomide.com, gregkh@linuxfoundation.org, swboyd@chromium.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 07 Jun 2022 18:46:53 +0200
Message-ID: <165462041322125@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 925ea0fa5277c1e6bb9e51955ef34eea9736c3d7 Mon Sep 17 00:00:00 2001
From: Tony Lindgren <tony@atomide.com>
Date: Thu, 12 May 2022 16:15:06 +0300
Subject: [PATCH] tty: n_gsm: Fix packet data hex dump output

The module param debug for n_gsm uses KERN_INFO level, but the hexdump
now uses KERN_DEBUG level. This started after commit 091cb0994edd
("lib/hexdump: make print_hex_dump_bytes() a nop on !DEBUG builds").
We now use dynamic_hex_dump() unless DEBUG is set.

This causes no packets to be seen with modprobe n_gsm debug=0x1f unlike
earlier. Let's fix this by adding gsm_hex_dump_bytes() that calls
print_hex_dump() with KERN_INFO to match what n_gsm is doing with the
other debug related output.

Fixes: 091cb0994edd ("lib/hexdump: make print_hex_dump_bytes() a nop on !DEBUG builds")
Cc: Stephen Boyd <swboyd@chromium.org>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Link: https://lore.kernel.org/r/20220512131506.1216-1-tony@atomide.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

diff --git a/drivers/tty/n_gsm.c b/drivers/tty/n_gsm.c
index 8fc05b60ac7f..137eebdcfda9 100644
--- a/drivers/tty/n_gsm.c
+++ b/drivers/tty/n_gsm.c
@@ -444,6 +444,25 @@ static u8 gsm_encode_modem(const struct gsm_dlci *dlci)
 	return modembits;
 }
 
+static void gsm_hex_dump_bytes(const char *fname, const u8 *data,
+			       unsigned long len)
+{
+	char *prefix;
+
+	if (!fname) {
+		print_hex_dump(KERN_INFO, "", DUMP_PREFIX_NONE, 16, 1, data, len,
+			       true);
+		return;
+	}
+
+	prefix = kasprintf(GFP_KERNEL, "%s: ", fname);
+	if (!prefix)
+		return;
+	print_hex_dump(KERN_INFO, prefix, DUMP_PREFIX_OFFSET, 16, 1, data, len,
+		       true);
+	kfree(prefix);
+}
+
 /**
  *	gsm_print_packet	-	display a frame for debug
  *	@hdr: header to print before decode
@@ -508,7 +527,7 @@ static void gsm_print_packet(const char *hdr, int addr, int cr,
 	else
 		pr_cont("(F)");
 
-	print_hex_dump_bytes("", DUMP_PREFIX_NONE, data, dlen);
+	gsm_hex_dump_bytes(NULL, data, dlen);
 }
 
 
@@ -698,9 +717,7 @@ static void gsm_data_kick(struct gsm_mux *gsm, struct gsm_dlci *dlci)
 		}
 
 		if (debug & 4)
-			print_hex_dump_bytes("gsm_data_kick: ",
-					     DUMP_PREFIX_OFFSET,
-					     gsm->txframe, len);
+			gsm_hex_dump_bytes(__func__, gsm->txframe, len);
 		if (gsmld_output(gsm, gsm->txframe, len) <= 0)
 			break;
 		/* FIXME: Can eliminate one SOF in many more cases */
@@ -2444,8 +2461,7 @@ static int gsmld_output(struct gsm_mux *gsm, u8 *data, int len)
 		return -ENOSPC;
 	}
 	if (debug & 4)
-		print_hex_dump_bytes("gsmld_output: ", DUMP_PREFIX_OFFSET,
-				     data, len);
+		gsm_hex_dump_bytes(__func__, data, len);
 	return gsm->tty->ops->write(gsm->tty, data, len);
 }
 
@@ -2521,8 +2537,7 @@ static void gsmld_receive_buf(struct tty_struct *tty, const unsigned char *cp,
 	char flags = TTY_NORMAL;
 
 	if (debug & 4)
-		print_hex_dump_bytes("gsmld_receive: ", DUMP_PREFIX_OFFSET,
-				     cp, count);
+		gsm_hex_dump_bytes(__func__, cp, count);
 
 	for (; count; count--, cp++) {
 		if (fp)

