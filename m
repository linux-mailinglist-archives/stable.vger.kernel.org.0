Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4ACC7B923C
	for <lists+stable@lfdr.de>; Fri, 20 Sep 2019 16:31:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390835AbfITOas (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Sep 2019 10:30:48 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:36964 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388424AbfITOZR (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 20 Sep 2019 10:25:17 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1iBJqT-00050v-Kp; Fri, 20 Sep 2019 15:25:13 +0100
Received: from ben by deadeye with local (Exim 4.92.1)
        (envelope-from <ben@decadent.org.uk>)
        id 1iBJqE-0007sQ-8D; Fri, 20 Sep 2019 15:24:58 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Dan Carpenter" <dan.carpenter@oracle.com>,
        "kbuild test robot" <lkp@intel.com>,
        "Liu Bo" <bo.liu@linux.alibaba.com>,
        "Miklos Szeredi" <mszeredi@redhat.com>
Date:   Fri, 20 Sep 2019 15:23:35 +0100
Message-ID: <lsq.1568989415.483469251@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 048/132] fuse: fallocate: fix return with locked inode
In-Reply-To: <lsq.1568989414.954567518@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.74-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Miklos Szeredi <mszeredi@redhat.com>

commit 35d6fcbb7c3e296a52136347346a698a35af3fda upstream.

Do the proper cleanup in case the size check fails.

Tested with xfstests:generic/228

Reported-by: kbuild test robot <lkp@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Fixes: 0cbade024ba5 ("fuse: honor RLIMIT_FSIZE in fuse_file_fallocate")
Cc: Liu Bo <bo.liu@linux.alibaba.com>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/fuse/file.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -3021,7 +3021,7 @@ static long fuse_file_fallocate(struct f
 	    offset + length > i_size_read(inode)) {
 		err = inode_newsize_ok(inode, offset + length);
 		if (err)
-			return err;
+			goto out;
 	}
 
 	if (!(mode & FALLOC_FL_KEEP_SIZE))

