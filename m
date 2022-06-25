Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C14655A932
	for <lists+stable@lfdr.de>; Sat, 25 Jun 2022 13:06:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232556AbiFYLBi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 25 Jun 2022 07:01:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232449AbiFYLBc (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 25 Jun 2022 07:01:32 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A9B933E85;
        Sat, 25 Jun 2022 04:01:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 433C3B80819;
        Sat, 25 Jun 2022 11:01:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA2AAC3411C;
        Sat, 25 Jun 2022 11:01:26 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="Pxi0sFTP"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1656154885;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=JNNN4Nj1miNoSxQ1yWGxKg9y+sxo5e8P5nh7EInqsQA=;
        b=Pxi0sFTPbBMbw5Gel7H+iNnKefzSo6WbgpZgRIgvFzgqQNRwhSEvCRKGbNypFbQ3OeRebf
        i0uOjuF4/SPTrmQWKM2+Y4yXKK8p5fjV9TUfG+s9ugat+TTB1goPzadO46/obxvUIJav+N
        7Hn7+cDLQ68qkN9FtKA/qIO0h/s5xMw=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 7be98917 (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Sat, 25 Jun 2022 11:01:25 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk,
        Jens Axboe <axboe@kernel.dk>, linux-fsdevel@vger.kernel.org
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>, stable@vger.kernel.org,
        linux-cifs@vger.kernel.org, Steve French <stfrench@microsoft.com>,
        Ronnie Sahlberg <lsahlber@redhat.com>,
        Hyunchul Lee <hyc.lee@gmail.com>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        Namjae Jeon <linkinjeon@kernel.org>
Subject: [PATCH v2 1/8] ksmbd: use vfs_llseek instead of dereferencing NULL
Date:   Sat, 25 Jun 2022 13:01:08 +0200
Message-Id: <20220625110115.39956-2-Jason@zx2c4.com>
In-Reply-To: <20220625110115.39956-1-Jason@zx2c4.com>
References: <20220625110115.39956-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

By not checking whether llseek is NULL, this might jump to NULL. Also,
it doesn't check FMODE_LSEEK. Fix this by using vfs_llseek(), which
always does the right thing.

Fixes: f44158485826 ("cifsd: add file operations")
Cc: stable@vger.kernel.org
Cc: linux-cifs@vger.kernel.org
Cc: Steve French <stfrench@microsoft.com>
Cc: Ronnie Sahlberg <lsahlber@redhat.com>
Cc: Hyunchul Lee <hyc.lee@gmail.com>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Reviewed-by: Namjae Jeon <linkinjeon@kernel.org>
Acked-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
---
 fs/ksmbd/vfs.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/ksmbd/vfs.c b/fs/ksmbd/vfs.c
index dcdd07c6efff..9cf2e2365832 100644
--- a/fs/ksmbd/vfs.c
+++ b/fs/ksmbd/vfs.c
@@ -1046,7 +1046,7 @@ int ksmbd_vfs_fqar_lseek(struct ksmbd_file *fp, loff_t start, loff_t length,
 	*out_count = 0;
 	end = start + length;
 	while (start < end && *out_count < in_count) {
-		extent_start = f->f_op->llseek(f, start, SEEK_DATA);
+		extent_start = vfs_llseek(f, start, SEEK_DATA);
 		if (extent_start < 0) {
 			if (extent_start != -ENXIO)
 				ret = (int)extent_start;
@@ -1056,7 +1056,7 @@ int ksmbd_vfs_fqar_lseek(struct ksmbd_file *fp, loff_t start, loff_t length,
 		if (extent_start >= end)
 			break;
 
-		extent_end = f->f_op->llseek(f, extent_start, SEEK_HOLE);
+		extent_end = vfs_llseek(f, extent_start, SEEK_HOLE);
 		if (extent_end < 0) {
 			if (extent_end != -ENXIO)
 				ret = (int)extent_end;
-- 
2.35.1

