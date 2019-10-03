Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A1637CA9F3
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 19:25:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389177AbfJCQRJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 12:17:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:42672 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389171AbfJCQRJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 12:17:09 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 189CB20865;
        Thu,  3 Oct 2019 16:17:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570119428;
        bh=qv9ygTfvEiKSBYql2/cnEalR9CuEm7hiXBuwEhcKLyI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TvHc88VYQMPY2SdiL9nVJQdwQRQeQFwTe1esTj100DTlim+HCjbqk9gv1DhijsRtJ
         /TZdBpBugbnK8fGpWGObRdu8h+yDNKusdc6+8txz8EDb0oVYse0SkO9dgs3qET3wi2
         m30iTXNQ7wTN6rW6rEgl1k6qwrexuduCcBkW1HQw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Alessio Balsini <balsini@android.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 060/211] loop: Add LOOP_SET_DIRECT_IO to compat ioctl
Date:   Thu,  3 Oct 2019 17:52:06 +0200
Message-Id: <20191003154502.001730641@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154447.010950442@linuxfoundation.org>
References: <20191003154447.010950442@linuxfoundation.org>
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
index cef8e00c9d9d6..126c2c5146732 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -1719,6 +1719,7 @@ static int lo_compat_ioctl(struct block_device *bdev, fmode_t mode,
 	case LOOP_SET_FD:
 	case LOOP_CHANGE_FD:
 	case LOOP_SET_BLOCK_SIZE:
+	case LOOP_SET_DIRECT_IO:
 		err = lo_ioctl(bdev, mode, cmd, arg);
 		break;
 	default:
-- 
2.20.1



