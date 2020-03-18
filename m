Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 29F70189BCC
	for <lists+stable@lfdr.de>; Wed, 18 Mar 2020 13:16:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726631AbgCRMQp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Mar 2020 08:16:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:46060 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726616AbgCRMQp (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 18 Mar 2020 08:16:45 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0672A20753;
        Wed, 18 Mar 2020 12:16:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584533804;
        bh=hPfAHrlxMMVEEXPRHMb+t2sQZm/QjBPxAzRhvM+U2q8=;
        h=Subject:To:From:Date:From;
        b=vNQhMlQ9nty9G+Y3KIswOMFmOoHIxCOjET1246OHyvPgiXdS6rkiQUoxaKZfut8gd
         uCeCtyj3LgA7gss6hiseSjhTXA0RalcvTIfBmjaC0sXVM5sqsIil5cB18D5LeuWn0C
         VFkqaJxXYkWgaiiMHnPMrxoOxGe3Z5kFEDFdhwZE=
Subject: patch "tty: fix compat TIOCGSERIAL checking wrong function ptr" added to tty-linus
To:     ebiggers@google.com, gregkh@linuxfoundation.org, jslaby@suse.cz,
        stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 18 Mar 2020 13:16:32 +0100
Message-ID: <1584533792135156@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    tty: fix compat TIOCGSERIAL checking wrong function ptr

to my tty git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/tty.git
in the tty-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 6e622cd8bd888c7fa3ee2b7dfb3514ab53b21570 Mon Sep 17 00:00:00 2001
From: Eric Biggers <ebiggers@google.com>
Date: Mon, 24 Feb 2020 10:20:44 -0800
Subject: tty: fix compat TIOCGSERIAL checking wrong function ptr

Commit 77654350306a ("take compat TIOC[SG]SERIAL treatment into
tty_compat_ioctl()") changed the compat version of TIOCGSERIAL to start
checking for the presence of the ->set_serial function pointer rather
than ->get_serial.  This appears to be a copy-and-paste error, since
->get_serial is the function pointer that is called as well as the
pointer that is checked by the non-compat version of TIOCGSERIAL.

Fix this by checking the correct function pointer.

Fixes: 77654350306a ("take compat TIOC[SG]SERIAL treatment into tty_compat_ioctl()")
Cc: <stable@vger.kernel.org> # v4.20+
Signed-off-by: Eric Biggers <ebiggers@google.com>
Acked-by: Jiri Slaby <jslaby@suse.cz>
Link: https://lore.kernel.org/r/20200224182044.234553-3-ebiggers@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/tty_io.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/tty/tty_io.c b/drivers/tty/tty_io.c
index db4a13bc855e..5a6f36b391d9 100644
--- a/drivers/tty/tty_io.c
+++ b/drivers/tty/tty_io.c
@@ -2734,7 +2734,7 @@ static int compat_tty_tiocgserial(struct tty_struct *tty,
 	memset(&v, 0, sizeof(v));
 	memset(&v32, 0, sizeof(v32));
 
-	if (!tty->ops->set_serial)
+	if (!tty->ops->get_serial)
 		return -ENOTTY;
 	err = tty->ops->get_serial(tty, &v);
 	if (!err) {
-- 
2.25.1


