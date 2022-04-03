Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D7A34F0920
	for <lists+stable@lfdr.de>; Sun,  3 Apr 2022 13:45:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357083AbiDCLqy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 3 Apr 2022 07:46:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357067AbiDCLqv (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 3 Apr 2022 07:46:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB38425EAC
        for <stable@vger.kernel.org>; Sun,  3 Apr 2022 04:44:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7BD8D610A2
        for <stable@vger.kernel.org>; Sun,  3 Apr 2022 11:44:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 891B6C340ED;
        Sun,  3 Apr 2022 11:44:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1648986296;
        bh=PJ7nyaFWA+LEybhchj/aory28HT7QKOYHRI4rbq8CXY=;
        h=Subject:To:Cc:From:Date:From;
        b=UM7WdtKUDMQYE2RJHmWyRq0dot2aX/BkawT3zmwYMqdaWTJQbk+sWYvmlIWXS0dnC
         b7jikcc5kLRZjrbT5l//wSet36BVzs0JokJakFwoWxX43iL6lvdT5cRl3Eqnf0LDdo
         OjAWbmgoSyzIBMF52OQrgKJ+BFaJ5h6lQ99EniUE=
Subject: FAILED: patch "[PATCH] ubifs: Fix read out-of-bounds in ubifs_wbuf_write_nolock()" failed to apply to 4.14-stable tree
To:     chengzhihao1@huawei.com, kechengsong@huawei.com, richard@nod.at
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 03 Apr 2022 13:44:11 +0200
Message-ID: <164898625175163@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
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


The patch below does not apply to the 4.14-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 4f2262a334641e05f645364d5ade1f565c85f20b Mon Sep 17 00:00:00 2001
From: Zhihao Cheng <chengzhihao1@huawei.com>
Date: Mon, 27 Dec 2021 11:22:40 +0800
Subject: [PATCH] ubifs: Fix read out-of-bounds in ubifs_wbuf_write_nolock()

Function ubifs_wbuf_write_nolock() may access buf out of bounds in
following process:

ubifs_wbuf_write_nolock():
  aligned_len = ALIGN(len, 8);   // Assume len = 4089, aligned_len = 4096
  if (aligned_len <= wbuf->avail) ... // Not satisfy
  if (wbuf->used) {
    ubifs_leb_write()  // Fill some data in avail wbuf
    len -= wbuf->avail;   // len is still not 8-bytes aligned
    aligned_len -= wbuf->avail;
  }
  n = aligned_len >> c->max_write_shift;
  if (n) {
    n <<= c->max_write_shift;
    err = ubifs_leb_write(c, wbuf->lnum, buf + written,
                          wbuf->offs, n);
    // n > len, read out of bounds less than 8(n-len) bytes
  }

, which can be catched by KASAN:
  =========================================================
  BUG: KASAN: slab-out-of-bounds in ecc_sw_hamming_calculate+0x1dc/0x7d0
  Read of size 4 at addr ffff888105594ff8 by task kworker/u8:4/128
  Workqueue: writeback wb_workfn (flush-ubifs_0_0)
  Call Trace:
    kasan_report.cold+0x81/0x165
    nand_write_page_swecc+0xa9/0x160
    ubifs_leb_write+0xf2/0x1b0 [ubifs]
    ubifs_wbuf_write_nolock+0x421/0x12c0 [ubifs]
    write_head+0xdc/0x1c0 [ubifs]
    ubifs_jnl_write_inode+0x627/0x960 [ubifs]
    wb_workfn+0x8af/0xb80

Function ubifs_wbuf_write_nolock() accepts that parameter 'len' is not 8
bytes aligned, the 'len' represents the true length of buf (which is
allocated in 'ubifs_jnl_xxx', eg. ubifs_jnl_write_inode), so
ubifs_wbuf_write_nolock() must handle the length read from 'buf' carefully
to write leb safely.

Fetch a reproducer in [Link].

Fixes: 1e51764a3c2ac0 ("UBIFS: add new flash file system")
Link: https://bugzilla.kernel.org/show_bug.cgi?id=214785
Reported-by: Chengsong Ke <kechengsong@huawei.com>
Signed-off-by: Zhihao Cheng <chengzhihao1@huawei.com>
Signed-off-by: Richard Weinberger <richard@nod.at>

diff --git a/fs/ubifs/io.c b/fs/ubifs/io.c
index 789a7813f3fa..1607a3c76681 100644
--- a/fs/ubifs/io.c
+++ b/fs/ubifs/io.c
@@ -854,16 +854,42 @@ int ubifs_wbuf_write_nolock(struct ubifs_wbuf *wbuf, void *buf, int len)
 	 */
 	n = aligned_len >> c->max_write_shift;
 	if (n) {
-		n <<= c->max_write_shift;
+		int m = n - 1;
+
 		dbg_io("write %d bytes to LEB %d:%d", n, wbuf->lnum,
 		       wbuf->offs);
-		err = ubifs_leb_write(c, wbuf->lnum, buf + written,
-				      wbuf->offs, n);
+
+		if (m) {
+			/* '(n-1)<<c->max_write_shift < len' is always true. */
+			m <<= c->max_write_shift;
+			err = ubifs_leb_write(c, wbuf->lnum, buf + written,
+					      wbuf->offs, m);
+			if (err)
+				goto out;
+			wbuf->offs += m;
+			aligned_len -= m;
+			len -= m;
+			written += m;
+		}
+
+		/*
+		 * The non-written len of buf may be less than 'n' because
+		 * parameter 'len' is not 8 bytes aligned, so here we read
+		 * min(len, n) bytes from buf.
+		 */
+		n = 1 << c->max_write_shift;
+		memcpy(wbuf->buf, buf + written, min(len, n));
+		if (n > len) {
+			ubifs_assert(c, n - len < 8);
+			ubifs_pad(c, wbuf->buf + len, n - len);
+		}
+
+		err = ubifs_leb_write(c, wbuf->lnum, wbuf->buf, wbuf->offs, n);
 		if (err)
 			goto out;
 		wbuf->offs += n;
 		aligned_len -= n;
-		len -= n;
+		len -= min(len, n);
 		written += n;
 	}
 

