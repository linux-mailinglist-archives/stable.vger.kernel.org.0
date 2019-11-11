Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E9E00F7CD2
	for <lists+stable@lfdr.de>; Mon, 11 Nov 2019 19:51:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729370AbfKKSuI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Nov 2019 13:50:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:43706 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727468AbfKKSuG (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Nov 2019 13:50:06 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AF867204FD;
        Mon, 11 Nov 2019 18:50:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573498206;
        bh=bBKoEvnOK/hSzQAhfsYEOcnPvPdetAAXiI9F+EJstDk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HKo/06GBQxRFJUy5ijGNpHuH/tybTJWHOBiIzOyimbh4/tZ9tSj4C9S54hSXQSnd7
         79eGyVXJYC7e3fwlZmWL+Bmd4SRfmRCh6FV2wHgb2f+LcIFBA35sToY52BF2/ukmER
         MpeX8nmHzNl4J6V/GeQZqXGGaAdokhenVf4SzlgY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
        Jeff Layton <jlayton@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH 5.3 052/193] ceph: fix RCU case handling in ceph_d_revalidate()
Date:   Mon, 11 Nov 2019 19:27:14 +0100
Message-Id: <20191111181504.816035684@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191111181459.850623879@linuxfoundation.org>
References: <20191111181459.850623879@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Al Viro <viro@zeniv.linux.org.uk>

commit aa8dd816732b2bab28c54bc4d2ccf3fc8a6e0892 upstream.

For RCU case ->d_revalidate() is called with rcu_read_lock() and
without pinning the dentry passed to it.  Which means that it
can't rely upon ->d_inode remaining stable; that's the reason
for d_inode_rcu(), actually.

Make sure we don't reload ->d_inode there.

Cc: stable@vger.kernel.org
Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ceph/dir.c |   15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

--- a/fs/ceph/dir.c
+++ b/fs/ceph/dir.c
@@ -1553,36 +1553,37 @@ static int ceph_d_revalidate(struct dent
 {
 	int valid = 0;
 	struct dentry *parent;
-	struct inode *dir;
+	struct inode *dir, *inode;
 
 	if (flags & LOOKUP_RCU) {
 		parent = READ_ONCE(dentry->d_parent);
 		dir = d_inode_rcu(parent);
 		if (!dir)
 			return -ECHILD;
+		inode = d_inode_rcu(dentry);
 	} else {
 		parent = dget_parent(dentry);
 		dir = d_inode(parent);
+		inode = d_inode(dentry);
 	}
 
 	dout("d_revalidate %p '%pd' inode %p offset %lld\n", dentry,
-	     dentry, d_inode(dentry), ceph_dentry(dentry)->offset);
+	     dentry, inode, ceph_dentry(dentry)->offset);
 
 	/* always trust cached snapped dentries, snapdir dentry */
 	if (ceph_snap(dir) != CEPH_NOSNAP) {
 		dout("d_revalidate %p '%pd' inode %p is SNAPPED\n", dentry,
-		     dentry, d_inode(dentry));
+		     dentry, inode);
 		valid = 1;
-	} else if (d_really_is_positive(dentry) &&
-		   ceph_snap(d_inode(dentry)) == CEPH_SNAPDIR) {
+	} else if (inode && ceph_snap(inode) == CEPH_SNAPDIR) {
 		valid = 1;
 	} else {
 		valid = dentry_lease_is_valid(dentry, flags);
 		if (valid == -ECHILD)
 			return valid;
 		if (valid || dir_lease_is_valid(dir, dentry)) {
-			if (d_really_is_positive(dentry))
-				valid = ceph_is_any_caps(d_inode(dentry));
+			if (inode)
+				valid = ceph_is_any_caps(inode);
 			else
 				valid = 1;
 		}


