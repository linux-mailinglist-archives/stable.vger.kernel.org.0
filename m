Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2867F6D71B
	for <lists+stable@lfdr.de>; Fri, 19 Jul 2019 01:07:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391704AbfGRXGc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Jul 2019 19:06:32 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:45338 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728524AbfGRXGb (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 18 Jul 2019 19:06:31 -0400
Received: by mail-pg1-f195.google.com with SMTP id o13so13540880pgp.12;
        Thu, 18 Jul 2019 16:06:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=asc29S1aXqINt/LkQnormGy5CNyyKODqHRTWf7EXfUM=;
        b=jULWg4UBJdyE/6SoUXW3r7bIr6pogyKagkfrfGgyUl++ZGwGWFk9TdD/mh4YniaOBp
         /xSs3GgGqf/NBGZLhCJN7KXf/koQBbP+dDca1bxw7op/lo4uaY7aAbGRVeo5eVPDQZMp
         1XDMBcWrHrczUobl3qPADF85UgtSodJNeRWX8yEyT0L9VFR1KT5nAHiIndJJbbg09AN+
         85ztsTLYXisx1Q4RdaGDjECprbmGtCBoknC4zrvUZIm1E81dxMAPteCYlfDBQ1cf0nme
         kg/e9M0XbIeSiMld6SINBnSRxEvfOmoFjtpRK/gwGmsTLzQnWFQWu8tpXm0mJOkRHnF1
         vubQ==
X-Gm-Message-State: APjAAAVBtO3HzGbwTRbnUuKXDRlQxumqUJuh78P0nt2hdyU1mSkXSh4J
        ktuqktstzNb9fqKN8Yq6iw8=
X-Google-Smtp-Source: APXvYqxL+jUEhMBP1njatVJZMWX4Fy/hxMTF2axokayELle6LTw0e5ztOLtTNEzs+TprMI77+hJv2Q==
X-Received: by 2002:a17:90a:17c4:: with SMTP id q62mr54823024pja.104.1563491190987;
        Thu, 18 Jul 2019 16:06:30 -0700 (PDT)
Received: from 42.do-not-panic.com (42.do-not-panic.com. [157.230.128.187])
        by smtp.gmail.com with ESMTPSA id a25sm26509765pfn.1.2019.07.18.16.06.23
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 18 Jul 2019 16:06:26 -0700 (PDT)
Received: by 42.do-not-panic.com (Postfix, from userid 1000)
        id 781B741464; Thu, 18 Jul 2019 23:06:19 +0000 (UTC)
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     linux-xfs@vger.kernel.org, gregkh@linuxfoundation.org,
        Alexander.Levin@microsoft.com
Cc:     stable@vger.kernel.org, amir73il@gmail.com, hch@infradead.org,
        zlang@redhat.com, "Darrick J. Wong" <darrick.wong@oracle.com>,
        Dave Chinner <david@fromorbit.com>,
        Brian Foster <bfoster@redhat.com>,
        Dave Chinner <dchinner@redhat.com>,
        Christoph Hellwig <hch@lst.de>,
        Luis Chamberlain <mcgrof@kernel.org>
Subject: [PATCH 9/9] xfs: abort unaligned nowait directio early
Date:   Thu, 18 Jul 2019 23:06:17 +0000
Message-Id: <20190718230617.7439-10-mcgrof@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190718230617.7439-1-mcgrof@kernel.org>
References: <20190718230617.7439-1-mcgrof@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Darrick J. Wong" <darrick.wong@oracle.com>

commit 1fdeaea4d92c69fb9f871a787af6ad00f32eeea7 upstream.

Dave Chinner noticed that xfs_file_dio_aio_write returns EAGAIN without
dropping the IOLOCK when its deciding not to wait, which means that we
leak the IOLOCK there.  Since we now make unaligned directio always
wait, we have the opportunity to bail out before trying to take the
lock, which should reduce the overhead of this never-gonna-work case
considerably while also solving the dropped lock problem.

Reported-by: Dave Chinner <david@fromorbit.com>
Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Brian Foster <bfoster@redhat.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
---
 fs/xfs/xfs_file.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/xfs/xfs_file.c b/fs/xfs/xfs_file.c
index 10f75965243c..259549698ba7 100644
--- a/fs/xfs/xfs_file.c
+++ b/fs/xfs/xfs_file.c
@@ -517,6 +517,9 @@ xfs_file_dio_aio_write(
 	}
 
 	if (iocb->ki_flags & IOCB_NOWAIT) {
+		/* unaligned dio always waits, bail */
+		if (unaligned_io)
+			return -EAGAIN;
 		if (!xfs_ilock_nowait(ip, iolock))
 			return -EAGAIN;
 	} else {
@@ -536,9 +539,6 @@ xfs_file_dio_aio_write(
 	 * xfs_file_aio_write_checks() for other reasons.
 	 */
 	if (unaligned_io) {
-		/* unaligned dio always waits, bail */
-		if (iocb->ki_flags & IOCB_NOWAIT)
-			return -EAGAIN;
 		inode_dio_wait(inode);
 	} else if (iolock == XFS_IOLOCK_EXCL) {
 		xfs_ilock_demote(ip, XFS_IOLOCK_EXCL);
-- 
2.20.1

