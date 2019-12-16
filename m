Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2B2B21215B0
	for <lists+stable@lfdr.de>; Mon, 16 Dec 2019 19:24:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731971AbfLPSTr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 13:19:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:48510 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731945AbfLPSTq (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Dec 2019 13:19:46 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8B631207FF;
        Mon, 16 Dec 2019 18:19:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576520386;
        bh=7OlzjaWYrNlZkBYMjW7YaLZgbyz7GzE2h/34B75E5tE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1bL7z9IqJiCQtqmLZ9ipm+Y2INnzideCXelZ6QwhMB6lPoGAGrfd1jIWDUYK3Zu4J
         NHJWvug+Z27C6KHXp6VhlZo3NqvyxoelZN7CEfU/I2aN0MMDd4xQTeKy8oPlrL0kvr
         fteZ7yzyT6/lunMcnOBlFcw7agtINgfti4vjTD3I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ming Lei <ming.lei@redhat.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.4 092/177] blk-mq: avoid sysfs buffer overflow with too many CPU cores
Date:   Mon, 16 Dec 2019 18:49:08 +0100
Message-Id: <20191216174839.279464492@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191216174811.158424118@linuxfoundation.org>
References: <20191216174811.158424118@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ming Lei <ming.lei@redhat.com>

commit 8962842ca5abdcf98e22ab3b2b45a103f0408b95 upstream.

It is reported that sysfs buffer overflow can be triggered if the system
has too many CPU cores(>841 on 4K PAGE_SIZE) when showing CPUs of
hctx via /sys/block/$DEV/mq/$N/cpu_list.

Use snprintf to avoid the potential buffer overflow.

This version doesn't change the attribute format, and simply stops
showing CPU numbers if the buffer is going to overflow.

Cc: stable@vger.kernel.org
Fixes: 676141e48af7("blk-mq: don't dump CPU -> hw queue map on driver load")
Signed-off-by: Ming Lei <ming.lei@redhat.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 block/blk-mq-sysfs.c |   15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

--- a/block/blk-mq-sysfs.c
+++ b/block/blk-mq-sysfs.c
@@ -166,20 +166,25 @@ static ssize_t blk_mq_hw_sysfs_nr_reserv
 
 static ssize_t blk_mq_hw_sysfs_cpus_show(struct blk_mq_hw_ctx *hctx, char *page)
 {
+	const size_t size = PAGE_SIZE - 1;
 	unsigned int i, first = 1;
-	ssize_t ret = 0;
+	int ret = 0, pos = 0;
 
 	for_each_cpu(i, hctx->cpumask) {
 		if (first)
-			ret += sprintf(ret + page, "%u", i);
+			ret = snprintf(pos + page, size - pos, "%u", i);
 		else
-			ret += sprintf(ret + page, ", %u", i);
+			ret = snprintf(pos + page, size - pos, ", %u", i);
+
+		if (ret >= size - pos)
+			break;
 
 		first = 0;
+		pos += ret;
 	}
 
-	ret += sprintf(ret + page, "\n");
-	return ret;
+	ret = snprintf(pos + page, size - pos, "\n");
+	return pos + ret;
 }
 
 static struct blk_mq_hw_ctx_sysfs_entry blk_mq_hw_sysfs_nr_tags = {


