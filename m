Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E8D2373EB9
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 22:27:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729000AbfGXTga (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 15:36:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:36244 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728976AbfGXTg3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Jul 2019 15:36:29 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 223EB22ADA;
        Wed, 24 Jul 2019 19:36:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563996988;
        bh=Tw8jnuM1i+2gm8nqa5LMXp0MFNQ7viicxBAZ92VgQOE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=v5zsbV+cppRiN1/g0jvM4cqDGGgOm5tQLeRo1qT4Tn6zig6kFPT80PobkViPVIm23
         KZPRiFwF2RJadi6SrxTfW2XZQZDD/fJ58b0sVDC7ZppF1s6TEEA2L8+L0rmIxI9hH4
         LoAGL/0Cxtw8oAuBGH2NhBkuOCrC3s/c3lMfHUU4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Coly Li <colyli@suse.de>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.2 284/413] bcache: fix mistaken sysfs entry for io_error counter
Date:   Wed, 24 Jul 2019 21:19:35 +0200
Message-Id: <20190724191756.598510320@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190724191735.096702571@linuxfoundation.org>
References: <20190724191735.096702571@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Coly Li <colyli@suse.de>

commit 5461999848e0462c14f306a62923d22de820a59c upstream.

In bch_cached_dev_files[] from driver/md/bcache/sysfs.c, sysfs_errors is
incorrectly inserted in. The correct entry should be sysfs_io_errors.

This patch fixes the problem and now I/O errors of cached device can be
read from /sys/block/bcache<N>/bcache/io_errors.

Fixes: c7b7bd07404c5 ("bcache: add io_disable to struct cached_dev")
Signed-off-by: Coly Li <colyli@suse.de>
Cc: stable@vger.kernel.org
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/md/bcache/sysfs.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/md/bcache/sysfs.c
+++ b/drivers/md/bcache/sysfs.c
@@ -182,7 +182,7 @@ SHOW(__bch_cached_dev)
 	var_print(writeback_percent);
 	sysfs_hprint(writeback_rate,
 		     wb ? atomic_long_read(&dc->writeback_rate.rate) << 9 : 0);
-	sysfs_hprint(io_errors,		atomic_read(&dc->io_errors));
+	sysfs_printf(io_errors,		"%i", atomic_read(&dc->io_errors));
 	sysfs_printf(io_error_limit,	"%i", dc->error_limit);
 	sysfs_printf(io_disable,	"%i", dc->io_disable);
 	var_print(writeback_rate_update_seconds);
@@ -474,7 +474,7 @@ static struct attribute *bch_cached_dev_
 	&sysfs_writeback_rate_p_term_inverse,
 	&sysfs_writeback_rate_minimum,
 	&sysfs_writeback_rate_debug,
-	&sysfs_errors,
+	&sysfs_io_errors,
 	&sysfs_io_error_limit,
 	&sysfs_io_disable,
 	&sysfs_dirty_data,


