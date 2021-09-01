Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C34243FDA10
	for <lists+stable@lfdr.de>; Wed,  1 Sep 2021 15:15:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244407AbhIAM36 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Sep 2021 08:29:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:59276 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244316AbhIAM3e (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Sep 2021 08:29:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B92C66101B;
        Wed,  1 Sep 2021 12:28:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1630499313;
        bh=FXLTM2FmsjARSgGovu0OGsj2PLrYLKUBTC4PYZF2IOM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=M8krBG6NdGFJb7ggsidT369Tgco6GJkbT+qDHOO9zTjmSxUjZso2LJDry3GUjItdu
         mBgFFKCcygkVeeaxDzTOgiVAsshx+K5DsWwtH3ji3bnKl1VAuidYs0x0WpYYbfbBu/
         V/LEVrDFOy3OUeyTUrWRtMPrH1oT9ezDFA+AKnPw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Minh Yuan <yuanmingbuaa@gmail.com>,
        Jiri Slaby <jirislaby@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 4.14 19/23] vt_kdsetmode: extend console locking
Date:   Wed,  1 Sep 2021 14:27:04 +0200
Message-Id: <20210901122250.403697177@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210901122249.786673285@linuxfoundation.org>
References: <20210901122249.786673285@linuxfoundation.org>
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
@@ -484,16 +484,19 @@ int vt_ioctl(struct tty_struct *tty,
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


