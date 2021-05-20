Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51B4E38A426
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 12:00:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234916AbhETKB0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 06:01:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:32852 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235106AbhETJ7Z (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 05:59:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8A7D9616E8;
        Thu, 20 May 2021 09:38:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621503520;
        bh=XmTnRO0tUxq1mQAVmgbpfEFX1Y1/wMsQYo/kVpIRatg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=atPnf5+WAt0xeg7/pVjkMIxLxdL//QjII5jnX/65+HXwBzFy871lcjYepymrm521I
         GONdGQloKt5p7n30kEL8HitqxOmCxJ6SjmDHIjOb31VGf2woQqbnoqthsSUyi4NjSp
         jL7r9eL2hta9R6F+QWgEoV+K3YEAN5WB/Kp4b8rc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot <syzbot+43e93968b964e369db0b@syzkaller.appspotmail.com>,
        syzbot <syzbot+3ed715090790806d8b18@syzkaller.appspotmail.com>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 224/425] ttyprintk: Add TTY hangup callback.
Date:   Thu, 20 May 2021 11:19:53 +0200
Message-Id: <20210520092138.783405415@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092131.308959589@linuxfoundation.org>
References: <20210520092131.308959589@linuxfoundation.org>
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
index 774748497ace..e56ac5adb5fc 100644
--- a/drivers/char/ttyprintk.c
+++ b/drivers/char/ttyprintk.c
@@ -159,12 +159,23 @@ static int tpk_ioctl(struct tty_struct *tty,
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



