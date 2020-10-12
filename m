Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB7A128B8FD
	for <lists+stable@lfdr.de>; Mon, 12 Oct 2020 15:57:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390541AbgJLN4r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Oct 2020 09:56:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:48360 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389426AbgJLNoE (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Oct 2020 09:44:04 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BC87E221FF;
        Mon, 12 Oct 2020 13:43:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602510234;
        bh=3DrKcRe3aNaVQDELlKhC+Gj/MPcIqbyiT/Nvd5WmGew=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LcahmIPjOohYYgb4XdUB1/t56U2joXFm6W95d/qheL8/coY563nAx0sN14xlKPvrd
         Hh9QuSyPYfBTZvVHECtgveu82FKRVFxLmug3JeF4qrfMBdLv2BZfvHDUjvr1frBOGx
         HOVi2JW4kBqEEC0dDrkwyCmcveh5MlbHJ4hSjDpY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Arnd Bergmann <arnd@arndb.de>,
        syzbot+85433a479a646a064ab3@syzkaller.appspotmail.com,
        Peilin Ye <yepeilin.cs@gmail.com>, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.8 012/124] block/scsi-ioctl: Fix kernel-infoleak in scsi_put_cdrom_generic_arg()
Date:   Mon, 12 Oct 2020 15:30:16 +0200
Message-Id: <20201012133147.448170605@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201012133146.834528783@linuxfoundation.org>
References: <20201012133146.834528783@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peilin Ye <yepeilin.cs@gmail.com>

commit 6d53a9fe5a1983490bc14b3a64d49fabb4ccc651 upstream.

scsi_put_cdrom_generic_arg() is copying uninitialized stack memory to
userspace, since the compiler may leave a 3-byte hole in the middle of
`cgc32`. Fix it by adding a padding field to `struct
compat_cdrom_generic_command`.

Cc: stable@vger.kernel.org
Fixes: f3ee6e63a9df ("compat_ioctl: move CDROM_SEND_PACKET handling into scsi")
Suggested-by: Dan Carpenter <dan.carpenter@oracle.com>
Suggested-by: Arnd Bergmann <arnd@arndb.de>
Reported-by: syzbot+85433a479a646a064ab3@syzkaller.appspotmail.com
Signed-off-by: Peilin Ye <yepeilin.cs@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 block/scsi_ioctl.c |    1 +
 1 file changed, 1 insertion(+)

--- a/block/scsi_ioctl.c
+++ b/block/scsi_ioctl.c
@@ -651,6 +651,7 @@ struct compat_cdrom_generic_command {
 	compat_int_t	stat;
 	compat_caddr_t	sense;
 	unsigned char	data_direction;
+	unsigned char	pad[3];
 	compat_int_t	quiet;
 	compat_int_t	timeout;
 	compat_caddr_t	reserved[1];


