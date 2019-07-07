Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 88404616BC
	for <lists+stable@lfdr.de>; Sun,  7 Jul 2019 21:42:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727631AbfGGTiN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Jul 2019 15:38:13 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:57608 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727611AbfGGTiM (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 7 Jul 2019 15:38:12 -0400
Received: from 94.197.121.43.threembb.co.uk ([94.197.121.43] helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1hkCz9-0006kW-F0; Sun, 07 Jul 2019 20:38:07 +0100
Received: from ben by deadeye with local (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1hkCz7-0005eH-Gs; Sun, 07 Jul 2019 20:38:05 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "NeilBrown" <neilb@suse.com>,
        "J. Bruce Fields" <bfields@redhat.com>
Date:   Sun, 07 Jul 2019 17:54:17 +0100
Message-ID: <lsq.1562518457.225073674@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 099/129] nfsd: fix memory corruption caused by readdir
In-Reply-To: <lsq.1562518456.876074874@decadent.org.uk>
X-SA-Exim-Connect-IP: 94.197.121.43
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.70-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: NeilBrown <neilb@suse.com>

commit b602345da6cbb135ba68cf042df8ec9a73da7981 upstream.

If the result of an NFSv3 readdir{,plus} request results in the
"offset" on one entry having to be split across 2 pages, and is sized
so that the next directory entry doesn't fit in the requested size,
then memory corruption can happen.

When encode_entry() is called after encoding the last entry that fits,
it notices that ->offset and ->offset1 are set, and so stores the
offset value in the two pages as required.  It clears ->offset1 but
*does not* clear ->offset.

Normally this omission doesn't matter as encode_entry_baggage() will
be called, and will set ->offset to a suitable value (not on a page
boundary).
But in the case where cd->buflen < elen and nfserr_toosmall is
returned, ->offset is not reset.

This means that nfsd3proc_readdirplus will see ->offset with a value 4
bytes before the end of a page, and ->offset1 set to NULL.
It will try to write 8bytes to ->offset.
If we are lucky, the next page will be read-only, and the system will
  BUG: unable to handle kernel paging request at...

If we are unlucky, some innocent page will have the first 4 bytes
corrupted.

nfsd3proc_readdir() doesn't even check for ->offset1, it just blindly
writes 8 bytes to the offset wherever it is.

Fix this by clearing ->offset after it is used, and copying the
->offset handling code from nfsd3_proc_readdirplus into
nfsd3_proc_readdir.

(Note that the commit hash in the Fixes tag is from the 'history'
 tree - this bug predates git).

Fixes: 0b1d57cf7654 ("[PATCH] kNFSd: Fix nfs3 dentry encoding")
Fixes-URL: https://git.kernel.org/pub/scm/linux/kernel/git/history/history.git/commit/?id=0b1d57cf7654
Signed-off-by: NeilBrown <neilb@suse.com>
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/nfsd/nfs3proc.c | 16 ++++++++++++++--
 fs/nfsd/nfs3xdr.c  |  1 +
 2 files changed, 15 insertions(+), 2 deletions(-)

--- a/fs/nfsd/nfs3proc.c
+++ b/fs/nfsd/nfs3proc.c
@@ -440,8 +440,19 @@ nfsd3_proc_readdir(struct svc_rqst *rqst
 					&resp->common, nfs3svc_encode_entry);
 	memcpy(resp->verf, argp->verf, 8);
 	resp->count = resp->buffer - argp->buffer;
-	if (resp->offset)
-		xdr_encode_hyper(resp->offset, argp->cookie);
+	if (resp->offset) {
+		loff_t offset = argp->cookie;
+
+		if (unlikely(resp->offset1)) {
+			/* we ended up with offset on a page boundary */
+			*resp->offset = htonl(offset >> 32);
+			*resp->offset1 = htonl(offset & 0xffffffff);
+			resp->offset1 = NULL;
+		} else {
+			xdr_encode_hyper(resp->offset, offset);
+		}
+		resp->offset = NULL;
+	}
 
 	RETURN_STATUS(nfserr);
 }
@@ -501,6 +512,7 @@ nfsd3_proc_readdirplus(struct svc_rqst *
 		} else {
 			xdr_encode_hyper(resp->offset, offset);
 		}
+		resp->offset = NULL;
 	}
 
 	RETURN_STATUS(nfserr);
--- a/fs/nfsd/nfs3xdr.c
+++ b/fs/nfsd/nfs3xdr.c
@@ -909,6 +909,7 @@ encode_entry(struct readdir_cd *ccd, con
 		} else {
 			xdr_encode_hyper(cd->offset, offset64);
 		}
+		cd->offset = NULL;
 	}
 
 	/*

