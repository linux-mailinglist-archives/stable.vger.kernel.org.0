Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 82AB8CA798
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 18:58:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392261AbfJCQzX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 12:55:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:39982 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406166AbfJCQwX (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 12:52:23 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BD1BD20867;
        Thu,  3 Oct 2019 16:52:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570121542;
        bh=RgbKOuX3h2QbdzinijI7/wH56GttneKB9fd77dI5Lzs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TVA+l9s4RSH8n657SnpWgp5roOZC1YyFZPdlhtBqDL4rKlwqxcdTDjXbcbGudcA0j
         S8SGUnJi5Gj11A+E+y0hpPz9WbnNWVi5Yw2l1ZIayisnrGwedo158tUpqnHemhFlv9
         ykZSDEGqPIwbttFnh5EmNEqHQ6FJ6jInM/U+fEXE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Benjamin Coddington <bcodding@redhat.com>,
        Chuck Lever <chuck.lever@oracle.com>,
        Anna Schumaker <Anna.Schumaker@Netapp.com>
Subject: [PATCH 5.3 318/344] SUNRPC: Fix buffer handling of GSS MIC without slack
Date:   Thu,  3 Oct 2019 17:54:43 +0200
Message-Id: <20191003154610.440553935@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154540.062170222@linuxfoundation.org>
References: <20191003154540.062170222@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Benjamin Coddington <bcodding@redhat.com>

commit 5f1bc39979d868a0358c683864bec3fc8395440b upstream.

The GSS Message Integrity Check data for krb5i may lie partially in the XDR
reply buffer's pages and tail.  If so, we try to copy the entire MIC into
free space in the tail.  But as the estimations of the slack space required
for authentication and verification have improved there may be less free
space in the tail to complete this copy -- see commit 2c94b8eca1a2
("SUNRPC: Use au_rslack when computing reply buffer size").  In fact, there
may only be room in the tail for a single copy of the MIC, and not part of
the MIC and then another complete copy.

The real world failure reported is that `ls` of a directory on NFS may
sometimes return -EIO, which can be traced back to xdr_buf_read_netobj()
failing to find available free space in the tail to copy the MIC.

Fix this by checking for the case of the MIC crossing the boundaries of
head, pages, and tail. If so, shift the buffer until the MIC is contained
completely within the pages or tail.  This allows the remainder of the
function to create a sub buffer that directly address the complete MIC.

Signed-off-by: Benjamin Coddington <bcodding@redhat.com>
Cc: stable@vger.kernel.org # v5.1
Reviewed-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/sunrpc/xdr.c |   27 ++++++++++++++++++---------
 1 file changed, 18 insertions(+), 9 deletions(-)

--- a/net/sunrpc/xdr.c
+++ b/net/sunrpc/xdr.c
@@ -1237,16 +1237,29 @@ xdr_encode_word(struct xdr_buf *buf, uns
 EXPORT_SYMBOL_GPL(xdr_encode_word);
 
 /* If the netobj starting offset bytes from the start of xdr_buf is contained
- * entirely in the head or the tail, set object to point to it; otherwise
- * try to find space for it at the end of the tail, copy it there, and
- * set obj to point to it. */
+ * entirely in the head, pages, or tail, set object to point to it; otherwise
+ * shift the buffer until it is contained entirely within the pages or tail.
+ */
 int xdr_buf_read_netobj(struct xdr_buf *buf, struct xdr_netobj *obj, unsigned int offset)
 {
 	struct xdr_buf subbuf;
+	unsigned int boundary;
 
 	if (xdr_decode_word(buf, offset, &obj->len))
 		return -EFAULT;
-	if (xdr_buf_subsegment(buf, &subbuf, offset + 4, obj->len))
+	offset += 4;
+
+	/* Is the obj partially in the head? */
+	boundary = buf->head[0].iov_len;
+	if (offset < boundary && (offset + obj->len) > boundary)
+		xdr_shift_buf(buf, boundary - offset);
+
+	/* Is the obj partially in the pages? */
+	boundary += buf->page_len;
+	if (offset < boundary && (offset + obj->len) > boundary)
+		xdr_shrink_pagelen(buf, boundary - offset);
+
+	if (xdr_buf_subsegment(buf, &subbuf, offset, obj->len))
 		return -EFAULT;
 
 	/* Is the obj contained entirely in the head? */
@@ -1258,11 +1271,7 @@ int xdr_buf_read_netobj(struct xdr_buf *
 	if (subbuf.tail[0].iov_len == obj->len)
 		return 0;
 
-	/* use end of tail as storage for obj:
-	 * (We don't copy to the beginning because then we'd have
-	 * to worry about doing a potentially overlapping copy.
-	 * This assumes the object is at most half the length of the
-	 * tail.) */
+	/* Find a contiguous area in @buf to hold all of @obj */
 	if (obj->len > buf->buflen - buf->len)
 		return -ENOMEM;
 	if (buf->tail[0].iov_len != 0)


