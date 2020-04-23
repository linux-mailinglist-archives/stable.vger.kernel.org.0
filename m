Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23F561B67C0
	for <lists+stable@lfdr.de>; Fri, 24 Apr 2020 01:09:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728451AbgDWXJX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Apr 2020 19:09:23 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:50852 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728646AbgDWXG6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Apr 2020 19:06:58 -0400
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1jRkvk-0004xG-6j; Fri, 24 Apr 2020 00:06:52 +0100
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1jRkvf-00E72K-Eh; Fri, 24 Apr 2020 00:06:47 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Dan Carpenter" <dan.carpenter@oracle.com>,
        "Willy Tarreau" <w@1wt.eu>,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        "Jordy Zomer" <jordy@simplyhacker.com>
Date:   Fri, 24 Apr 2020 00:07:31 +0100
Message-ID: <lsq.1587683028.161841510@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 224/245] floppy: check FDC index for errors before
 assigning it
In-Reply-To: <lsq.1587683027.831233700@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.83-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Linus Torvalds <torvalds@linux-foundation.org>

commit 2e90ca68b0d2f5548804f22f0dd61145516171e3 upstream.

Jordy Zomer reported a KASAN out-of-bounds read in the floppy driver in
wait_til_ready().

Which on the face of it can't happen, since as Willy Tarreau points out,
the function does no particular memory access.  Except through the FDCS
macro, which just indexes a static allocation through teh current fdc,
which is always checked against N_FDC.

Except the checking happens after we've already assigned the value.

The floppy driver is a disgrace (a lot of it going back to my original
horrd "design"), and has no real maintainer.  Nobody has the hardware,
and nobody really cares.  But it still gets used in virtual environment
because it's one of those things that everybody supports.

The whole thing should be re-written, or at least parts of it should be
seriously cleaned up.  The 'current fdc' index, which is used by the
FDCS macro, and which is often shadowed by a local 'fdc' variable, is a
prime example of how not to write code.

But because nobody has the hardware or the motivation, let's just fix up
the immediate problem with a nasty band-aid: test the fdc index before
actually assigning it to the static 'fdc' variable.

Reported-by: Jordy Zomer <jordy@simplyhacker.com>
Cc: Willy Tarreau <w@1wt.eu>
Cc: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/block/floppy.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/drivers/block/floppy.c
+++ b/drivers/block/floppy.c
@@ -847,14 +847,17 @@ static void reset_fdc_info(int mode)
 /* selects the fdc and drive, and enables the fdc's input/dma. */
 static void set_fdc(int drive)
 {
+	unsigned int new_fdc = fdc;
+
 	if (drive >= 0 && drive < N_DRIVE) {
-		fdc = FDC(drive);
+		new_fdc = FDC(drive);
 		current_drive = drive;
 	}
-	if (fdc != 1 && fdc != 0) {
+	if (new_fdc >= N_FDC) {
 		pr_info("bad fdc value\n");
 		return;
 	}
+	fdc = new_fdc;
 	set_dor(fdc, ~0, 8);
 #if N_FDC > 1
 	set_dor(1 - fdc, ~8, 0);

