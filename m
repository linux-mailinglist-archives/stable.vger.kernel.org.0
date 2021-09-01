Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 704BC3FD9A9
	for <lists+stable@lfdr.de>; Wed,  1 Sep 2021 14:28:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244285AbhIAM2V (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Sep 2021 08:28:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:57560 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244046AbhIAM2M (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Sep 2021 08:28:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B343160F92;
        Wed,  1 Sep 2021 12:27:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1630499235;
        bh=hIdL6z+qzpijU8652Uh5NeZjddCeQI/66a2SPmdw19w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iIYQYL4TCOOauP14Ee6MnVSeAaIYbI6Esr2sRLYvUigJMhWSDf02PH7yJxrDEblEr
         2zAdMIGqC/GNQpibSccBWqXumhx5lUM1ZEhqzE0Ms3psPh/Jl3rUdVs60uxXYQt45u
         pxQduMAT4OX9zpylFFwhdNXBKsJBb9+VmxJ0jK9s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Minh Yuan <yuanmingbuaa@gmail.com>,
        Jiri Slaby <jirislaby@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 4.9 13/16] vt_kdsetmode: extend console locking
Date:   Wed,  1 Sep 2021 14:26:39 +0200
Message-Id: <20210901122249.333189168@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210901122248.920548099@linuxfoundation.org>
References: <20210901122248.920548099@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>

commit 2287a51ba822384834dafc1c798453375d1107c7 upstream.

As per the long-suffering comment.

Reported-by: Minh Yuan <yuanmingbuaa@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jirislaby@kernel.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/vt/vt_ioctl.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

--- a/drivers/tty/vt/vt_ioctl.c
+++ b/drivers/tty/vt/vt_ioctl.c
@@ -487,16 +487,19 @@ int vt_ioctl(struct tty_struct *tty,
 			ret = -EINVAL;
 			goto out;
 		}
-		/* FIXME: this needs the console lock extending */
-		if (vc->vc_mode == (unsigned char) arg)
+		console_lock();
+		if (vc->vc_mode == (unsigned char) arg) {
+			console_unlock();
 			break;
+		}
 		vc->vc_mode = (unsigned char) arg;
-		if (console != fg_console)
+		if (console != fg_console) {
+			console_unlock();
 			break;
+		}
 		/*
 		 * explicitly blank/unblank the screen if switching modes
 		 */
-		console_lock();
 		if (arg == KD_TEXT)
 			do_unblank_screen(1);
 		else


