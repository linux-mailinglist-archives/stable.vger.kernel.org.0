Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C14A5423E0
	for <lists+stable@lfdr.de>; Wed,  8 Jun 2022 08:51:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381589AbiFHBOs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 21:14:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1387740AbiFHAzK (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 20:55:10 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 954E319C38E;
        Tue,  7 Jun 2022 12:26:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2BCFFB8220B;
        Tue,  7 Jun 2022 19:26:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 925EAC385A5;
        Tue,  7 Jun 2022 19:26:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654629962;
        bh=NrPlRNLy3VPCTlW9T90w4oVHwZBt8gL5yWLzuJeF2n0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=j6RgJJIw8++rHFBtn3nsQD4tLRujjM12erLYFF+3Id9IGYFfADTa0ktqL3QF1asFg
         XwIaE/kZQE8q3eDduG7tv5k0b25/8ufuewA+EiBxzE9AEXykXegeDOOUl4tqYb7BQA
         PdxuePcUAMyfbe6M69QdP6he3FcXgrbuNmT0eNnk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stephen Boyd <swboyd@chromium.org>,
        Tony Lindgren <tony@atomide.com>
Subject: [PATCH 5.18 879/879] tty: n_gsm: Fix packet data hex dump output
Date:   Tue,  7 Jun 2022 19:06:37 +0200
Message-Id: <20220607165028.369214832@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607165002.659942637@linuxfoundation.org>
References: <20220607165002.659942637@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: Tony Lindgren <tony@atomide.com>

commit 925ea0fa5277c1e6bb9e51955ef34eea9736c3d7 upstream.

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
---
 drivers/tty/n_gsm.c |   31 +++++++++++++++++++++++--------
 1 file changed, 23 insertions(+), 8 deletions(-)

--- a/drivers/tty/n_gsm.c
+++ b/drivers/tty/n_gsm.c
@@ -444,6 +444,25 @@ static u8 gsm_encode_modem(const struct
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
@@ -508,7 +527,7 @@ static void gsm_print_packet(const char
 	else
 		pr_cont("(F)");
 
-	print_hex_dump_bytes("", DUMP_PREFIX_NONE, data, dlen);
+	gsm_hex_dump_bytes(NULL, data, dlen);
 }
 
 
@@ -698,9 +717,7 @@ static void gsm_data_kick(struct gsm_mux
 		}
 
 		if (debug & 4)
-			print_hex_dump_bytes("gsm_data_kick: ",
-					     DUMP_PREFIX_OFFSET,
-					     gsm->txframe, len);
+			gsm_hex_dump_bytes(__func__, gsm->txframe, len);
 		if (gsmld_output(gsm, gsm->txframe, len) <= 0)
 			break;
 		/* FIXME: Can eliminate one SOF in many more cases */
@@ -2448,8 +2465,7 @@ static int gsmld_output(struct gsm_mux *
 		return -ENOSPC;
 	}
 	if (debug & 4)
-		print_hex_dump_bytes("gsmld_output: ", DUMP_PREFIX_OFFSET,
-				     data, len);
+		gsm_hex_dump_bytes(__func__, data, len);
 	return gsm->tty->ops->write(gsm->tty, data, len);
 }
 
@@ -2525,8 +2541,7 @@ static void gsmld_receive_buf(struct tty
 	char flags = TTY_NORMAL;
 
 	if (debug & 4)
-		print_hex_dump_bytes("gsmld_receive: ", DUMP_PREFIX_OFFSET,
-				     cp, count);
+		gsm_hex_dump_bytes(__func__, cp, count);
 
 	for (; count; count--, cp++) {
 		if (fp)


