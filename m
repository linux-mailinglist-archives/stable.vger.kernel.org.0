Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9184837CCAE
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 19:06:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235202AbhELQqR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:46:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:34162 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241841AbhELQju (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:39:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BD69661E37;
        Wed, 12 May 2021 16:03:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620835420;
        bh=k+qBMd34yBZOoIMBBWJDR/+weETcK7DMKs8guJ02oy4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=l1nQEC/toBtNiqc3LLyqjkV/J0mrNEWJNFpZCGy8/cR7FL3B/7QLtAnqDSKPaNSow
         9/vD2aZaiObSOM0eHhpPOYHvCwW6h0Gh9oSFFxMOqG8IZrgsMX439e5csLgx9KP1Lp
         ChK8I32eD2Hffo2TzoY6Qex4FcnuRM9bZ9d7EA8A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johan Hovold <johan@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 303/677] tty: fix return value for unsupported termiox ioctls
Date:   Wed, 12 May 2021 16:45:49 +0200
Message-Id: <20210512144847.274218766@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144837.204217980@linuxfoundation.org>
References: <20210512144837.204217980@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johan Hovold <johan@kernel.org>

[ Upstream commit 8871de06ff78e9333d86c87d7071452b690e7c9b ]

Drivers should return -ENOTTY ("Inappropriate I/O control operation")
when an ioctl isn't supported, while -EINVAL is used for invalid
arguments.

Support for termiox was added by commit 1d65b4a088de ("tty: Add
termiox") in 2008 but no driver support ever followed and it was
recently ripped out by commit e0efb3168d34 ("tty: Remove dead termiox
code").

Fix the return value for the unsupported termiox ioctls, which have
always returned -EINVAL, by explicitly returning -ENOTTY rather than
removing them completely and falling back to the default unrecognised-
ioctl handling.

Fixes: 1d65b4a088de ("tty: Add termiox")
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://lore.kernel.org/r/20210407095208.31838-4-johan@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/tty_ioctl.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/tty/tty_ioctl.c b/drivers/tty/tty_ioctl.c
index 4de1c6ddb8ff..803da2d111c8 100644
--- a/drivers/tty/tty_ioctl.c
+++ b/drivers/tty/tty_ioctl.c
@@ -774,8 +774,8 @@ int tty_mode_ioctl(struct tty_struct *tty, struct file *file,
 	case TCSETX:
 	case TCSETXW:
 	case TCSETXF:
-		return -EINVAL;
-#endif		
+		return -ENOTTY;
+#endif
 	case TIOCGSOFTCAR:
 		copy_termios(real_tty, &kterm);
 		ret = put_user((kterm.c_cflag & CLOCAL) ? 1 : 0,
-- 
2.30.2



