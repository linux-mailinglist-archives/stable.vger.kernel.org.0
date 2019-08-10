Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 63BD088DD5
	for <lists+stable@lfdr.de>; Sat, 10 Aug 2019 22:49:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726858AbfHJUt2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Aug 2019 16:49:28 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:54624 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726754AbfHJUn6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 10 Aug 2019 16:43:58 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1hwYDT-00053r-9y; Sat, 10 Aug 2019 21:43:55 +0100
Received: from ben by deadeye with local (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1hwYDO-0003k4-Nv; Sat, 10 Aug 2019 21:43:50 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        "Willy Tarreau" <w@1wt.eu>, "Denis Efremov" <efremov@ispras.ru>
Date:   Sat, 10 Aug 2019 21:40:07 +0100
Message-ID: <lsq.1565469607.528093703@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 141/157] floppy: fix out-of-bounds read in copy_buffer
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

From: Denis Efremov <efremov@ispras.ru>

commit da99466ac243f15fbba65bd261bfc75ffa1532b6 upstream.

This fixes a global out-of-bounds read access in the copy_buffer
function of the floppy driver.

The FDDEFPRM ioctl allows one to set the geometry of a disk.  The sect
and head fields (unsigned int) of the floppy_drive structure are used to
compute the max_sector (int) in the make_raw_rw_request function.  It is
possible to overflow the max_sector.  Next, max_sector is passed to the
copy_buffer function and used in one of the memcpy calls.

An unprivileged user could trigger the bug if the device is accessible,
but requires a floppy disk to be inserted.

The patch adds the check for the .sect * .head multiplication for not
overflowing in the set_geometry function.

The bug was found by syzkaller.

Signed-off-by: Denis Efremov <efremov@ispras.ru>
Tested-by: Willy Tarreau <w@1wt.eu>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/block/floppy.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/block/floppy.c
+++ b/drivers/block/floppy.c
@@ -3236,8 +3236,10 @@ static int set_geometry(unsigned int cmd
 	int cnt;
 
 	/* sanity checking for parameters. */
-	if (g->sect <= 0 ||
-	    g->head <= 0 ||
+	if ((int)g->sect <= 0 ||
+	    (int)g->head <= 0 ||
+	    /* check for overflow in max_sector */
+	    (int)(g->sect * g->head) <= 0 ||
 	    /* check for zero in F_SECT_PER_TRACK */
 	    (unsigned char)((g->sect << 2) >> FD_SIZECODE(g)) == 0 ||
 	    g->track <= 0 || g->track > UDP->tracks >> STRETCH(g) ||

