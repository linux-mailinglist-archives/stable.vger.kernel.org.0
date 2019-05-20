Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7480923623
	for <lists+stable@lfdr.de>; Mon, 20 May 2019 14:46:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389385AbfETM2z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 May 2019 08:28:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:44840 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389402AbfETM2y (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 May 2019 08:28:54 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BC86E2171F;
        Mon, 20 May 2019 12:28:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558355333;
        bh=z748kANnPFMpxH387IIMfvA6qz7jBjyQ/TAQcPrR9xE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k6cJFJmOg69hWqwWSX/1s5enebSAm65/XT8V5h5hQypd1Mp1xnfWIjDWibVs+PpS8
         2oScnzySq1YQ4CqoD9CdaBSE1s4TjnRvLxZzV07g5Pw2K8C0mpvUzjJ48SIfteKOZZ
         35c6//ziOwnilHMtz0m/D1opUt4G3lj/EQGH/Odc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nicolas Pitre <nicolas.pitre@linaro.org>,
        Yifeng Li <tomli@tomli.me>
Subject: [PATCH 5.0 079/123] tty: vt.c: Fix TIOCL_BLANKSCREEN console blanking if blankinterval == 0
Date:   Mon, 20 May 2019 14:14:19 +0200
Message-Id: <20190520115250.098679254@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190520115245.439864225@linuxfoundation.org>
References: <20190520115245.439864225@linuxfoundation.org>
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
@@ -4152,8 +4152,6 @@ void do_blank_screen(int entering_gfx)
 		return;
 	}
 
-	if (blank_state != blank_normal_wait)
-		return;
 	blank_state = blank_off;
 
 	/* don't blank graphics */


