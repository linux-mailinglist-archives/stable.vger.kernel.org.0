Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FA8437C4A0
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 17:32:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234233AbhELPcT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 11:32:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:39078 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235528AbhELP20 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 11:28:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6B9C461C22;
        Wed, 12 May 2021 15:13:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620832417;
        bh=iWNDfoUDEKCdn6VdGg6dGYxQtn8n50whwoK3Cj+ioVQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Zq31a5gfz7ylWp49oJIPjBnKypPIpdsGgVzMV9v6yw4VGIIGXwPCMtyH8CVRJhwlE
         N6u3WLdxZvLvK3JVpKQbvXWX9SEXGC0UJHQWuKHDZGIEboUEHfeOIK6PPoAm9XVkD+
         O/XFklKhKPZ9RW8picxsvDtddNaCREv6aC2cP1yc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot <syzbot+43e93968b964e369db0b@syzkaller.appspotmail.com>,
        syzbot <syzbot+3ed715090790806d8b18@syzkaller.appspotmail.com>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 272/530] ttyprintk: Add TTY hangup callback.
Date:   Wed, 12 May 2021 16:46:22 +0200
Message-Id: <20210512144828.749215929@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144819.664462530@linuxfoundation.org>
References: <20210512144819.664462530@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>

[ Upstream commit c0070e1e60270f6a1e09442a9ab2335f3eaeaad2 ]

syzbot is reporting hung task due to flood of

  tty_warn(tty, "%s: tty->count = 1 port count = %d\n", __func__,
           port->count);

message [1], for ioctl(TIOCVHANGUP) prevents tty_port_close() from
decrementing port->count due to tty_hung_up_p() == true.

----------
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <sys/ioctl.h>
#include <unistd.h>

int main(int argc, char *argv[])
{
	int i;
	int fd[10];

	for (i = 0; i < 10; i++)
		fd[i] = open("/dev/ttyprintk", O_WRONLY);
	ioctl(fd[0], TIOCVHANGUP);
	for (i = 0; i < 10; i++)
		close(fd[i]);
	close(open("/dev/ttyprintk", O_WRONLY));
	return 0;
}
----------

When TTY hangup happens, port->count needs to be reset via
"struct tty_operations"->hangup callback.

[1] https://syzkaller.appspot.com/bug?id=39ea6caa479af471183997376dc7e90bc7d64a6a

Reported-by: syzbot <syzbot+43e93968b964e369db0b@syzkaller.appspotmail.com>
Reported-by: syzbot <syzbot+3ed715090790806d8b18@syzkaller.appspotmail.com>
Tested-by: syzbot <syzbot+43e93968b964e369db0b@syzkaller.appspotmail.com>
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Fixes: 24b4b67d17c308aa ("add ttyprintk driver")
Link: https://lore.kernel.org/r/17e0652d-89b7-c8c0-fb53-e7566ac9add4@i-love.sakura.ne.jp
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/char/ttyprintk.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/char/ttyprintk.c b/drivers/char/ttyprintk.c
index 6a0059e508e3..93f5d11c830b 100644
--- a/drivers/char/ttyprintk.c
+++ b/drivers/char/ttyprintk.c
@@ -158,12 +158,23 @@ static int tpk_ioctl(struct tty_struct *tty,
 	return 0;
 }
 
+/*
+ * TTY operations hangup function.
+ */
+static void tpk_hangup(struct tty_struct *tty)
+{
+	struct ttyprintk_port *tpkp = tty->driver_data;
+
+	tty_port_hangup(&tpkp->port);
+}
+
 static const struct tty_operations ttyprintk_ops = {
 	.open = tpk_open,
 	.close = tpk_close,
 	.write = tpk_write,
 	.write_room = tpk_write_room,
 	.ioctl = tpk_ioctl,
+	.hangup = tpk_hangup,
 };
 
 static const struct tty_port_operations null_ops = { };
-- 
2.30.2



