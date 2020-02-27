Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F1E5417214D
	for <lists+stable@lfdr.de>; Thu, 27 Feb 2020 15:49:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729162AbgB0Nnm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Feb 2020 08:43:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:38980 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729696AbgB0Nnm (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 27 Feb 2020 08:43:42 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1833E20578;
        Thu, 27 Feb 2020 13:43:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582811021;
        bh=S0yGJG0Id9N1yY6MyKdC5gdWa6cxWpV1/yYUVgykXEg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UuSUrETkLBtiVLzDl32tIPBVmz0sYW2yQYs8nuDhofMR87TqZ9oROsenh7RsyztIh
         l1Vb1iLAzw39bASdH3dpLolAwvL+66A62uCtbSUADNpJpEcJifihDC1F3KKaMK+4Vj
         xQ61xlKHOVzmFqZSAFYjEJTmcaF+MLsLpBQSGoVE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jordy Zomer <jordy@simplyhacker.com>,
        Willy Tarreau <w@1wt.eu>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 4.4 085/113] floppy: check FDC index for errors before assigning it
Date:   Thu, 27 Feb 2020 14:36:41 +0100
Message-Id: <20200227132225.362545078@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200227132211.791484803@linuxfoundation.org>
References: <20200227132211.791484803@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/block/floppy.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/drivers/block/floppy.c
+++ b/drivers/block/floppy.c
@@ -848,14 +848,17 @@ static void reset_fdc_info(int mode)
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


