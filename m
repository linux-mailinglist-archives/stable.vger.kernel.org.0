Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C006B2F9F96
	for <lists+stable@lfdr.de>; Mon, 18 Jan 2021 13:28:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391529AbhARM1q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Jan 2021 07:27:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:39666 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390742AbhARLps (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Jan 2021 06:45:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 39AC222D5B;
        Mon, 18 Jan 2021 11:45:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610970309;
        bh=/MUsu1DWYlQO9bYa2zWmidsizrbsz7Epreia6rBVOqI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jG90e7iwETQT03m24EmpLq32VEeZSe8Semow59/7mQcTxIv7ADv5ErsA+THWJoArN
         LYcpTxij9XdTrvMnThkgxg2FKFEmEIAqzQcyG8V1b0qw95osOa97aa1QqiHB2Tl28S
         4pSGtn/P/ivW8zQ1OMu2cUSGU7MAWBrMjDI8PHxw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Scott Mayhew <smayhew@redhat.com>,
        Benjamin Coddington <bcodding@redhat.com>,
        Trond Myklebust <trond.myklebust@hammerspace.com>
Subject: [PATCH 5.10 125/152] NFS: Adjust fs_context error logging
Date:   Mon, 18 Jan 2021 12:35:00 +0100
Message-Id: <20210118113358.717569317@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210118113352.764293297@linuxfoundation.org>
References: <20210118113352.764293297@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Scott Mayhew <smayhew@redhat.com>

commit c98e9daa59a611ff4e163689815f40380c912415 upstream.

Several existing dprink()/dfprintk() calls were converted to use the new
mount API logging macros by commit ce8866f0913f ("NFS: Attach
supplementary error information to fs_context").  If the fs_context was
not created using fsopen() then it will not have had a log buffer
allocated for it, and the new mount API logging macros will wind up
calling printk().

This can result in syslog messages being logged where previously there
were none... most notably "NFS4: Couldn't follow remote path", which can
happen if the client is auto-negotiating a protocol version with an NFS
server that doesn't support the higher v4.x versions.

Convert the nfs_errorf(), nfs_invalf(), and nfs_warnf() macros to check
for the existence of the fs_context's log buffer and call dprintk() if
it doesn't exist.  Add nfs_ferrorf(), nfs_finvalf(), and nfs_warnf(),
which do the same thing but take an NFS debug flag as an argument and
call dfprintk().  Finally, modify the "NFS4: Couldn't follow remote
path" message to use nfs_ferrorf().

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=207385
Signed-off-by: Scott Mayhew <smayhew@redhat.com>
Reviewed-by: Benjamin Coddington <bcodding@redhat.com>
Fixes: ce8866f0913f ("NFS: Attach supplementary error information to fs_context.")
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/nfs/internal.h  |   26 +++++++++++++++++++++++---
 fs/nfs/nfs4super.c |    4 ++--
 2 files changed, 25 insertions(+), 5 deletions(-)

--- a/fs/nfs/internal.h
+++ b/fs/nfs/internal.h
@@ -142,9 +142,29 @@ struct nfs_fs_context {
 	} clone_data;
 };
 
-#define nfs_errorf(fc, fmt, ...) errorf(fc, fmt, ## __VA_ARGS__)
-#define nfs_invalf(fc, fmt, ...) invalf(fc, fmt, ## __VA_ARGS__)
-#define nfs_warnf(fc, fmt, ...) warnf(fc, fmt, ## __VA_ARGS__)
+#define nfs_errorf(fc, fmt, ...) ((fc)->log.log ?		\
+	errorf(fc, fmt, ## __VA_ARGS__) :			\
+	({ dprintk(fmt "\n", ## __VA_ARGS__); }))
+
+#define nfs_ferrorf(fc, fac, fmt, ...) ((fc)->log.log ?		\
+	errorf(fc, fmt, ## __VA_ARGS__) :			\
+	({ dfprintk(fac, fmt "\n", ## __VA_ARGS__); }))
+
+#define nfs_invalf(fc, fmt, ...) ((fc)->log.log ?		\
+	invalf(fc, fmt, ## __VA_ARGS__) :			\
+	({ dprintk(fmt "\n", ## __VA_ARGS__);  -EINVAL; }))
+
+#define nfs_finvalf(fc, fac, fmt, ...) ((fc)->log.log ?		\
+	invalf(fc, fmt, ## __VA_ARGS__) :			\
+	({ dfprintk(fac, fmt "\n", ## __VA_ARGS__);  -EINVAL; }))
+
+#define nfs_warnf(fc, fmt, ...) ((fc)->log.log ?		\
+	warnf(fc, fmt, ## __VA_ARGS__) :			\
+	({ dprintk(fmt "\n", ## __VA_ARGS__); }))
+
+#define nfs_fwarnf(fc, fac, fmt, ...) ((fc)->log.log ?		\
+	warnf(fc, fmt, ## __VA_ARGS__) :			\
+	({ dfprintk(fac, fmt "\n", ## __VA_ARGS__); }))
 
 static inline struct nfs_fs_context *nfs_fc2context(const struct fs_context *fc)
 {
--- a/fs/nfs/nfs4super.c
+++ b/fs/nfs/nfs4super.c
@@ -227,7 +227,7 @@ int nfs4_try_get_tree(struct fs_context
 			   fc, ctx->nfs_server.hostname,
 			   ctx->nfs_server.export_path);
 	if (err) {
-		nfs_errorf(fc, "NFS4: Couldn't follow remote path");
+		nfs_ferrorf(fc, MOUNT, "NFS4: Couldn't follow remote path");
 		dfprintk(MOUNT, "<-- nfs4_try_get_tree() = %d [error]\n", err);
 	} else {
 		dfprintk(MOUNT, "<-- nfs4_try_get_tree() = 0\n");
@@ -250,7 +250,7 @@ int nfs4_get_referral_tree(struct fs_con
 			    fc, ctx->nfs_server.hostname,
 			    ctx->nfs_server.export_path);
 	if (err) {
-		nfs_errorf(fc, "NFS4: Couldn't follow remote path");
+		nfs_ferrorf(fc, MOUNT, "NFS4: Couldn't follow remote path");
 		dfprintk(MOUNT, "<-- nfs4_get_referral_tree() = %d [error]\n", err);
 	} else {
 		dfprintk(MOUNT, "<-- nfs4_get_referral_tree() = 0\n");


