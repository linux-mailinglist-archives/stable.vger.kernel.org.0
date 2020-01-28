Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1BAC814BBBD
	for <lists+stable@lfdr.de>; Tue, 28 Jan 2020 15:49:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726166AbgA1OsX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jan 2020 09:48:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:48938 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726766AbgA1OCf (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Jan 2020 09:02:35 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0BA8024695;
        Tue, 28 Jan 2020 14:02:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580220154;
        bh=jFBkBZpR37Xa506YkLZCDaF6CQW7L2QeG0BSlqy/7Fc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0QFGBWnViUzI8nRODgViJUaF6nLzTpw6pnJDKAIe+DpTLoyQ3BUuEb/CObgtGti9Q
         UuRg2KxQJUzblwm87YL808+aKk9IN83bXHevd/QI/KvyzdzRPGL4FK/xKkMHL6Uf36
         r9V7WLztZDMFAOG5c4XylOimKN/dmaWo1qC43264=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jeff Layton <jlayton@kernel.org>,
        "Yan, Zheng" <zyan@redhat.com>, Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH 5.4 037/104] ceph: hold extra reference to r_parent over life of request
Date:   Tue, 28 Jan 2020 14:59:58 +0100
Message-Id: <20200128135822.575355015@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200128135817.238524998@linuxfoundation.org>
References: <20200128135817.238524998@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jeff Layton <jlayton@kernel.org>

commit 9c1c2b35f1d94de8325344c2777d7ee67492db3b upstream.

Currently, we just assume that it will stick around by virtue of the
submitter's reference, but later patches will allow the syscall to
return early and we can't rely on that reference at that point.

While I'm not aware of any reports of it, Xiubo pointed out that this
may fix a use-after-free.  If the wait for a reply times out or is
canceled via signal, and then the reply comes in after the syscall
returns, the client can end up trying to access r_parent without a
reference.

Take an extra reference to the inode when setting r_parent and release
it when releasing the request.

Cc: stable@vger.kernel.org
Signed-off-by: Jeff Layton <jlayton@kernel.org>
Reviewed-by: "Yan, Zheng" <zyan@redhat.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ceph/mds_client.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -708,8 +708,10 @@ void ceph_mdsc_release_request(struct kr
 		/* avoid calling iput_final() in mds dispatch threads */
 		ceph_async_iput(req->r_inode);
 	}
-	if (req->r_parent)
+	if (req->r_parent) {
 		ceph_put_cap_refs(ceph_inode(req->r_parent), CEPH_CAP_PIN);
+		ceph_async_iput(req->r_parent);
+	}
 	ceph_async_iput(req->r_target_inode);
 	if (req->r_dentry)
 		dput(req->r_dentry);
@@ -2670,8 +2672,10 @@ int ceph_mdsc_submit_request(struct ceph
 	/* take CAP_PIN refs for r_inode, r_parent, r_old_dentry */
 	if (req->r_inode)
 		ceph_get_cap_refs(ceph_inode(req->r_inode), CEPH_CAP_PIN);
-	if (req->r_parent)
+	if (req->r_parent) {
 		ceph_get_cap_refs(ceph_inode(req->r_parent), CEPH_CAP_PIN);
+		ihold(req->r_parent);
+	}
 	if (req->r_old_dentry_dir)
 		ceph_get_cap_refs(ceph_inode(req->r_old_dentry_dir),
 				  CEPH_CAP_PIN);


