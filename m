Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B4822E3B7E
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 14:51:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406404AbgL1Nus (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:50:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:51712 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406395AbgL1Nup (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:50:45 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C937920715;
        Mon, 28 Dec 2020 13:50:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609163424;
        bh=nVCVeaYmCZ31IeiiiRWPTdvvzAVNd5cTuQmGpIDznt0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wOGYBjpRNJ2F55McWeNWRjEN26/3VzHInaAQBqUPy4ZZS2Pxti7KBXqNqzxIqUDYF
         3SlhQtI3YhCFJgZEEJNu5OkHjYi8ailHKP95S165jd2Oz+rAaNCG3IW0TT6+Pmv0li
         rdOU/+SR1vfOtH8o71X11YG6G+9aaaHWpzw0heL0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Anton Ivanov <anton.ivanov@cambridgegreys.com>,
        Richard Weinberger <richard@nod.at>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 282/453] um: tty: Fix handling of close in tty lines
Date:   Mon, 28 Dec 2020 13:48:38 +0100
Message-Id: <20201228124950.781042007@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124937.240114599@linuxfoundation.org>
References: <20201228124937.240114599@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Anton Ivanov <anton.ivanov@cambridgegreys.com>

[ Upstream commit 9b1c0c0e25dcccafd30e7d4c150c249cc65550eb ]

Fix a logical error in tty reading. We get 0 and errno == EAGAIN
on the first attempt to read from a closed file descriptor.

Compared to that a true EAGAIN is EAGAIN and -1.

If we check errno for EAGAIN first, before checking the return
value we miss the fact that the descriptor is closed.

This bug is as old as the driver. It was not showing up with
the original POLL based IRQ controller, because it was
producing multiple events. Switching to EPOLL unmasked it.

Fixes: ff6a17989c08 ("Epoll based IRQ controller")
Signed-off-by: Anton Ivanov <anton.ivanov@cambridgegreys.com>
Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/um/drivers/chan_user.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/um/drivers/chan_user.c b/arch/um/drivers/chan_user.c
index 4d80526a4236e..d8845d4aac6a7 100644
--- a/arch/um/drivers/chan_user.c
+++ b/arch/um/drivers/chan_user.c
@@ -26,10 +26,10 @@ int generic_read(int fd, char *c_out, void *unused)
 	n = read(fd, c_out, sizeof(*c_out));
 	if (n > 0)
 		return n;
-	else if (errno == EAGAIN)
-		return 0;
 	else if (n == 0)
 		return -EIO;
+	else if (errno == EAGAIN)
+		return 0;
 	return -errno;
 }
 
-- 
2.27.0



