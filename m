Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F618371D47
	for <lists+stable@lfdr.de>; Mon,  3 May 2021 19:01:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232553AbhECQ6h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 May 2021 12:58:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:44504 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235368AbhECQ4U (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 May 2021 12:56:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 130B06142C;
        Mon,  3 May 2021 16:43:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620060219;
        bh=QtrTKay1ajT/LKJmg8N/4yTTMxUhtwIbpfISVZoFGt8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rHxw4GwQ8CE2fmfkcQCXZ5TWVL9FRlGh2JKYyIIHcGTYxe3fEesIvHjQcb4dF+z5n
         XDbLvMydHbJoOeRb6pl6VEgpFPq30ZTv8zClFYqKgcyxjqOJ56lxJm8D42CiMe7t3k
         Ye7z6XZ5QQXQpVCG0zGp/9AKZln9zgAmAiL39DyZgYsUP2fXSfr0VOLTtEKkIds+Eq
         H7W5a3IKm5VpXxl9hJ/Y+hFHAhLsSg5UmoqOy2OoUY9PL5hU4xp7wIVUwqYjVDtKDU
         Kd/RhyvvyMD3kI8pcCagCD75ty0KOO70vXGlqcwNpE450cWtc6Iv87IGDe4AgL29xb
         jNcFdtN22VF7w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Muhammad Usama Anjum <musamaanjum@gmail.com>,
        syzbot+889397c820fa56adf25d@syzkaller.appspotmail.com,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 06/16] media: em28xx: fix memory leak
Date:   Mon,  3 May 2021 12:43:19 -0400
Message-Id: <20210503164329.2854739-6-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210503164329.2854739-1-sashal@kernel.org>
References: <20210503164329.2854739-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Muhammad Usama Anjum <musamaanjum@gmail.com>

[ Upstream commit 0ae10a7dc8992ee682ff0b1752ff7c83d472eef1 ]

If some error occurs, URB buffers should also be freed. If they aren't
freed with the dvb here, the em28xx_dvb_fini call doesn't frees the URB
buffers as dvb is set to NULL. The function in which error occurs should
do all the cleanup for the allocations it had done.

Tested the patch with the reproducer provided by syzbot. This patch
fixes the memleak.

Reported-by: syzbot+889397c820fa56adf25d@syzkaller.appspotmail.com
Signed-off-by: Muhammad Usama Anjum <musamaanjum@gmail.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/usb/em28xx/em28xx-dvb.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/usb/em28xx/em28xx-dvb.c b/drivers/media/usb/em28xx/em28xx-dvb.c
index 5502a0fb94fd..a19c89009bf3 100644
--- a/drivers/media/usb/em28xx/em28xx-dvb.c
+++ b/drivers/media/usb/em28xx/em28xx-dvb.c
@@ -1757,6 +1757,7 @@ static int em28xx_dvb_init(struct em28xx *dev)
 	return result;
 
 out_free:
+	em28xx_uninit_usb_xfer(dev, EM28XX_DIGITAL_MODE);
 	kfree(dvb);
 	dev->dvb = NULL;
 	goto ret;
-- 
2.30.2

