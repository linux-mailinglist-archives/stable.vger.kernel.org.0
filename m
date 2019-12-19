Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F337B1269BE
	for <lists+stable@lfdr.de>; Thu, 19 Dec 2019 19:40:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728399AbfLSSkn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Dec 2019 13:40:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:59494 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728408AbfLSSkl (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Dec 2019 13:40:41 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 900E724679;
        Thu, 19 Dec 2019 18:40:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576780841;
        bh=chLQgsXuHkoQm2h4ueJb1deFdiqcUC5TRor73eu385Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Qb0FUGYpyBu7cuee/009EDQt69lk55KQoFWKopImXYXTQAj0vSkfl+LqzPwXWKrHU
         uwmDKo0+myDv8n6nY8q/azs7SUo4aqhIKAkjnc2ZAxX8JJNcrAQFciLi5HR6erna+5
         jos7HciPKj81I8ww7CjvmjCsuDv7dEb+ePZP0qJM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ming Lei <ming.lei@redhat.com>,
        Jens Axboe <axboe@kernel.dk>,
        Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
Subject: [PATCH 4.4 139/162] blk-mq: make sure that line break can be printed
Date:   Thu, 19 Dec 2019 19:34:07 +0100
Message-Id: <20191219183216.228258091@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191219183150.477687052@linuxfoundation.org>
References: <20191219183150.477687052@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ming Lei <ming.lei@redhat.com>

commit d2c9be89f8ebe7ebcc97676ac40f8dec1cf9b43a upstream.

8962842ca5ab ("blk-mq: avoid sysfs buffer overflow with too many CPU cores")
avoids sysfs buffer overflow, and reserves one character for line break.
However, the last snprintf() doesn't get correct 'size' parameter passed
in, so fixed it.

Fixes: 8962842ca5ab ("blk-mq: avoid sysfs buffer overflow with too many CPU cores")
Signed-off-by: Ming Lei <ming.lei@redhat.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Cc: Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 block/blk-mq-sysfs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/block/blk-mq-sysfs.c
+++ b/block/blk-mq-sysfs.c
@@ -248,7 +248,7 @@ static ssize_t blk_mq_hw_sysfs_cpus_show
 		pos += ret;
 	}
 
-	ret = snprintf(pos + page, size - pos, "\n");
+	ret = snprintf(pos + page, size + 1 - pos, "\n");
 	return pos + ret;
 }
 


