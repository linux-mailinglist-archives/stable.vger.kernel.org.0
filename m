Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A7052D03AC
	for <lists+stable@lfdr.de>; Sun,  6 Dec 2020 12:50:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728175AbgLFLjr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Dec 2020 06:39:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:36006 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728108AbgLFLjr (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 6 Dec 2020 06:39:47 -0500
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 4.19 07/32] tun: honor IOCB_NOWAIT flag
Date:   Sun,  6 Dec 2020 12:17:07 +0100
Message-Id: <20201206111556.130378098@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201206111555.787862631@linuxfoundation.org>
References: <20201206111555.787862631@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jens Axboe <axboe@kernel.dk>

[ Upstream commit 5aac0390a63b8718237a61dd0d24a29201d1c94a ]

tun only checks the file O_NONBLOCK flag, but it should also be checking
the iocb IOCB_NOWAIT flag. Any fops using ->read/write_iter() should check
both, otherwise it breaks users that correctly expect O_NONBLOCK semantics
if IOCB_NOWAIT is set.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
Link: https://lore.kernel.org/r/e9451860-96cc-c7c7-47b8-fe42cadd5f4c@kernel.dk
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/tun.c |   14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -1988,12 +1988,15 @@ static ssize_t tun_chr_write_iter(struct
 	struct tun_file *tfile = file->private_data;
 	struct tun_struct *tun = tun_get(tfile);
 	ssize_t result;
+	int noblock = 0;
 
 	if (!tun)
 		return -EBADFD;
 
-	result = tun_get_user(tun, tfile, NULL, from,
-			      file->f_flags & O_NONBLOCK, false);
+	if ((file->f_flags & O_NONBLOCK) || (iocb->ki_flags & IOCB_NOWAIT))
+		noblock = 1;
+
+	result = tun_get_user(tun, tfile, NULL, from, noblock, false);
 
 	tun_put(tun);
 	return result;
@@ -2214,10 +2217,15 @@ static ssize_t tun_chr_read_iter(struct
 	struct tun_file *tfile = file->private_data;
 	struct tun_struct *tun = tun_get(tfile);
 	ssize_t len = iov_iter_count(to), ret;
+	int noblock = 0;
 
 	if (!tun)
 		return -EBADFD;
-	ret = tun_do_read(tun, tfile, to, file->f_flags & O_NONBLOCK, NULL);
+
+	if ((file->f_flags & O_NONBLOCK) || (iocb->ki_flags & IOCB_NOWAIT))
+		noblock = 1;
+
+	ret = tun_do_read(tun, tfile, to, noblock, NULL);
 	ret = min_t(ssize_t, ret, len);
 	if (ret > 0)
 		iocb->ki_pos = ret;


