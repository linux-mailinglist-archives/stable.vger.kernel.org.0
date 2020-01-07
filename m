Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 051F9133460
	for <lists+stable@lfdr.de>; Tue,  7 Jan 2020 22:25:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727830AbgAGVAF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jan 2020 16:00:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:34116 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727733AbgAGVAF (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Jan 2020 16:00:05 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 83DB82081E;
        Tue,  7 Jan 2020 21:00:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578430805;
        bh=zhn7nBfRDeH8Ol627tHo1Y9YVjTIhuLu8UENFkLNKiI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JpPhP9Vd8sCdHB2rtoB4VkBbT9oCVMXKKz/sE8kI/Cl895Yqww1nnpdLngBxUxo6X
         s9kJVImvUfRK6GosSeEhRpdVodd0/geea+BzHSuXvyREL9AUciei421QjzwlHVRGis
         1G5h1kG8nVEf0Kio6aPC06xDWckaDuoQ+QyBrX+A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Damien Le Moal <damien.lemoal@wdc.com>,
        Arnd Bergmann <arnd@arndb.de>, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.4 103/191] compat_ioctl: block: handle BLKGETZONESZ/BLKGETNRZONES
Date:   Tue,  7 Jan 2020 21:53:43 +0100
Message-Id: <20200107205338.504353839@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200107205332.984228665@linuxfoundation.org>
References: <20200107205332.984228665@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

commit 21d37340912d74b1222d43c11aa9dd0687162573 upstream.

These were added to blkdev_ioctl() in v4.20 but not blkdev_compat_ioctl,
so add them now.

Cc: <stable@vger.kernel.org> # v4.20+
Fixes: 72cd87576d1d ("block: Introduce BLKGETZONESZ ioctl")
Fixes: 65e4e3eee83d ("block: Introduce BLKGETNRZONES ioctl")
Reviewed-by: Damien Le Moal <damien.lemoal@wdc.com>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 block/compat_ioctl.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/block/compat_ioctl.c
+++ b/block/compat_ioctl.c
@@ -357,6 +357,8 @@ long compat_blkdev_ioctl(struct file *fi
 	case BLKRRPART:
 	case BLKREPORTZONE:
 	case BLKRESETZONE:
+	case BLKGETZONESZ:
+	case BLKGETNRZONES:
 		return blkdev_ioctl(bdev, mode, cmd,
 				(unsigned long)compat_ptr(arg));
 	case BLKBSZSET_32:


