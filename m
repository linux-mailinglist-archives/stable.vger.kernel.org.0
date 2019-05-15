Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 87C3F1F42E
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 14:22:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726720AbfEOK6U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 06:58:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:54506 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726744AbfEOK6S (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 May 2019 06:58:18 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7BEF721473;
        Wed, 15 May 2019 10:58:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557917898;
        bh=eD4lWYg1cJCwoLotLo5LHXxm7mpQch3sdcfjSmTMFE0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RjFd4o4DOwF6J1JGpgtZIsyTZivR5e+OFdd12ZMMwjkigKopZs3+tDyilPQlkDLH6
         w5g9SY0badNbfJFMPgoQvtE1kF45d9fswFPfKDAn/Ij06K/1O39goTnKVZaLy2I1hn
         suY9+ZLB+D+XtJnhZU8foRij2rBsvAx67/dIfnnc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jeff Layton <jlayton@kernel.org>,
        "Yan, Zheng" <zyan@redhat.com>, Ilya Dryomov <idryomov@gmail.com>
Subject: [PATCH 3.18 04/86] ceph: ensure d_name stability in ceph_dentry_hash()
Date:   Wed, 15 May 2019 12:54:41 +0200
Message-Id: <20190515090643.214149763@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190515090642.339346723@linuxfoundation.org>
References: <20190515090642.339346723@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jeff Layton <jlayton@kernel.org>

commit 76a495d666e5043ffc315695f8241f5e94a98849 upstream.

Take the d_lock here to ensure that d_name doesn't change.

Cc: stable@vger.kernel.org
Signed-off-by: Jeff Layton <jlayton@kernel.org>
Reviewed-by: "Yan, Zheng" <zyan@redhat.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/ceph/dir.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/fs/ceph/dir.c
+++ b/fs/ceph/dir.c
@@ -1308,6 +1308,7 @@ void ceph_dentry_lru_del(struct dentry *
 unsigned ceph_dentry_hash(struct inode *dir, struct dentry *dn)
 {
 	struct ceph_inode_info *dci = ceph_inode(dir);
+	unsigned hash;
 
 	switch (dci->i_dir_layout.dl_dir_hash) {
 	case 0:	/* for backward compat */
@@ -1315,8 +1316,11 @@ unsigned ceph_dentry_hash(struct inode *
 		return dn->d_name.hash;
 
 	default:
-		return ceph_str_hash(dci->i_dir_layout.dl_dir_hash,
+		spin_lock(&dn->d_lock);
+		hash = ceph_str_hash(dci->i_dir_layout.dl_dir_hash,
 				     dn->d_name.name, dn->d_name.len);
+		spin_unlock(&dn->d_lock);
+		return hash;
 	}
 }
 


