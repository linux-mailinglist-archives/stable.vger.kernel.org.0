Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8119B2A533E
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 21:59:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733051AbgKCU7F (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 15:59:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:33930 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733052AbgKCU7F (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 15:59:05 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 39B4222226;
        Tue,  3 Nov 2020 20:59:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604437144;
        bh=nKmsieHP+Q5iP8RVEYxwtSZMk69vmjd3cYIPI16zKf0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=puNZKkSaIvRKpb3fQ25GgCUTP9EtQHCKLKs/eZMXExHfrPtGe3BMl0HFQvnRjDvX+
         FYOHE8NompNOO28MfdJWWr8NvPXaR7FFnI65MQr0Z+SA+mgYMpT8SKA+qByN0O1F3m
         n0zjBUqxoiqUV7eARHEo3P5hLH1lJx/vZQmezsBM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chuck Lever <chuck.lever@oracle.com>,
        "J. Bruce Fields" <bfields@redhat.com>
Subject: [PATCH 5.4 166/214] NFSD: Add missing NFSv2 .pc_func methods
Date:   Tue,  3 Nov 2020 21:36:54 +0100
Message-Id: <20201103203306.337882350@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203249.448706377@linuxfoundation.org>
References: <20201103203249.448706377@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chuck Lever <chuck.lever@oracle.com>

commit 6b3dccd48de8a4c650b01499a0b09d1e2279649e upstream.

There's no protection in nfsd_dispatch() against a NULL .pc_func
helpers. A malicious NFS client can trigger a crash by invoking the
unused/unsupported NFSv2 ROOT or WRITECACHE procedures.

The current NFSD dispatcher does not support returning a void reply
to a non-NULL procedure, so the reply to both of these is wrong, for
the moment.

Cc: <stable@vger.kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: J. Bruce Fields <bfields@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/nfsd/nfsproc.c |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)

--- a/fs/nfsd/nfsproc.c
+++ b/fs/nfsd/nfsproc.c
@@ -118,6 +118,13 @@ done:
 	return nfsd_return_attrs(nfserr, resp);
 }
 
+/* Obsolete, replaced by MNTPROC_MNT. */
+static __be32
+nfsd_proc_root(struct svc_rqst *rqstp)
+{
+	return nfs_ok;
+}
+
 /*
  * Look up a path name component
  * Note: the dentry in the resp->fh may be negative if the file
@@ -203,6 +210,13 @@ nfsd_proc_read(struct svc_rqst *rqstp)
 	return fh_getattr(&resp->fh, &resp->stat);
 }
 
+/* Reserved */
+static __be32
+nfsd_proc_writecache(struct svc_rqst *rqstp)
+{
+	return nfs_ok;
+}
+
 /*
  * Write data to a file
  * N.B. After this call resp->fh needs an fh_put
@@ -617,6 +631,7 @@ static const struct svc_procedure nfsd_p
 		.pc_xdrressize = ST+AT,
 	},
 	[NFSPROC_ROOT] = {
+		.pc_func = nfsd_proc_root,
 		.pc_decode = nfssvc_decode_void,
 		.pc_encode = nfssvc_encode_void,
 		.pc_argsize = sizeof(struct nfsd_void),
@@ -654,6 +669,7 @@ static const struct svc_procedure nfsd_p
 		.pc_xdrressize = ST+AT+1+NFSSVC_MAXBLKSIZE_V2/4,
 	},
 	[NFSPROC_WRITECACHE] = {
+		.pc_func = nfsd_proc_writecache,
 		.pc_decode = nfssvc_decode_void,
 		.pc_encode = nfssvc_encode_void,
 		.pc_argsize = sizeof(struct nfsd_void),


