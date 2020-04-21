Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1CBC1B2DDD
	for <lists+stable@lfdr.de>; Tue, 21 Apr 2020 19:13:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725963AbgDURNn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Apr 2020 13:13:43 -0400
Received: from forward1-smtp.messagingengine.com ([66.111.4.223]:48509 "EHLO
        forward1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725870AbgDURNn (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Apr 2020 13:13:43 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailforward.nyi.internal (Postfix) with ESMTP id 73E3419403CA;
        Tue, 21 Apr 2020 13:13:42 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Tue, 21 Apr 2020 13:13:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=1ppH0V
        A/4oZhfdJbRXNc1CSxLSzXOaHe8FgFf4brQdY=; b=vHV1khWFKfLZYqg1OLD7WE
        zJ4gd/JQ68moz2yscdp6XFRI+oQ8RdnleharCUlsol4CCVG+Y1mF+v4Pqz10Ph1W
        kam5JG8fI3gg6n8D7g5KYz2yOhG6gpARUSdU6w1wUhWdTQTSh+2fdxK/I4FOlij6
        tNajftIhIqeWUWT+bIvoyFs51oYM2v9POexur3jTk3eTe6tZ3UQh0/kNv3GbreFw
        sTpzn/NwV40hVSuzV5gnfQ+3U8m8yLDio22HrcNBb+ErTeDZ+U1+8SgZ6u1y3YUC
        s9IGF/JJS1NQQUlytXcJUV1R16NTBqyvToLHTxdCCnkaUTjwadfzWA4dphSyIE4A
        ==
X-ME-Sender: <xms:ximfXhXitLnHAg2jdsPK8A9J980JaEhsZ5JpE7bM4goarY24w0Aehw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrgeehgddutdelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecukfhppeekfedrkeeirdekledruddtjeenucevlhhushhtvghrufhiiigvpedtne
    curfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:ximfXg5-8bZc7-3uGzgJZ8H5r7h8-JREYslyuA2505ldub_oVx2Ygw>
    <xmx:ximfXg6KsO4wzGdiSTq635STVnGT42It7IVJZhb5sZN3YCU8BHivwg>
    <xmx:ximfXsFJNowopBbf9mxkPQj38byAyLZKNwt9oO47kO3ShZQmCugW-A>
    <xmx:ximfXm5qYYc76opu-eFZKGMu5WJAt4-3kgoCpxFMh_V3kEdgW3FJfA>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 079723065C8E;
        Tue, 21 Apr 2020 13:13:41 -0400 (EDT)
Subject: FAILED: patch "[PATCH] afs: Fix missing XDR advance in" failed to apply to 4.19-stable tree
To:     dhowells@redhat.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 21 Apr 2020 19:13:41 +0200
Message-ID: <158748922120250@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.19-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From c72057b56f7e24865840a6961d801a7f21d30a5f Mon Sep 17 00:00:00 2001
From: David Howells <dhowells@redhat.com>
Date: Wed, 8 Apr 2020 16:13:20 +0100
Subject: [PATCH] afs: Fix missing XDR advance in
 xdr_decode_{AFS,YFS}FSFetchStatus()

If we receive a status record that has VNOVNODE set in the abort field,
xdr_decode_AFSFetchStatus() and xdr_decode_YFSFetchStatus() don't advance
the XDR pointer, thereby corrupting anything subsequent decodes from the
same block of data.

This has the potential to affect AFS.InlineBulkStatus and
YFS.InlineBulkStatus operation, but probably doesn't since the status
records are extracted as individual blocks of data and the buffer pointer
is reset between blocks.

It does affect YFS.RemoveFile2 operation, corrupting the volsync record -
though that is not currently used.

Other operations abort the entire operation rather than returning an error
inline, in which case there is no decoding to be done.

Fix this by unconditionally advancing the xdr pointer.

Fixes: 684b0f68cf1c ("afs: Fix AFSFetchStatus decoder to provide OpenAFS compatibility")
Signed-off-by: David Howells <dhowells@redhat.com>

diff --git a/fs/afs/fsclient.c b/fs/afs/fsclient.c
index 1f9c5d8e6fe5..fae73e13976a 100644
--- a/fs/afs/fsclient.c
+++ b/fs/afs/fsclient.c
@@ -65,6 +65,7 @@ static int xdr_decode_AFSFetchStatus(const __be32 **_bp,
 	bool inline_error = (call->operation_ID == afs_FS_InlineBulkStatus);
 	u64 data_version, size;
 	u32 type, abort_code;
+	int ret;
 
 	abort_code = ntohl(xdr->abort_code);
 
@@ -78,7 +79,7 @@ static int xdr_decode_AFSFetchStatus(const __be32 **_bp,
 			 */
 			status->abort_code = abort_code;
 			scb->have_error = true;
-			return 0;
+			goto good;
 		}
 
 		pr_warn("Unknown AFSFetchStatus version %u\n", ntohl(xdr->if_version));
@@ -87,7 +88,7 @@ static int xdr_decode_AFSFetchStatus(const __be32 **_bp,
 
 	if (abort_code != 0 && inline_error) {
 		status->abort_code = abort_code;
-		return 0;
+		goto good;
 	}
 
 	type = ntohl(xdr->type);
@@ -123,13 +124,16 @@ static int xdr_decode_AFSFetchStatus(const __be32 **_bp,
 	data_version |= (u64)ntohl(xdr->data_version_hi) << 32;
 	status->data_version = data_version;
 	scb->have_status = true;
-
+good:
+	ret = 0;
+advance:
 	*_bp = (const void *)*_bp + sizeof(*xdr);
-	return 0;
+	return ret;
 
 bad:
 	xdr_dump_bad(*_bp);
-	return afs_protocol_error(call, -EBADMSG, afs_eproto_bad_status);
+	ret = afs_protocol_error(call, -EBADMSG, afs_eproto_bad_status);
+	goto advance;
 }
 
 static time64_t xdr_decode_expiry(struct afs_call *call, u32 expiry)
diff --git a/fs/afs/yfsclient.c b/fs/afs/yfsclient.c
index a26126ac7bf1..a0f7c3186645 100644
--- a/fs/afs/yfsclient.c
+++ b/fs/afs/yfsclient.c
@@ -186,13 +186,14 @@ static int xdr_decode_YFSFetchStatus(const __be32 **_bp,
 	const struct yfs_xdr_YFSFetchStatus *xdr = (const void *)*_bp;
 	struct afs_file_status *status = &scb->status;
 	u32 type;
+	int ret;
 
 	status->abort_code = ntohl(xdr->abort_code);
 	if (status->abort_code != 0) {
 		if (status->abort_code == VNOVNODE)
 			status->nlink = 0;
 		scb->have_error = true;
-		return 0;
+		goto good;
 	}
 
 	type = ntohl(xdr->type);
@@ -220,13 +221,16 @@ static int xdr_decode_YFSFetchStatus(const __be32 **_bp,
 	status->size		= xdr_to_u64(xdr->size);
 	status->data_version	= xdr_to_u64(xdr->data_version);
 	scb->have_status	= true;
-
+good:
+	ret = 0;
+advance:
 	*_bp += xdr_size(xdr);
-	return 0;
+	return ret;
 
 bad:
 	xdr_dump_bad(*_bp);
-	return afs_protocol_error(call, -EBADMSG, afs_eproto_bad_status);
+	ret = afs_protocol_error(call, -EBADMSG, afs_eproto_bad_status);
+	goto advance;
 }
 
 /*

