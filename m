Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5263C37FA4A
	for <lists+stable@lfdr.de>; Thu, 13 May 2021 17:09:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231154AbhEMPKZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 May 2021 11:10:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:36952 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232156AbhEMPKU (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 13 May 2021 11:10:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 65800613BF;
        Thu, 13 May 2021 15:09:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620918549;
        bh=Ll3fUqSlYibjUbkgcdR7yHlPmrzOlSzquY+RTnM5Pa0=;
        h=Subject:To:From:Date:From;
        b=fx94642tdp/FaUlGcDpAVgL1P6jb59CDXLAyZmw4WUEbX8t6LKYY+Qkl9Y7N/VPyk
         Db9edenYdv12FFiVNdSdtzuBxS8yRpVaUXOJH0v7JTZbTgTXI4sIS+10jZpcei268N
         WMVo70tCVwU37ChH9C5yvjO4mp6PiiS1jN9sc4QY=
Subject: patch "serial: core: fix suspicious security_locked_down() call" added to tty-linus
To:     omosnace@redhat.com, gregkh@linuxfoundation.org,
        keescook@chromium.org, stable@vger.kernel.org
From:   <gregkh@linuxfoundation.org>
Date:   Thu, 13 May 2021 17:08:59 +0200
Message-ID: <162091853915678@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    serial: core: fix suspicious security_locked_down() call

to my tty git tree which can be found at
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/tty.git
in the tty-linus branch.

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

The patch will hopefully also be merged in Linus's tree for the
next -rc kernel release.

If you have any questions about this process, please let me know.


From 5e722b217ad3cf41f5504db80a68062df82b5242 Mon Sep 17 00:00:00 2001
From: Ondrej Mosnacek <omosnace@redhat.com>
Date: Fri, 7 May 2021 13:57:19 +0200
Subject: serial: core: fix suspicious security_locked_down() call

The commit that added this check did so in a very strange way - first
security_locked_down() is called, its value stored into retval, and if
it's nonzero, then an additional check is made for (change_irq ||
change_port), and if this is true, the function returns. However, if
the goto exit branch is not taken, the code keeps the retval value and
continues executing the function. Then, depending on whether
uport->ops->verify_port is set, the retval value may or may not be reset
to zero and eventually the error value from security_locked_down() may
abort the function a few lines below.

I will go out on a limb and assume that this isn't the intended behavior
and that an error value from security_locked_down() was supposed to
abort the function only in case (change_irq || change_port) is true.

Note that security_locked_down() should be called last in any series of
checks, since the SELinux implementation of this hook will do a check
against the policy and generate an audit record in case of denial. If
the operation was to carry on after calling security_locked_down(), then
the SELinux denial record would be bogus.

See commit 59438b46471a ("security,lockdown,selinux: implement SELinux
lockdown") for how SELinux implements this hook.

Fixes: 794edf30ee6c ("lockdown: Lock down TIOCSSERIAL")
Acked-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Ondrej Mosnacek <omosnace@redhat.com>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20210507115719.140799-1-omosnace@redhat.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/serial_core.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/tty/serial/serial_core.c b/drivers/tty/serial/serial_core.c
index 87f7127b57e6..18ff85a83f80 100644
--- a/drivers/tty/serial/serial_core.c
+++ b/drivers/tty/serial/serial_core.c
@@ -863,9 +863,11 @@ static int uart_set_info(struct tty_struct *tty, struct tty_port *port,
 		goto check_and_exit;
 	}
 
-	retval = security_locked_down(LOCKDOWN_TIOCSSERIAL);
-	if (retval && (change_irq || change_port))
-		goto exit;
+	if (change_irq || change_port) {
+		retval = security_locked_down(LOCKDOWN_TIOCSSERIAL);
+		if (retval)
+			goto exit;
+	}
 
 	/*
 	 * Ask the low level driver to verify the settings.
-- 
2.31.1


