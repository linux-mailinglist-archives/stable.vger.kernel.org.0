Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDA0040DEFB
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 18:04:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240571AbhIPQFj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 12:05:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:44820 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240526AbhIPQFi (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 12:05:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6E55C60232;
        Thu, 16 Sep 2021 16:04:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631808258;
        bh=/+BMLR1DXqh2+9fiEC9j3lrs11ArkH2giEOVDgoY2rk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WZ1LnO+ScWoW40+GFc++2Bb9sW8ZrP1dCeRvOyXnoBxxLLAXwoHnPv7F3RxdviuL/
         pLlfZZ+UhoRkzfChChCrxrXZ304y/Ml4ah12SPU+4TDsrxhUwIgJFwmI2XjeGsmFpa
         /nGboSy57sH2ns0JzUrtc0xIrLMTf8qDGn0Z1wAs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH 5.10 002/306] io_uring: limit fixed table size by RLIMIT_NOFILE
Date:   Thu, 16 Sep 2021 17:55:47 +0200
Message-Id: <20210916155753.989906303@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155753.903069397@linuxfoundation.org>
References: <20210916155753.903069397@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Begunkov <asml.silence@gmail.com>

Limit the number of files in io_uring fixed tables by RLIMIT_NOFILE,
that's the first and the simpliest restriction that we should impose.

Cc: stable@vger.kernel.org
Suggested-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/b2756c340aed7d6c0b302c26dab50c6c5907f4ce.1629451684.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/io_uring.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -7579,6 +7579,8 @@ static int io_sqe_files_register(struct
 		return -EINVAL;
 	if (nr_args > IORING_MAX_FIXED_FILES)
 		return -EMFILE;
+	if (nr_args > rlimit(RLIMIT_NOFILE))
+		return -EMFILE;
 
 	file_data = kzalloc(sizeof(*ctx->file_data), GFP_KERNEL);
 	if (!file_data)


