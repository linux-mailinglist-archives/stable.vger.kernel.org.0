Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DF5F2E4045
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:51:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502163AbgL1OUI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:20:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:55430 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2436589AbgL1OUH (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:20:07 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 418D022573;
        Mon, 28 Dec 2020 14:19:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609165166;
        bh=nVCVeaYmCZ31IeiiiRWPTdvvzAVNd5cTuQmGpIDznt0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Jf79SvEBKeK9mcE/aL0efbs0jkZRKTA8v4dgF2CWakB4HU//+cQXcpGSRAPaFHGOH
         NdQzXTR2QFiSzhKl1oVfW+/+5usxve4q2KnrlOdC4cb2S5Ft7DT4WKqkdk5zkdeDBO
         2vf2Sj7vkxzFCAbc270jvWC135aGKVEcM+Gl9lhA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Anton Ivanov <anton.ivanov@cambridgegreys.com>,
        Richard Weinberger <richard@nod.at>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 435/717] um: tty: Fix handling of close in tty lines
Date:   Mon, 28 Dec 2020 13:47:13 +0100
Message-Id: <20201228125041.812890471@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
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



