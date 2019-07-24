Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 397EE73AD3
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 21:54:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404016AbfGXTyM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 15:54:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:36866 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404288AbfGXTyH (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Jul 2019 15:54:07 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D1CC8214AF;
        Wed, 24 Jul 2019 19:54:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563998046;
        bh=SbdTHK3meOVFUmsflZsRBWejHKQ0ASuVLXkuo+G9eV4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JCuxMu3M9Z4KlpLOYm+Yrp77xlMSYSC5y6NG39t35knLuxkAO/OM3VTqsdZy1p1Wi
         CD0Tb2mTgAwxkb0985+OqHt1ohM28TsPSZvUdx9zjB/+BxZPd/AQ1Mr7zhLoaT/goz
         gZHBKro9vZ3SWWIABi4mGuRFljvb01jAsh2Rjiqg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Denis Efremov <efremov@ispras.ru>,
        Willy Tarreau <w@1wt.eu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 227/371] floppy: fix out-of-bounds read in copy_buffer
Date:   Wed, 24 Jul 2019 21:19:39 +0200
Message-Id: <20190724191741.556323032@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190724191724.382593077@linuxfoundation.org>
References: <20190724191724.382593077@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit da99466ac243f15fbba65bd261bfc75ffa1532b6 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/floppy.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/block/floppy.c b/drivers/block/floppy.c
index 8b443ee1d005..38e5811a045e 100644
--- a/drivers/block/floppy.c
+++ b/drivers/block/floppy.c
@@ -3232,8 +3232,10 @@ static int set_geometry(unsigned int cmd, struct floppy_struct *g,
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
-- 
2.20.1



