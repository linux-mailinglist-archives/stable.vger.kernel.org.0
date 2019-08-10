Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 08F6F88E64
	for <lists+stable@lfdr.de>; Sat, 10 Aug 2019 22:54:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727311AbfHJUyg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Aug 2019 16:54:36 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:53754 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726383AbfHJUns (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 10 Aug 2019 16:43:48 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1hwYDI-00052w-OS; Sat, 10 Aug 2019 21:43:44 +0100
Received: from ben by deadeye with local (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1hwYDI-0003Y3-IE; Sat, 10 Aug 2019 21:43:44 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Frank Sorenson" <fsorenso@redhat.com>,
        "Theodore Ts'o" <tytso@mit.edu>,
        "Lukas Czerner" <lczerner@redhat.com>
Date:   Sat, 10 Aug 2019 21:40:07 +0100
Message-ID: <lsq.1565469607.221652928@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 008/157] ext4: fix data corruption caused by
 unaligned direct AIO
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

From: Lukas Czerner <lczerner@redhat.com>

commit 372a03e01853f860560eade508794dd274e9b390 upstream.

Ext4 needs to serialize unaligned direct AIO because the zeroing of
partial blocks of two competing unaligned AIOs can result in data
corruption.

However it decides not to serialize if the potentially unaligned aio is
past i_size with the rationale that no pending writes are possible past
i_size. Unfortunately if the i_size is not block aligned and the second
unaligned write lands past i_size, but still into the same block, it has
the potential of corrupting the previous unaligned write to the same
block.

This is (very simplified) reproducer from Frank

    // 41472 = (10 * 4096) + 512
    // 37376 = 41472 - 4096

    ftruncate(fd, 41472);
    io_prep_pwrite(iocbs[0], fd, buf[0], 4096, 37376);
    io_prep_pwrite(iocbs[1], fd, buf[1], 4096, 41472);

    io_submit(io_ctx, 1, &iocbs[1]);
    io_submit(io_ctx, 1, &iocbs[2]);

    io_getevents(io_ctx, 2, 2, events, NULL);

Without this patch the 512B range from 40960 up to the start of the
second unaligned write (41472) is going to be zeroed overwriting the data
written by the first write. This is a data corruption.

00000000  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00
*
00009200  30 30 30 30 30 30 30 30  30 30 30 30 30 30 30 30
*
0000a000  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00
*
0000a200  31 31 31 31 31 31 31 31  31 31 31 31 31 31 31 31

With this patch the data corruption is avoided because we will recognize
the unaligned_aio and wait for the unwritten extent conversion.

00000000  00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00
*
00009200  30 30 30 30 30 30 30 30  30 30 30 30 30 30 30 30
*
0000a200  31 31 31 31 31 31 31 31  31 31 31 31 31 31 31 31
*
0000b200

Reported-by: Frank Sorenson <fsorenso@redhat.com>
Signed-off-by: Lukas Czerner <lczerner@redhat.com>
Signed-off-by: Theodore Ts'o <tytso@mit.edu>
Fixes: e9e3bcecf44c ("ext4: serialize unaligned asynchronous DIO")
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 fs/ext4/file.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/ext4/file.c
+++ b/fs/ext4/file.c
@@ -79,7 +79,7 @@ ext4_unaligned_aio(struct inode *inode,
 	struct super_block *sb = inode->i_sb;
 	int blockmask = sb->s_blocksize - 1;
 
-	if (pos >= i_size_read(inode))
+	if (pos >= ALIGN(i_size_read(inode), sb->s_blocksize))
 		return 0;
 
 	if ((pos | iov_iter_alignment(from)) & blockmask)

