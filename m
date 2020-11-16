Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7167D2B538D
	for <lists+stable@lfdr.de>; Mon, 16 Nov 2020 22:13:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733179AbgKPVMA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Nov 2020 16:12:00 -0500
Received: from lilium.sigma-star.at ([109.75.188.150]:54542 "EHLO
        lilium.sigma-star.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732587AbgKPVMA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Nov 2020 16:12:00 -0500
X-Greylist: delayed 369 seconds by postgrey-1.27 at vger.kernel.org; Mon, 16 Nov 2020 16:11:58 EST
Received: from localhost (localhost [127.0.0.1])
        by lilium.sigma-star.at (Postfix) with ESMTP id 3BEF61816C728;
        Mon, 16 Nov 2020 22:05:47 +0100 (CET)
Received: from lilium.sigma-star.at ([127.0.0.1])
        by localhost (lilium.sigma-star.at [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id pj4MsuSeTHU4; Mon, 16 Nov 2020 22:05:46 +0100 (CET)
Received: from lilium.sigma-star.at ([127.0.0.1])
        by localhost (lilium.sigma-star.at [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id MinQ-477CHIm; Mon, 16 Nov 2020 22:05:46 +0100 (CET)
From:   Richard Weinberger <richard@nod.at>
To:     linux-mtd@lists.infradead.org
Cc:     linux-kernel@vger.kernel.org, Richard Weinberger <richard@nod.at>,
        stable@vger.kernel.org
Subject: [PATCH] ubifs: wbuf: Don't leak kernel memory to flash
Date:   Mon, 16 Nov 2020 22:05:30 +0100
Message-Id: <20201116210530.26230-1-richard@nod.at>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Write buffers use a kmalloc()'ed buffer, they can leak
up to seven bytes of kernel memory to flash if writes are not
aligned.
So use ubifs_pad() to fill these gaps with padding bytes.
This was never a problem while scanning because the scanner logic
manually aligns node lengths and skips over these gaps.

Cc: <stable@vger.kernel.org>
Fixes: 1e51764a3c2ac05a2 ("UBIFS: add new flash file system")
Signed-off-by: Richard Weinberger <richard@nod.at>
---
 fs/ubifs/io.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/fs/ubifs/io.c b/fs/ubifs/io.c
index 7e4bfaf2871f..eae9cf5a57b0 100644
--- a/fs/ubifs/io.c
+++ b/fs/ubifs/io.c
@@ -319,7 +319,7 @@ void ubifs_pad(const struct ubifs_info *c, void *buf,=
 int pad)
 {
 	uint32_t crc;
=20
-	ubifs_assert(c, pad >=3D 0 && !(pad & 7));
+	ubifs_assert(c, pad >=3D 0);
=20
 	if (pad >=3D UBIFS_PAD_NODE_SZ) {
 		struct ubifs_ch *ch =3D buf;
@@ -764,6 +764,10 @@ int ubifs_wbuf_write_nolock(struct ubifs_wbuf *wbuf,=
 void *buf, int len)
 		 * write-buffer.
 		 */
 		memcpy(wbuf->buf + wbuf->used, buf, len);
+		if (aligned_len > len) {
+			ubifs_assert(c, aligned_len - len < 8);
+			ubifs_pad(c, wbuf->buf + wbuf->used + len, aligned_len - len);
+		}
=20
 		if (aligned_len =3D=3D wbuf->avail) {
 			dbg_io("flush jhead %s wbuf to LEB %d:%d",
@@ -856,13 +860,18 @@ int ubifs_wbuf_write_nolock(struct ubifs_wbuf *wbuf=
, void *buf, int len)
 	}
=20
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
+			ubifs_assert(c, aligned_len - len < 8);
+			ubifs_pad(c, wbuf->buf + len, aligned_len - len);
+		}
+	}
=20
 	if (c->leb_size - wbuf->offs >=3D c->max_write_size)
 		wbuf->size =3D c->max_write_size;
--=20
2.26.2

