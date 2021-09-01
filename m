Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAEDE3FD999
	for <lists+stable@lfdr.de>; Wed,  1 Sep 2021 14:27:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244152AbhIAM1v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Sep 2021 08:27:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:56948 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244103AbhIAM1t (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Sep 2021 08:27:49 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 966D161027;
        Wed,  1 Sep 2021 12:26:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1630499213;
        bh=hIdL6z+qzpijU8652Uh5NeZjddCeQI/66a2SPmdw19w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CmGyCauRMnbf3NTx/8qSw9zQFE10cBSq8GWQ5YYCKwudM1NxbX0XFUpsygS8SpDbi
         9jjYDebMOBc20fDWf7VV6IHp3WO9rBpE0sqpLejHvhSP0UDqfXwkrja6m8DmCPNpjQ
         UlHhOw8PUznAkeyElDiapP8yfuxf9jXuDHN5cXyE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Minh Yuan <yuanmingbuaa@gmail.com>,
        Jiri Slaby <jirislaby@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 4.4 08/10] vt_kdsetmode: extend console locking
Date:   Wed,  1 Sep 2021 14:26:22 +0200
Message-Id: <20210901122248.313243925@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210901122248.051808371@linuxfoundation.org>
References: <20210901122248.051808371@linuxfoundation.org>
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


