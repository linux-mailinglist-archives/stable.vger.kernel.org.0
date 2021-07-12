Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 841C43C47EE
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:28:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236710AbhGLGf1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:35:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:54054 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237683AbhGLGeq (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:34:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A751F60FD8;
        Mon, 12 Jul 2021 06:31:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626071485;
        bh=ncFe/9efYb9vykiPBpuZ6xpCFkcgc1CsfK81nIWM6ko=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AB/DeL5hyYdFmSKj6au1Iv5v9agUyiFgSveRMDFQFElwa03lyUgNAcU3l9nlJpWJ9
         OXYUJ5IOOUREA1RqKP/DofkRO0ZHR26zuHr0htJK8DC8J8KBF2A5NVuRcgCgUS3vWE
         SJXverJsQykXjwehYLfUXUi24Ov3qLUOCSI0sPDs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kristian Klausen <kristian@klausen.dk>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.10 090/593] loop: Fix missing discard support when using LOOP_CONFIGURE
Date:   Mon, 12 Jul 2021 08:04:10 +0200
Message-Id: <20210712060853.104528720@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060843.180606720@linuxfoundation.org>
References: <20210712060843.180606720@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kristian Klausen <kristian@klausen.dk>

commit 2b9ac22b12a266eb4fec246a07b504dd4983b16b upstream.

Without calling loop_config_discard() the discard flag and parameters
aren't set/updated for the loop device and worst-case they could
indicate discard support when it isn't the case (ex: if the
LOOP_SET_STATUS ioctl was used with a different file prior to
LOOP_CONFIGURE).

Cc: <stable@vger.kernel.org> # 5.8.x-
Fixes: 3448914e8cc5 ("loop: Add LOOP_CONFIGURE ioctl")
Signed-off-by: Kristian Klausen <kristian@klausen.dk>
Link: https://lore.kernel.org/r/20210618115157.31452-1-kristian@klausen.dk
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/block/loop.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -1161,6 +1161,7 @@ static int loop_configure(struct loop_de
 	blk_queue_physical_block_size(lo->lo_queue, bsize);
 	blk_queue_io_min(lo->lo_queue, bsize);
 
+	loop_config_discard(lo);
 	loop_update_rotational(lo);
 	loop_update_dio(lo);
 	loop_sysfs_init(lo);


