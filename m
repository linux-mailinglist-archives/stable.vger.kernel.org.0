Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ABE18F7EA0
	for <lists+stable@lfdr.de>; Mon, 11 Nov 2019 20:06:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729360AbfKKSls (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Nov 2019 13:41:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:32886 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729418AbfKKSlr (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Nov 2019 13:41:47 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2CCF82067B;
        Mon, 11 Nov 2019 18:41:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573497706;
        bh=kXDCd+YkH9auL3wVKYv7uJB8ePTT5Ml+UvFqM1a1QKY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eMhV0cUFQzT4tfZ/NjNLZ/T+FMa6TUjlm2BxLK4p5pdRvXIYOj2igINJLj+SVY//a
         6B1pivzgRYD9ExLewpQj9h2Sjav9VllbWCc8UES17OM4DqzekKxYkvUAu32TtyM5lW
         72dHcssJYMTXYVQ0BRXMDV9TprPHKiZRKkzJSl54=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
        Jeff Layton <jlayton@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH 4.19 032/125] ceph: add missing check in d_revalidate snapdir handling
Date:   Mon, 11 Nov 2019 19:27:51 +0100
Message-Id: <20191111181444.999742255@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191111181438.945353076@linuxfoundation.org>
References: <20191111181438.945353076@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Al Viro <viro@zeniv.linux.org.uk>

commit 1f08529c84cfecaf1261ed9b7e17fab18541c58f upstream.

We should not play with dcache without parent locked...

Cc: stable@vger.kernel.org
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ceph/inode.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/ceph/inode.c
+++ b/fs/ceph/inode.c
@@ -1399,6 +1399,7 @@ retry_lookup:
 		dout(" final dn %p\n", dn);
 	} else if ((req->r_op == CEPH_MDS_OP_LOOKUPSNAP ||
 		    req->r_op == CEPH_MDS_OP_MKSNAP) &&
+	           test_bit(CEPH_MDS_R_PARENT_LOCKED, &req->r_req_flags) &&
 		   !test_bit(CEPH_MDS_R_ABORTED, &req->r_req_flags)) {
 		struct dentry *dn = req->r_dentry;
 		struct inode *dir = req->r_parent;


