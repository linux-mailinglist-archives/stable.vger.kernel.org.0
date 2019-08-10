Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DE13B88DD4
	for <lists+stable@lfdr.de>; Sat, 10 Aug 2019 22:49:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726981AbfHJUt2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Aug 2019 16:49:28 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:54614 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726751AbfHJUn6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 10 Aug 2019 16:43:58 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1hwYDT-00053m-9o; Sat, 10 Aug 2019 21:43:55 +0100
Received: from ben by deadeye with local (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1hwYDO-0003jk-Hy; Sat, 10 Aug 2019 21:43:50 +0100
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
Message-ID: <lsq.1565469607.827914321@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 138/157] floppy: fix div-by-zero in setup_format_params
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

commit f3554aeb991214cbfafd17d55e2bfddb50282e32 upstream.

This fixes a divide by zero error in the setup_format_params function of
the floppy driver.

Two consecutive ioctls can trigger the bug: The first one should set the
drive geometry with such .sect and .rate values for the F_SECT_PER_TRACK
to become zero.  Next, the floppy format operation should be called.

A floppy disk is not required to be inserted.  An unprivileged user
could trigger the bug if the device is accessible.

The patch checks F_SECT_PER_TRACK for a non-zero value in the
set_geometry function.  The proper check should involve a reasonable
upper limit for the .sect and .rate fields, but it could change the
UAPI.

The patch also checks F_SECT_PER_TRACK in the setup_format_params, and
cancels the formatting operation in case of zero.

The bug was found by syzkaller.

Signed-off-by: Denis Efremov <efremov@ispras.ru>
Tested-by: Willy Tarreau <w@1wt.eu>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/block/floppy.c | 5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/block/floppy.c
+++ b/drivers/block/floppy.c
@@ -2113,6 +2113,9 @@ static void setup_format_params(int trac
 	raw_cmd->kernel_data = floppy_track_buffer;
 	raw_cmd->length = 4 * F_SECT_PER_TRACK;
 
+	if (!F_SECT_PER_TRACK)
+		return;
+
 	/* allow for about 30ms for data transport per track */
 	head_shift = (F_SECT_PER_TRACK + 5) / 6;
 
@@ -3235,6 +3238,8 @@ static int set_geometry(unsigned int cmd
 	/* sanity checking for parameters. */
 	if (g->sect <= 0 ||
 	    g->head <= 0 ||
+	    /* check for zero in F_SECT_PER_TRACK */
+	    (unsigned char)((g->sect << 2) >> FD_SIZECODE(g)) == 0 ||
 	    g->track <= 0 || g->track > UDP->tracks >> STRETCH(g) ||
 	    /* check if reserved bits are set */
 	    (g->stretch & ~(FD_STRETCH | FD_SWAPSIDES | FD_SECTBASEMASK)) != 0)

