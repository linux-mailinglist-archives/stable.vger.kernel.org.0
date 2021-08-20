Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C2793F294E
	for <lists+stable@lfdr.de>; Fri, 20 Aug 2021 11:37:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236704AbhHTJh5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Aug 2021 05:37:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236861AbhHTJh4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 20 Aug 2021 05:37:56 -0400
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CB0DC061757;
        Fri, 20 Aug 2021 02:37:18 -0700 (PDT)
Received: by mail-wm1-x32b.google.com with SMTP id f13-20020a1c6a0d000000b002e6fd0b0b3fso7011344wmc.3;
        Fri, 20 Aug 2021 02:37:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=11Is/JpmDwZ8TjK5P+o8Ww1+JBTDF9nhOzhsEQoY6to=;
        b=SKeTjonD05EJUIWGdSE0pq9Y4/0st+4/EgRz09arb7JWdQDP+pfvWZwxUNOHb4bbXY
         PR5UU6Pv/GpkSiVpfBXpRtIvU+jCyXV0h97mWJ2PaDyc/NccHF70jvNP85B2lXcKxItB
         ff2gtCtvvLyqBbBNXMsls8/CSZgmaJwQb0YHx8VoxZnwXeXN72dDoBtfPXIdQAFgcvXd
         ZwMkRLeuTB85n1SdPP1yEo7pIHJ9+TlCzsxZC/4GFvn8g+8RQgGYQD7OU+NyLBc3w6sO
         kMo221YhJ2/NM7tSY3nihLpPYXZGTwkJIZtrTXCoBZL+sDvJrS2bseZB9hLMJ2oE77zk
         RxiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=11Is/JpmDwZ8TjK5P+o8Ww1+JBTDF9nhOzhsEQoY6to=;
        b=VnIpZC0aiAWPMkTFB7vJbOmO5suiTMN1/ylOkAjnOhSjnIaUs4zadkIvvB7s5ubSJA
         PiCPfDbDXUAXh8iKLAzT5y1g5BQGXAozO7ZvhVsw1tg3Vs/RjMQ3OSAbpm8FRkaO5Yqh
         43kfGMrP6hoB5mdpN8JXs5ILgRfMS0gSUCNFZUMjkQn86ZoVecTDokWdONVwDCHNU51s
         lzwpjqf6BwRLSz+KkiR7VdgYoZFJh04WDvJs8lisyodCD0MHXpvsgPQAfbBoHX1M5in1
         7yX526u+as6sjnpuLC9CmdhxhuXyCxKgyYjJIxiqej+F0cgHJp3z0kjjdmQUVOQOSQNm
         yVsw==
X-Gm-Message-State: AOAM531AAM3DEol6E+Ggdtg4ut0vobCthQdVl0ixMNQMgSa5cuMH6NhA
        +seX8pYZOdm0UlrhGI4kk6U=
X-Google-Smtp-Source: ABdhPJzTTFiIBLWplIkvQQIHb02ufaP5r+ilk5UhyIiCY+V1OTyhr4pdMDpLqnQLX+3XJ3uaYhkVxw==
X-Received: by 2002:a1c:40c:: with SMTP id 12mr2878668wme.158.1629452236945;
        Fri, 20 Aug 2021 02:37:16 -0700 (PDT)
Received: from localhost.localdomain ([85.255.233.190])
        by smtp.gmail.com with ESMTPSA id z7sm9693402wmi.4.2021.08.20.02.37.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Aug 2021 02:37:16 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: [PATCH 2/3] io_uring: place fixed tables under memcg limits
Date:   Fri, 20 Aug 2021 10:36:36 +0100
Message-Id: <b3ac9f5da9821bb59837b5fe25e8ef4be982218c.1629451684.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <cover.1629451684.git.asml.silence@gmail.com>
References: <cover.1629451684.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Fixed tables may be large enough, place all of them together with
allocated tags under memcg limits.

Cc: stable@vger.kernel.org
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index e6301d5d03a8..976fc0509e4b 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -7135,14 +7135,14 @@ static void **io_alloc_page_table(size_t size)
 	size_t init_size = size;
 	void **table;
 
-	table = kcalloc(nr_tables, sizeof(*table), GFP_KERNEL);
+	table = kcalloc(nr_tables, sizeof(*table), GFP_KERNEL_ACCOUNT);
 	if (!table)
 		return NULL;
 
 	for (i = 0; i < nr_tables; i++) {
 		unsigned int this_size = min_t(size_t, size, PAGE_SIZE);
 
-		table[i] = kzalloc(this_size, GFP_KERNEL);
+		table[i] = kzalloc(this_size, GFP_KERNEL_ACCOUNT);
 		if (!table[i]) {
 			io_free_page_table(table, init_size);
 			return NULL;
@@ -7333,7 +7333,8 @@ static int io_rsrc_data_alloc(struct io_ring_ctx *ctx, rsrc_put_fn *do_put,
 
 static bool io_alloc_file_tables(struct io_file_table *table, unsigned nr_files)
 {
-	table->files = kvcalloc(nr_files, sizeof(table->files[0]), GFP_KERNEL);
+	table->files = kvcalloc(nr_files, sizeof(table->files[0]),
+				GFP_KERNEL_ACCOUNT);
 	return !!table->files;
 }
 
-- 
2.32.0

