Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2777F122086
	for <lists+stable@lfdr.de>; Tue, 17 Dec 2019 01:57:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727658AbfLQAzl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 19:55:41 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:35320 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727053AbfLQAvn (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Dec 2019 19:51:43 -0500
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1ih15L-0003MS-3o; Tue, 17 Dec 2019 00:51:35 +0000
Received: from ben by deadeye with local (Exim 4.93-RC7)
        (envelope-from <ben@decadent.org.uk>)
        id 1ih15J-0005bZ-T5; Tue, 17 Dec 2019 00:51:33 +0000
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Jeff Layton" <jlayton@kernel.org>,
        "Al Viro" <viro@zeniv.linux.org.uk>,
        "Ilya Dryomov" <idryomov@gmail.com>
Date:   Tue, 17 Dec 2019 00:47:18 +0000
Message-ID: <lsq.1576543535.424136682@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 104/136] ceph: add missing check in d_revalidate
 snapdir handling
In-Reply-To: <lsq.1576543534.33060804@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.80-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Al Viro <viro@zeniv.linux.org.uk>

commit 1f08529c84cfecaf1261ed9b7e17fab18541c58f upstream.

We should not play with dcache without parent locked...

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
[bwh: Backported to 3.16:
 - Test ceph_mds_request::r_locked_dir
 - Adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/ceph/inode.c | 1 +
 1 file changed, 1 insertion(+)

--- a/fs/ceph/inode.c
+++ b/fs/ceph/inode.c
@@ -1260,6 +1260,7 @@ retry_lookup:
 					    req->r_request_started);
 		dout(" final dn %p\n", dn);
 	} else if (!req->r_aborted &&
+	           req->r_locked_dir &&
 		   (req->r_op == CEPH_MDS_OP_LOOKUPSNAP ||
 		    req->r_op == CEPH_MDS_OP_MKSNAP)) {
 		struct dentry *dn = req->r_dentry;

