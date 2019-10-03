Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7C0D2CA96F
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 19:21:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392376AbfJCQmZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 12:42:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:53420 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404377AbfJCQmZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 12:42:25 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 30F9F2054F;
        Thu,  3 Oct 2019 16:42:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570120944;
        bh=nLBmpST4CMAjbXYt20w4xU7PrLmWj0RW/y6RZSzDzaA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PKJAWrX0Bbf4HWQeJsjv2VG6pPVPpedEDICL4+dprNRcZlRz9nOw61kYQwVAvz3l0
         8p9tkvH0tc9S8PHMRAl7CvglkBuc5cNgd2WRqOBY35M8IApFXMXpVkOvp9AhNFupId
         i6SEkDG1TjXi9oMSn53mCafYOfrmotLcD/bCIy4o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Alessio Balsini <balsini@android.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 095/344] loop: Add LOOP_SET_DIRECT_IO to compat ioctl
Date:   Thu,  3 Oct 2019 17:51:00 +0200
Message-Id: <20191003154549.555742720@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154540.062170222@linuxfoundation.org>
References: <20191003154540.062170222@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



