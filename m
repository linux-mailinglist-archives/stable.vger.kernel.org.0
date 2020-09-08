Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 698FC261965
	for <lists+stable@lfdr.de>; Tue,  8 Sep 2020 20:14:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731350AbgIHSNT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Sep 2020 14:13:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:55024 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731493AbgIHQLn (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Sep 2020 12:11:43 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 80AD6246EC;
        Tue,  8 Sep 2020 15:40:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599579621;
        bh=gVkXlkXGnQRzeHEPbiG2lQR9d75wa/E9segbzyriEcc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jUKUGGcOmvmrDdwLSNGnR2fptv9Cwr/kjLe1e1lPk4F3sMUc6cNc+VtrMCOrg24+A
         Bi/WwrWV4+fuiS5vQxcWG08XJwV3OO0tLFXBTaHP9XOF3mvY/Qbmtkhb5KE/+EgNJ1
         HNHA51zhki6luIaULy//2L1nKvCqXgU5d5aXXfDU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiufei Xue <jiufei.xue@linux.alibaba.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.8 154/186] io_uring: set table->files[i] to NULL when io_sqe_file_register failed
Date:   Tue,  8 Sep 2020 17:24:56 +0200
Message-Id: <20200908152249.125166275@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200908152241.646390211@linuxfoundation.org>
References: <20200908152241.646390211@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jiufei Xue <jiufei.xue@linux.alibaba.com>

commit 95d1c8e5f801e959a89181a2548a3efa60a1a6ce upstream.

While io_sqe_file_register() failed in __io_sqe_files_update(),
table->files[i] still point to the original file which may freed
soon, and that will trigger use-after-free problems.

Cc: stable@vger.kernel.org
Fixes: f3bd9dae3708 ("io_uring: fix memleak in __io_sqe_files_update()")
Signed-off-by: Jiufei Xue <jiufei.xue@linux.alibaba.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/io_uring.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -6957,6 +6957,7 @@ static int __io_sqe_files_update(struct
 			table->files[index] = file;
 			err = io_sqe_file_register(ctx, file, i);
 			if (err) {
+				table->files[index] = NULL;
 				fput(file);
 				break;
 			}


