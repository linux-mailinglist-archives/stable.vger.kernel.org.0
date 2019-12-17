Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F39C61220DE
	for <lists+stable@lfdr.de>; Tue, 17 Dec 2019 01:58:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727918AbfLQA6e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 19:58:34 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:34822 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726757AbfLQAvi (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Dec 2019 19:51:38 -0500
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1ih15I-0003Kl-1m; Tue, 17 Dec 2019 00:51:32 +0000
Received: from ben by deadeye with local (Exim 4.93-RC7)
        (envelope-from <ben@decadent.org.uk>)
        id 1ih15H-0005Wf-OX; Tue, 17 Dec 2019 00:51:31 +0000
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Jeff Layton" <jlayton@kernel.org>,
        "Ilya Dryomov" <idryomov@gmail.com>
Date:   Tue, 17 Dec 2019 00:46:39 +0000
Message-ID: <lsq.1576543535.764911256@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 065/136] ceph: just skip unrecognized info in
 ceph_reply_info_extra
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

From: Jeff Layton <jlayton@kernel.org>

commit 1d3f87233e26362fc3d4e59f0f31a71b570f90b9 upstream.

In the future, we're going to want to extend the ceph_reply_info_extra
for create replies. Currently though, the kernel code doesn't accept an
extra blob that is larger than the expected data.

Change the code to skip over any unrecognized fields at the end of the
extra blob, rather than returning -EIO.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
[bwh: Backported to 3.16: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/ceph/mds_client.c | 21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

--- a/fs/ceph/mds_client.c
+++ b/fs/ceph/mds_client.c
@@ -199,8 +199,8 @@ static int parse_reply_info_dir(void **p
 	}
 
 done:
-	if (*p != end)
-		goto bad;
+	/* Skip over any unrecognized fields */
+	*p = end;
 	return 0;
 
 bad:
@@ -221,12 +221,10 @@ static int parse_reply_info_filelock(voi
 		goto bad;
 
 	info->filelock_reply = *p;
-	*p += sizeof(*info->filelock_reply);
 
-	if (unlikely(*p != end))
-		goto bad;
+	/* Skip over any unrecognized fields */
+	*p = end;
 	return 0;
-
 bad:
 	return -EIO;
 }
@@ -239,18 +237,21 @@ static int parse_reply_info_create(void
 				  u64 features)
 {
 	if (features & CEPH_FEATURE_REPLY_CREATE_INODE) {
+		/* Malformed reply? */
 		if (*p == end) {
 			info->has_create_ino = false;
 		} else {
 			info->has_create_ino = true;
-			info->ino = ceph_decode_64(p);
+			ceph_decode_64_safe(p, end, info->ino, bad);
 		}
+	} else {
+		if (*p != end)
+			goto bad;
 	}
 
-	if (unlikely(*p != end))
-		goto bad;
+	/* Skip over any unrecognized fields */
+	*p = end;
 	return 0;
-
 bad:
 	return -EIO;
 }

