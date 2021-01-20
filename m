Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80EFA2FDDF9
	for <lists+stable@lfdr.de>; Thu, 21 Jan 2021 01:32:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726486AbhAUAbk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 Jan 2021 19:31:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2403883AbhATXVJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 20 Jan 2021 18:21:09 -0500
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 868A5C061347;
        Wed, 20 Jan 2021 15:12:47 -0800 (PST)
Received: by mail-wr1-x42e.google.com with SMTP id g10so4515wrx.1;
        Wed, 20 Jan 2021 15:12:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Qvxaj2/pJYcXMJSCP4MPVUdjTsIP/8lOAePbupHi0no=;
        b=eX8zkuJ9odFztIVChIqTrlcR5BMK1a4Wn/vyt4VbJAo6/UQUBR+vXc+FD95aRDJIt7
         lqqQ590hS0Q6OQXI8h0YJt/7FmPgQcZWfUGVntbCiBfpk9RlablAQMpiA0YKtZWQaJIV
         26aKjfy1/x6F7kXczGBKHHUoaXv9keA4NaX/FUKHY8qArfzLRebHq4FBmsb/PZMb4PL/
         9uBhLg9LF2WBWlA+lnLWQKMZTQ3DVMZXXUHQHqWvQfQKG4Fmxcqzpk+dMyXQO4qg7y0y
         2/b+0OUows/UksUcdjCCV0kYX+/7WUJBrBs4ixUPiJLW1VMvtHFTzJrkhkPwEZG6wSwT
         0X7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Qvxaj2/pJYcXMJSCP4MPVUdjTsIP/8lOAePbupHi0no=;
        b=E4vzzr3Qy6OEuv7nerkSsBMhVMdl41RlNbgVwfUJTKbrQRxm92VzPQKgWp3zXnW6Su
         9PmrHQ6Oo6i410e9gTcpgh6ObO8lF0sCzwXqxVilkjvIUVPqq2d+Fbo6eDX4Hwyul/fh
         VK/cAuhJTFpRAPwbLoYY7vkpl51Cfr8i7rLRfaXHFYwuRsOktOCnrw3/YejuYLYMN34a
         X4IRZUhpxttZTwNO1qWmoqLBhh3pZr3WgV1XBkHkrSs4yQHa1R/D6p2J9pIvnPYRcfp1
         sES0j3wuoNRdk26DU0f0BAZf1cF0oOOqi/+qaqxNYT8ocDgPZxiYrasPiIPc2CMGLiRu
         UIeA==
X-Gm-Message-State: AOAM533+1TvBLpF3Hi/KpRRxRV7BP+95BZ7lI7kwcWGQRPujoWprB3po
        zmf5UDrNZCFY7tUCD6gQMSNZh3h0qdo=
X-Google-Smtp-Source: ABdhPJyHJCSiEy7yQKk9a61H38+xXTCwVpzu4zuRcLRIyvRrWUv9DkQBZP1yhgqlVZ/yBTM/jtzrzQ==
X-Received: by 2002:adf:dc8b:: with SMTP id r11mr11647055wrj.131.1611184366284;
        Wed, 20 Jan 2021 15:12:46 -0800 (PST)
Received: from localhost.localdomain ([148.252.129.228])
        by smtp.gmail.com with ESMTPSA id o8sm6598794wrm.17.2021.01.20.15.12.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Jan 2021 15:12:45 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: [PATCH 1/1] io_uring: fix short read retries for non-reg files
Date:   Wed, 20 Jan 2021 23:09:02 +0000
Message-Id: <096d4c7e2615704c08786fe793e91ad8b22cb9f9.1611184076.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Sockets and other non-regular files may actually expect short reads to
happen, don't retry reads for them.

Cc: stable@vger.kernel.org # 5.9+
Suggested-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 5f6f1e48954e..544d711b2ef0 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -3557,6 +3557,9 @@ static int io_read(struct io_kiocb *req, bool force_nonblock,
 
 	io_size -= ret;
 copy_iov:
+	if (!(req->flags & REQ_F_ISREG) && ret > 0)
+		goto done;
+
 	ret2 = io_setup_async_rw(req, iovec, inline_vecs, iter, true);
 	if (ret2) {
 		ret = ret2;
-- 
2.24.0

