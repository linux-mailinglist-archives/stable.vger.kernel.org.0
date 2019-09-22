Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2C7CCBA5D5
	for <lists+stable@lfdr.de>; Sun, 22 Sep 2019 21:45:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389657AbfIVSpy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Sep 2019 14:45:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:41720 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389638AbfIVSpx (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 22 Sep 2019 14:45:53 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CA9D7206C2;
        Sun, 22 Sep 2019 18:45:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569177953;
        bh=nLBmpST4CMAjbXYt20w4xU7PrLmWj0RW/y6RZSzDzaA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=H0SbaxB2PIw6cjJsgboXFiuS2P9Bcz/E1jnj34dsr2rErVR3R5X3rqbqpchBDXCv2
         CW3nUfvQ9JKY+7dQzwuI1bxb4SBRl8sVwnJT3CyyGbd+5Sd4kQ80kcpYz/WM7MDfi8
         AIjFqbx8PskmT1MRAiYNuyQk7qB4H1UNLuIEoYGE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alessio Balsini <balsini@android.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>,
        linux-block@vger.kernel.org
Subject: [PATCH AUTOSEL 5.3 059/203] loop: Add LOOP_SET_DIRECT_IO to compat ioctl
Date:   Sun, 22 Sep 2019 14:41:25 -0400
Message-Id: <20190922184350.30563-59-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190922184350.30563-1-sashal@kernel.org>
References: <20190922184350.30563-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alessio Balsini <balsini@android.com>

[ Upstream commit fdbe4eeeb1aac219b14f10c0ed31ae5d1123e9b8 ]

Enabling Direct I/O with loop devices helps reducing memory usage by
avoiding double caching.  32 bit applications running on 64 bits systems
are currently not able to request direct I/O because is missing from the
lo_compat_ioctl.

This patch fixes the compatibility issue mentioned above by exporting
LOOP_SET_DIRECT_IO as additional lo_compat_ioctl() entry.
The input argument for this ioctl is a single long converted to a 1-bit
boolean, so compatibility is preserved.

Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Alessio Balsini <balsini@android.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/loop.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index ab7ca5989097a..1410fa8936538 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -1755,6 +1755,7 @@ static int lo_compat_ioctl(struct block_device *bdev, fmode_t mode,
 	case LOOP_SET_FD:
 	case LOOP_CHANGE_FD:
 	case LOOP_SET_BLOCK_SIZE:
+	case LOOP_SET_DIRECT_IO:
 		err = lo_ioctl(bdev, mode, cmd, arg);
 		break;
 	default:
-- 
2.20.1

