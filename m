Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B06803FDB76
	for <lists+stable@lfdr.de>; Wed,  1 Sep 2021 15:17:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343678AbhIAMlr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Sep 2021 08:41:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:42460 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344826AbhIAMkI (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Sep 2021 08:40:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0097E60F21;
        Wed,  1 Sep 2021 12:36:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1630499761;
        bh=s3gyVITa2PR9fxfQHuANQGwIuSOn3PTmdB3yN6wvSzE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aDcBsvTm5xuW6Tl6UbkCuFVp0MBPf9FyW+I2mFO67iIkfan9SzWCOiVParyoHUPvZ
         OdyJPBjjc7Bm1xVB5hK8Dgg/zoe+VOXDWUJ/j/9Gmt0hAHF3oBhwNksUcTWKbq5ZXN
         uweVuMZnpWn80E7KebYu/n7M++JqlWwNP3GTPBgc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Minh Yuan <yuanmingbuaa@gmail.com>,
        Jiri Slaby <jirislaby@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.10 076/103] vt_kdsetmode: extend console locking
Date:   Wed,  1 Sep 2021 14:28:26 +0200
Message-Id: <20210901122303.118427446@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210901122300.503008474@linuxfoundation.org>
References: <20210901122300.503008474@linuxfoundation.org>
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
 drivers/tty/vt/vt_ioctl.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

--- a/drivers/tty/vt/vt_ioctl.c
+++ b/drivers/tty/vt/vt_ioctl.c
@@ -246,6 +246,8 @@ int vt_waitactive(int n)
  *
  * XXX It should at least call into the driver, fbdev's definitely need to
  * restore their engine state. --BenH
+ *
+ * Called with the console lock held.
  */
 static int vt_kdsetmode(struct vc_data *vc, unsigned long mode)
 {
@@ -262,7 +264,6 @@ static int vt_kdsetmode(struct vc_data *
 		return -EINVAL;
 	}
 
-	/* FIXME: this needs the console lock extending */
 	if (vc->vc_mode == mode)
 		return 0;
 
@@ -271,12 +272,10 @@ static int vt_kdsetmode(struct vc_data *
 		return 0;
 
 	/* explicitly blank/unblank the screen if switching modes */
-	console_lock();
 	if (mode == KD_TEXT)
 		do_unblank_screen(1);
 	else
 		do_blank_screen(1);
-	console_unlock();
 
 	return 0;
 }
@@ -378,7 +377,10 @@ static int vt_k_ioctl(struct tty_struct
 		if (!perm)
 			return -EPERM;
 
-		return vt_kdsetmode(vc, arg);
+		console_lock();
+		ret = vt_kdsetmode(vc, arg);
+		console_unlock();
+		return ret;
 
 	case KDGETMODE:
 		return put_user(vc->vc_mode, (int __user *)arg);


