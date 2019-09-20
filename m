Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A8CA2B9280
	for <lists+stable@lfdr.de>; Fri, 20 Sep 2019 16:33:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388283AbfITOcz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Sep 2019 10:32:55 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:36466 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2388273AbfITOZJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 20 Sep 2019 10:25:09 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1iBJqN-00051E-LP; Fri, 20 Sep 2019 15:25:07 +0100
Received: from ben by deadeye with local (Exim 4.92.1)
        (envelope-from <ben@decadent.org.uk>)
        id 1iBJqG-0007w5-98; Fri, 20 Sep 2019 15:25:00 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Lukas Czerner" <lczerner@redhat.com>,
        "Theodore Ts'o" <tytso@mit.edu>
Date:   Fri, 20 Sep 2019 15:23:35 +0100
Message-ID: <lsq.1568989415.281627329@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 093/132] ext4: fix data corruption caused by
 overlapping unaligned and aligned IO
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

From: Lukas Czerner <lczerner@redhat.com>

commit 57a0da28ced8707cb9f79f071a016b9d005caf5a upstream.

Unaligned AIO must be serialized because the zeroing of partial blocks
of unaligned AIO can result in data corruption in case it's overlapping
another in flight IO.

Currently we wait for all unwritten extents before we submit unaligned
AIO which protects data in case of unaligned AIO is following overlapping
IO. However if a unaligned AIO is followed by overlapping aligned AIO we
can still end up corrupting data.

To fix this, we must make sure that the unaligned AIO is the only IO in
flight by waiting for unwritten extents conversion not just before the
IO submission, but right after it as well.

This problem can be reproduced by xfstest generic/538

Signed-off-by: Lukas Czerner <lczerner@redhat.com>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
[bwh: Backported to 3.16:
 - Test aio_mutex instead of unaligned_aio
 - Adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/ext4/file.c | 7 +++++++
 1 file changed, 7 insertions(+)

--- a/fs/ext4/file.c
+++ b/fs/ext4/file.c
@@ -173,6 +173,13 @@ ext4_file_write_iter(struct kiocb *iocb,
 	}
 
 	ret = __generic_file_write_iter(iocb, from);
+	/*
+	 * Unaligned direct AIO must be the only IO in flight. Otherwise
+	 * overlapping aligned IO after unaligned might result in data
+	 * corruption.
+	 */
+	if (ret == -EIOCBQUEUED && aio_mutex)
+		ext4_unwritten_wait(inode);
 	mutex_unlock(&inode->i_mutex);
 
 	if (ret > 0) {

