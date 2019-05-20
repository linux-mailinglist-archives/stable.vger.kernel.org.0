Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 87B2923745
	for <lists+stable@lfdr.de>; Mon, 20 May 2019 15:18:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387919AbfETMXc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 May 2019 08:23:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:37998 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388036AbfETMXc (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 May 2019 08:23:32 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2DDB920645;
        Mon, 20 May 2019 12:23:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558355011;
        bh=Mitkq/mNc3PsR+GS8+sgxQ9ccjBADF3myYWbMFia4IM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=V3HOHvc6Tv3bDbT8ycKagZ3wZU4cQN5xZ2cH+d4PP7KCQx2YESxK5PCh8MNKzN3eG
         DsyH8nm3fjjhXcykQUBJ0wBRTSo6+1C9j5lH5IOBYNDa2PORH7XKP7cCt333lfYPqC
         sfQxzzvsQltocJ1LUYXfulfEeM35INvteTOu/vuU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nicolas Pitre <nicolas.pitre@linaro.org>,
        Yifeng Li <tomli@tomli.me>
Subject: [PATCH 4.19 063/105] tty: vt.c: Fix TIOCL_BLANKSCREEN console blanking if blankinterval == 0
Date:   Mon, 20 May 2019 14:14:09 +0200
Message-Id: <20190520115251.512795386@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190520115247.060821231@linuxfoundation.org>
References: <20190520115247.060821231@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yifeng Li <tomli@tomli.me>

commit 75ddbc1fb11efac87b611d48e9802f6fe2bb2163 upstream.

Previously, in the userspace, it was possible to use the "setterm" command
from util-linux to blank the VT console by default, using the following
command.

According to the man page,

> The force option keeps the screen blank even if a key is pressed.

It was implemented by calling TIOCL_BLANKSCREEN.

	case BLANKSCREEN:
		ioctlarg = TIOCL_BLANKSCREEN;
		if (ioctl(STDIN_FILENO, TIOCLINUX, &ioctlarg))
			warn(_("cannot force blank"));
		break;

However, after Linux 4.12, this command ceased to work anymore, which is
unexpected. By inspecting the kernel source, it shows that the issue was
triggered by the side-effect from commit a4199f5eb809 ("tty: Disable
default console blanking interval").

The console blanking is implemented by function do_blank_screen() in vt.c:
"blank_state" will be initialized to "blank_normal_wait" in con_init() if
AND ONLY IF ("blankinterval" > 0). If "blankinterval" is 0, "blank_state"
will be "blank_off" (== 0), and a call to do_blank_screen() will always
abort, even if a forced blanking is required from the user by calling
TIOCL_BLANKSCREEN, the console won't be blanked.

This behavior is unexpected from a user's point-of-view, since it's not
mentioned in any documentation. The setterm man page suggests it will
always work, and the kernel comments in uapi/linux/tiocl.h says

> /* keep screen blank even if a key is pressed */
> #define TIOCL_BLANKSCREEN 14

To fix it, we simply remove the "blank_state != blank_off" check, as
pointed out by Nicolas Pitre, this check doesn't logically make sense
and it's safe to remove.

Suggested-by: Nicolas Pitre <nicolas.pitre@linaro.org>
Fixes: a4199f5eb809 ("tty: Disable default console blanking interval")
Signed-off-by: Yifeng Li <tomli@tomli.me>
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/tty/vt/vt.c |    2 --
 1 file changed, 2 deletions(-)

--- a/drivers/tty/vt/vt.c
+++ b/drivers/tty/vt/vt.c
@@ -4155,8 +4155,6 @@ void do_blank_screen(int entering_gfx)
 		return;
 	}
 
-	if (blank_state != blank_normal_wait)
-		return;
 	blank_state = blank_off;
 
 	/* don't blank graphics */


