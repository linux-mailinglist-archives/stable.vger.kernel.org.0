Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C9F42F7BD4
	for <lists+stable@lfdr.de>; Fri, 15 Jan 2021 14:07:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732600AbhAONGV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jan 2021 08:06:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:37326 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732584AbhAOMbW (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 15 Jan 2021 07:31:22 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 20EA223884;
        Fri, 15 Jan 2021 12:30:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610713806;
        bh=rTDdodoFS6VeSOmu9ygZvIE0Lxa6/vIcqvRYcAPLnlY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=c9pirNs+uFq13N7fCfPBWySds/vWTc1Bge2TmuQmBDHnmvpppWiYFayA2z3VHL5Aw
         rA5SjZ1knwb1wyyqhH0uw/Su7knaC3Aa9TqJya7fQxBlwhRf/VFpY3xuROkDiYkyHh
         K44YVppolvsCjP8RpUTGo7j/o7NvrF03Q7hP4WM0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Richard Weinberger <richard@nod.at>,
        Zhihao Cheng <chengzhihao1@huawei.com>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Subject: [PATCH 4.9 12/25] ubifs: wbuf: Dont leak kernel memory to flash
Date:   Fri, 15 Jan 2021 13:27:43 +0100
Message-Id: <20210115121957.285357494@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210115121956.679956165@linuxfoundation.org>
References: <20210115121956.679956165@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Richard Weinberger <richard@nod.at>

commit 20f1431160c6b590cdc269a846fc5a448abf5b98 upstream

Write buffers use a kmalloc()'ed buffer, they can leak
up to seven bytes of kernel memory to flash if writes are not
aligned.
So use ubifs_pad() to fill these gaps with padding bytes.
This was never a problem while scanning because the scanner logic
manually aligns node lengths and skips over these gaps.

Cc: <stable@vger.kernel.org>
Fixes: 1e51764a3c2ac05a2 ("UBIFS: add new flash file system")
Signed-off-by: Richard Weinberger <richard@nod.at>
Reviewed-by: Zhihao Cheng <chengzhihao1@huawei.com>
Signed-off-by: Richard Weinberger <richard@nod.at>
[sudip: adjust context]
Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ubifs/io.c |   13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

--- a/fs/ubifs/io.c
+++ b/fs/ubifs/io.c
@@ -331,7 +331,7 @@ void ubifs_pad(const struct ubifs_info *
 {
 	uint32_t crc;
 
-	ubifs_assert(pad >= 0 && !(pad & 7));
+	ubifs_assert(pad >= 0);
 
 	if (pad >= UBIFS_PAD_NODE_SZ) {
 		struct ubifs_ch *ch = buf;
@@ -721,6 +721,10 @@ int ubifs_wbuf_write_nolock(struct ubifs
 		 * write-buffer.
 		 */
 		memcpy(wbuf->buf + wbuf->used, buf, len);
+		if (aligned_len > len) {
+			ubifs_assert(aligned_len - len < 8);
+			ubifs_pad(c, wbuf->buf + wbuf->used + len, aligned_len - len);
+		}
 
 		if (aligned_len == wbuf->avail) {
 			dbg_io("flush jhead %s wbuf to LEB %d:%d",
@@ -813,13 +817,18 @@ int ubifs_wbuf_write_nolock(struct ubifs
 	}
 
 	spin_lock(&wbuf->lock);
-	if (aligned_len)
+	if (aligned_len) {
 		/*
 		 * And now we have what's left and what does not take whole
 		 * max. write unit, so write it to the write-buffer and we are
 		 * done.
 		 */
 		memcpy(wbuf->buf, buf + written, len);
+		if (aligned_len > len) {
+			ubifs_assert(aligned_len - len < 8);
+			ubifs_pad(c, wbuf->buf + len, aligned_len - len);
+		}
+	}
 
 	if (c->leb_size - wbuf->offs >= c->max_write_size)
 		wbuf->size = c->max_write_size;


