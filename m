Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B48161B408A
	for <lists+stable@lfdr.de>; Wed, 22 Apr 2020 12:46:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726050AbgDVKqa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Apr 2020 06:46:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:52952 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728680AbgDVKQ6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Apr 2020 06:16:58 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B641E2070B;
        Wed, 22 Apr 2020 10:16:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587550618;
        bh=USHL728CC5BpJX28A7ujeCdhKKJonWU+NgiTGWGo5VA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=awMgd1qHndXcdpyAdYbP7VYyGcI4x1CzlV1Mqe8QdnNPb0sYiDNw61q0AzTt8r2dU
         vdZwZBa5tIjiiXAmq8DUeW/TV0Eon6JWlTR0YRBOqCSWSOZfEANI41f0fzsK9b7A0l
         VYQXd4XmGGtbY9R1hEHzwVo5cb4QGZV6HY42xvFE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Howells <dhowells@redhat.com>
Subject: [PATCH 5.4 024/118] afs: Fix missing XDR advance in xdr_decode_{AFS,YFS}FSFetchStatus()
Date:   Wed, 22 Apr 2020 11:56:25 +0200
Message-Id: <20200422095035.778695497@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200422095031.522502705@linuxfoundation.org>
References: <20200422095031.522502705@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Howells <dhowells@redhat.com>

commit c72057b56f7e24865840a6961d801a7f21d30a5f upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/afs/fsclient.c  |   14 +++++++++-----
 fs/afs/yfsclient.c |   12 ++++++++----
 2 files changed, 17 insertions(+), 9 deletions(-)

--- a/fs/afs/fsclient.c
+++ b/fs/afs/fsclient.c
@@ -65,6 +65,7 @@ static int xdr_decode_AFSFetchStatus(con
 	bool inline_error = (call->operation_ID == afs_FS_InlineBulkStatus);
 	u64 data_version, size;
 	u32 type, abort_code;
+	int ret;
 
 	abort_code = ntohl(xdr->abort_code);
 
@@ -78,7 +79,7 @@ static int xdr_decode_AFSFetchStatus(con
 			 */
 			status->abort_code = abort_code;
 			scb->have_error = true;
-			return 0;
+			goto good;
 		}
 
 		pr_warn("Unknown AFSFetchStatus version %u\n", ntohl(xdr->if_version));
@@ -87,7 +88,7 @@ static int xdr_decode_AFSFetchStatus(con
 
 	if (abort_code != 0 && inline_error) {
 		status->abort_code = abort_code;
-		return 0;
+		goto good;
 	}
 
 	type = ntohl(xdr->type);
@@ -123,13 +124,16 @@ static int xdr_decode_AFSFetchStatus(con
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
--- a/fs/afs/yfsclient.c
+++ b/fs/afs/yfsclient.c
@@ -186,13 +186,14 @@ static int xdr_decode_YFSFetchStatus(con
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
@@ -220,13 +221,16 @@ static int xdr_decode_YFSFetchStatus(con
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


