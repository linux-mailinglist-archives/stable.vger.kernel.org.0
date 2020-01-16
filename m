Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6B3CC13FFEA
	for <lists+stable@lfdr.de>; Fri, 17 Jan 2020 00:47:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731589AbgAPXqI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 18:46:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:50122 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387782AbgAPXWU (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 18:22:20 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5702C2073A;
        Thu, 16 Jan 2020 23:22:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579216939;
        bh=wHSHb/MDBqahkrdh6IvxEuw+l7mYeRaaQEPep9xZhdw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z9cbGZw+LM7M+oMuBbbd68Z+b5Odof7ujVoOPkEADDLSOTI83bVryXgiEzoYWBUpQ
         sBQDea9Poihj5l8Inxv1lgJJpXX7SEZallpNWsaSM57NKDJklo6fUgO44Paj6Ojitn
         /hlkfUDRnOV6a9rHq6GRWAqroorTJ25ue+wtUjuY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
        David Howells <dhowells@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.4 082/203] afs: Fix use-after-loss-of-ref
Date:   Fri, 17 Jan 2020 00:16:39 +0100
Message-Id: <20200116231752.179454016@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200116231745.218684830@linuxfoundation.org>
References: <20200116231745.218684830@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: David Howells <dhowells@redhat.com>

commit 40a708bd622b78582ae3d280de29b09b50bd04c0 upstream.

afs_lookup() has a tracepoint to indicate the outcome of
d_splice_alias(), passing it the inode to retrieve the fid from.
However, the function gave up its ref on that inode when it called
d_splice_alias(), which may have failed and dropped the inode.

Fix this by caching the fid.

Fixes: 80548b03991f ("afs: Add more tracepoints")
Reported-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/afs/dir.c               |   12 +++++++-----
 include/trace/events/afs.h |   12 +++---------
 2 files changed, 10 insertions(+), 14 deletions(-)

--- a/fs/afs/dir.c
+++ b/fs/afs/dir.c
@@ -908,6 +908,7 @@ static struct dentry *afs_lookup(struct
 				 unsigned int flags)
 {
 	struct afs_vnode *dvnode = AFS_FS_I(dir);
+	struct afs_fid fid = {};
 	struct inode *inode;
 	struct dentry *d;
 	struct key *key;
@@ -957,15 +958,16 @@ static struct dentry *afs_lookup(struct
 		dentry->d_fsdata =
 			(void *)(unsigned long)dvnode->status.data_version;
 	}
+
+	if (!IS_ERR_OR_NULL(inode))
+		fid = AFS_FS_I(inode)->fid;
+
 	d = d_splice_alias(inode, dentry);
 	if (!IS_ERR_OR_NULL(d)) {
 		d->d_fsdata = dentry->d_fsdata;
-		trace_afs_lookup(dvnode, &d->d_name,
-				 inode ? AFS_FS_I(inode) : NULL);
+		trace_afs_lookup(dvnode, &d->d_name, &fid);
 	} else {
-		trace_afs_lookup(dvnode, &dentry->d_name,
-				 IS_ERR_OR_NULL(inode) ? NULL
-				 : AFS_FS_I(inode));
+		trace_afs_lookup(dvnode, &dentry->d_name, &fid);
 	}
 	return d;
 }
--- a/include/trace/events/afs.h
+++ b/include/trace/events/afs.h
@@ -915,9 +915,9 @@ TRACE_EVENT(afs_call_state,
 
 TRACE_EVENT(afs_lookup,
 	    TP_PROTO(struct afs_vnode *dvnode, const struct qstr *name,
-		     struct afs_vnode *vnode),
+		     struct afs_fid *fid),
 
-	    TP_ARGS(dvnode, name, vnode),
+	    TP_ARGS(dvnode, name, fid),
 
 	    TP_STRUCT__entry(
 		    __field_struct(struct afs_fid,	dfid		)
@@ -928,13 +928,7 @@ TRACE_EVENT(afs_lookup,
 	    TP_fast_assign(
 		    int __len = min_t(int, name->len, 23);
 		    __entry->dfid = dvnode->fid;
-		    if (vnode) {
-			    __entry->fid = vnode->fid;
-		    } else {
-			    __entry->fid.vid = 0;
-			    __entry->fid.vnode = 0;
-			    __entry->fid.unique = 0;
-		    }
+		    __entry->fid = *fid;
 		    memcpy(__entry->name, name->name, __len);
 		    __entry->name[__len] = 0;
 			   ),


