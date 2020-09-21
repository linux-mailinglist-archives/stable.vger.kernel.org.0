Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF697272DB1
	for <lists+stable@lfdr.de>; Mon, 21 Sep 2020 18:42:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729504AbgIUQm1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Sep 2020 12:42:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:46446 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729494AbgIUQmX (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Sep 2020 12:42:23 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 64B6223976;
        Mon, 21 Sep 2020 16:42:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600706542;
        bh=/+g3tl0tKR2B1dR6A3fWUZXSKcXBlnnKwUTXG4CoPQA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=clCpZHJ1PwTfBdcVD7NvZqO0cN9EeNLR6GH5PhnODPfCjJ9d5xYPCz5XafqaqLknK
         YNNzvz/+arm/EnkkEaQr5xGOLOu1bV1qMs2snaW/EdQ9vOD7cSbeQYZgTTRqtRpnr6
         YkRe4mc2Fuk45Lv91w8DEbnGR5/fpimljETpspaY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chuck Lever <chuck.lever@oracle.com>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 15/49] NFS: Zero-stateid SETATTR should first return delegation
Date:   Mon, 21 Sep 2020 18:27:59 +0200
Message-Id: <20200921162035.336449230@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200921162034.660953761@linuxfoundation.org>
References: <20200921162034.660953761@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit 644c9f40cf71969f29add32f32349e71d4995c0b ]

If a write delegation isn't available, the Linux NFS client uses
a zero-stateid when performing a SETATTR.

NFSv4.0 provides no mechanism for an NFS server to match such a
request to a particular client. It recalls all delegations for that
file, even delegations held by the client issuing the request. If
that client happens to hold a read delegation, the server will
recall it immediately, resulting in an NFS4ERR_DELAY/CB_RECALL/
DELEGRETURN sequence.

Optimize out this pipeline bubble by having the client return any
delegations it may hold on a file before it issues a
SETATTR(zero-stateid) on that file.

Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/nfs4proc.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/nfs/nfs4proc.c b/fs/nfs/nfs4proc.c
index 929f1d72bfd39..b2a2ff3f22a46 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -3129,8 +3129,10 @@ static int _nfs4_do_setattr(struct inode *inode,
 
 	/* Servers should only apply open mode checks for file size changes */
 	truncate = (arg->iap->ia_valid & ATTR_SIZE) ? true : false;
-	if (!truncate)
+	if (!truncate) {
+		nfs4_inode_make_writeable(inode);
 		goto zero_stateid;
+	}
 
 	if (nfs4_copy_delegation_stateid(inode, FMODE_WRITE, &arg->stateid, &delegation_cred)) {
 		/* Use that stateid */
-- 
2.25.1



