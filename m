Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 815A2E5300
	for <lists+stable@lfdr.de>; Fri, 25 Oct 2019 20:06:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731549AbfJYSGv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Oct 2019 14:06:51 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46586 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731352AbfJYSFk (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Oct 2019 14:05:40 -0400
Received: from [167.98.27.226] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1iO3xv-0008OC-Jp; Fri, 25 Oct 2019 19:05:35 +0100
Received: from ben by deadeye with local (Exim 4.92.2)
        (envelope-from <ben@decadent.org.uk>)
        id 1iO3xu-0001hZ-Pp; Fri, 25 Oct 2019 19:05:34 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Tyler Hicks" <tyhicks@canonical.com>,
        "Dan Carpenter" <dan.carpenter@oracle.com>
Date:   Fri, 25 Oct 2019 19:03:02 +0100
Message-ID: <lsq.1572026582.20915405@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 01/47] eCryptfs: fix a couple type promotion bugs
In-Reply-To: <lsq.1572026581.992411028@decadent.org.uk>
X-SA-Exim-Connect-IP: 167.98.27.226
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.76-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@oracle.com>

commit 0bdf8a8245fdea6f075a5fede833a5fcf1b3466c upstream.

ECRYPTFS_SIZE_AND_MARKER_BYTES is type size_t, so if "rc" is negative
that gets type promoted to a high positive value and treated as success.

Fixes: 778aeb42a708 ("eCryptfs: Cleanup and optimize ecryptfs_lookup_interpose()")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
[tyhicks: Use "if/else if" rather than "if/if"]
Signed-off-by: Tyler Hicks <tyhicks@canonical.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/ecryptfs/crypto.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

--- a/fs/ecryptfs/crypto.c
+++ b/fs/ecryptfs/crypto.c
@@ -1042,8 +1042,10 @@ int ecryptfs_read_and_validate_header_re
 
 	rc = ecryptfs_read_lower(file_size, 0, ECRYPTFS_SIZE_AND_MARKER_BYTES,
 				 inode);
-	if (rc < ECRYPTFS_SIZE_AND_MARKER_BYTES)
-		return rc >= 0 ? -EINVAL : rc;
+	if (rc < 0)
+		return rc;
+	else if (rc < ECRYPTFS_SIZE_AND_MARKER_BYTES)
+		return -EINVAL;
 	rc = ecryptfs_validate_marker(marker);
 	if (!rc)
 		ecryptfs_i_size_init(file_size, inode);
@@ -1401,8 +1403,10 @@ int ecryptfs_read_and_validate_xattr_reg
 	rc = ecryptfs_getxattr_lower(ecryptfs_dentry_to_lower(dentry),
 				     ECRYPTFS_XATTR_NAME, file_size,
 				     ECRYPTFS_SIZE_AND_MARKER_BYTES);
-	if (rc < ECRYPTFS_SIZE_AND_MARKER_BYTES)
-		return rc >= 0 ? -EINVAL : rc;
+	if (rc < 0)
+		return rc;
+	else if (rc < ECRYPTFS_SIZE_AND_MARKER_BYTES)
+		return -EINVAL;
 	rc = ecryptfs_validate_marker(marker);
 	if (!rc)
 		ecryptfs_i_size_init(file_size, inode);

