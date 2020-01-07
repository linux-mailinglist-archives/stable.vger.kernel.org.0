Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E35C71332DA
	for <lists+stable@lfdr.de>; Tue,  7 Jan 2020 22:14:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729580AbgAGVJt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jan 2020 16:09:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:35584 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729868AbgAGVJo (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Jan 2020 16:09:44 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 45D172077B;
        Tue,  7 Jan 2020 21:09:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578431383;
        bh=xfY0Bi9UHxCB8JaSZ+qYTGH4RoqOvqbb5ZXpEwB30YU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=r/XiDxOAy5JvIU76f4+QLcwdDoFZPs2H5niP1hZ3ov8s/bwsLs4ErkoqJFn7XEKm3
         g50J3whQPORGjglxLN5UagJDmrLKIcH7DrBLxWuKL+YJa+WUN8O4/uObDy7oZQL4df
         JWLxSMAc/JYRxW0Q78pTJrYf3LUrr37q2Bw6pCuk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Damien Le Moal <damien.lemoal@wdc.com>,
        Arnd Bergmann <arnd@arndb.de>, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 4.14 35/74] compat_ioctl: block: handle BLKREPORTZONE/BLKRESETZONE
Date:   Tue,  7 Jan 2020 21:55:00 +0100
Message-Id: <20200107205205.266079507@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200107205135.369001641@linuxfoundation.org>
References: <20200107205135.369001641@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

commit 673bdf8ce0a387ef585c13b69a2676096c6edfe9 upstream.

These were added to blkdev_ioctl() but not blkdev_compat_ioctl,
so add them now.

Cc: <stable@vger.kernel.org> # v4.10+
Fixes: 3ed05a987e0f ("blk-zoned: implement ioctls")
Reviewed-by: Damien Le Moal <damien.lemoal@wdc.com>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 block/compat_ioctl.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/block/compat_ioctl.c
+++ b/block/compat_ioctl.c
@@ -355,6 +355,8 @@ long compat_blkdev_ioctl(struct file *fi
 	 * but we call blkdev_ioctl, which gets the lock for us
 	 */
 	case BLKRRPART:
+	case BLKREPORTZONE:
+	case BLKRESETZONE:
 		return blkdev_ioctl(bdev, mode, cmd,
 				(unsigned long)compat_ptr(arg));
 	case BLKBSZSET_32:


