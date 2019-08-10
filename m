Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 06A6D88E08
	for <lists+stable@lfdr.de>; Sat, 10 Aug 2019 22:51:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726693AbfHJUvM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Aug 2019 16:51:12 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:54334 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726675AbfHJUny (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 10 Aug 2019 16:43:54 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1hwYDP-00053e-Qa; Sat, 10 Aug 2019 21:43:51 +0100
Received: from ben by deadeye with local (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1hwYDM-0003gu-Sh; Sat, 10 Aug 2019 21:43:48 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Yan, Zheng" <zyan@redhat.com>, "Jeff Layton" <jlayton@kernel.org>,
        "Ilya Dryomov" <idryomov@gmail.com>
Date:   Sat, 10 Aug 2019 21:40:07 +0100
Message-ID: <lsq.1565469607.577417958@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 104/157] ceph: ensure d_name stability in
 ceph_dentry_hash()
In-Reply-To: <lsq.1565469607.188083258@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.72-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Jeff Layton <jlayton@kernel.org>

commit 76a495d666e5043ffc315695f8241f5e94a98849 upstream.

Take the d_lock here to ensure that d_name doesn't change.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
Reviewed-by: "Yan, Zheng" <zyan@redhat.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/ceph/dir.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/fs/ceph/dir.c
+++ b/fs/ceph/dir.c
@@ -1327,6 +1327,7 @@ void ceph_dentry_lru_del(struct dentry *
 unsigned ceph_dentry_hash(struct inode *dir, struct dentry *dn)
 {
 	struct ceph_inode_info *dci = ceph_inode(dir);
+	unsigned hash;
 
 	switch (dci->i_dir_layout.dl_dir_hash) {
 	case 0:	/* for backward compat */
@@ -1334,8 +1335,11 @@ unsigned ceph_dentry_hash(struct inode *
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
 

