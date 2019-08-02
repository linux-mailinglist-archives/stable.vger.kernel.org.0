Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BF2AE7F2BF
	for <lists+stable@lfdr.de>; Fri,  2 Aug 2019 11:51:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405289AbfHBJor (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Aug 2019 05:44:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:48220 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405284AbfHBJoq (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 2 Aug 2019 05:44:46 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 19B882087E;
        Fri,  2 Aug 2019 09:44:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564739085;
        bh=PPvA7ml7LFFB5y0n9lNb3gNkDyaZeZkeeFX6exxKxJ8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=v/n8VTMjavPiKCFGxhCkSYxZIE6Hnka+FWhiDQ85C/YoOb/FwYGNfGJk0PZwdtT0L
         F9cROyC4VR+QHKP8L+TKkcPZIDzXG1A/0UeiLD5k3WKuPRvTnKXI1WLM3P0LLIT2Gq
         faygjnRNFzf6rTQfrGw70pEDdBnJfzyG4vw3uxBw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Denis Efremov <efremov@ispras.ru>,
        Willy Tarreau <w@1wt.eu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 107/223] floppy: fix out-of-bounds read in copy_buffer
Date:   Fri,  2 Aug 2019 11:35:32 +0200
Message-Id: <20190802092246.181182014@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190802092238.692035242@linuxfoundation.org>
References: <20190802092238.692035242@linuxfoundation.org>
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/block/floppy.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/block/floppy.c
+++ b/drivers/block/floppy.c
@@ -3237,8 +3237,10 @@ static int set_geometry(unsigned int cmd
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


