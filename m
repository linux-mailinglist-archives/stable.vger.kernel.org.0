Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43603559F07
	for <lists+stable@lfdr.de>; Fri, 24 Jun 2022 19:06:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231483AbiFXQ5H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jun 2022 12:57:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229852AbiFXQ5B (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 24 Jun 2022 12:57:01 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E7574755A;
        Fri, 24 Jun 2022 09:57:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 21720B82AC3;
        Fri, 24 Jun 2022 16:56:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6033C34114;
        Fri, 24 Jun 2022 16:56:56 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="g8aOL54g"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1656089814;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=B5jxNGu8opF7t3Jl2pSk5/2vQDWUwWhSwKtewz1HbUo=;
        b=g8aOL54gjr/c2aMQnr/Cx31CRq4sQmXmE4weUZX7j0S3GJogdXhQG3fKlemjSFOvNzDJrO
        vaNjQpgSuLNxodC7/Wzp5Kco/2wKkSgghv0tbwz4ScgDuQyMLUUJ+2E6ImZBJPeb+ohHUk
        GHQ+AIkW93eIz/NWEqDKWypNbOTVRzc=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id adfb2012 (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Fri, 24 Jun 2022 16:56:54 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk,
        Jens Axboe <axboe@kernel.dk>, linux-fsdevel@vger.kernel.org
Cc:     "Jason A. Donenfeld" <Jason@zx2c4.com>, stable@vger.kernel.org,
        linux-cifs@vger.kernel.org, Namjae Jeon <namjae.jeon@samsung.com>,
        Steve French <stfrench@microsoft.com>,
        Ronnie Sahlberg <lsahlber@redhat.com>,
        Hyunchul Lee <hyc.lee@gmail.com>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Subject: [PATCH 1/6] ksmbd: use vfs_llseek instead of dereferencing NULL
Date:   Fri, 24 Jun 2022 18:56:26 +0200
Message-Id: <20220624165631.2124632-2-Jason@zx2c4.com>
In-Reply-To: <20220624165631.2124632-1-Jason@zx2c4.com>
References: <20220624165631.2124632-1-Jason@zx2c4.com>
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
Cc: Namjae Jeon <namjae.jeon@samsung.com>
Cc: Steve French <stfrench@microsoft.com>
Cc: Ronnie Sahlberg <lsahlber@redhat.com>
Cc: Hyunchul Lee <hyc.lee@gmail.com>
Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
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

