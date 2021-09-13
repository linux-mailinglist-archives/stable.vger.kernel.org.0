Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F5B840935A
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 16:20:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244951AbhIMOU7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 10:20:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:37132 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344328AbhIMORN (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 10:17:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4A14261B00;
        Mon, 13 Sep 2021 13:45:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631540703;
        bh=bmPJBKw+Wtb+O4NmkL6qHAe26ifXnHe5UboCJlAslCw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sLCdx90YK2OfdCjTAtsqW7gAgBatwblgNQ6cXNAk4Xzw0HZ5ne3/mP1doZVRLdlF/
         Mq/aYPHd9ckh0VxSFRB9vt3BANiw2R+GrlH6OiIKBydlrSqBfUKUi3nsOFQxbd5ZCz
         beRCAMdw5rhD4D63qZCRXf9irAnbG9spmIdfpkGE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH 5.13 269/300] io_uring: limit fixed table size by RLIMIT_NOFILE
Date:   Mon, 13 Sep 2021 15:15:30 +0200
Message-Id: <20210913131118.429088901@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131109.253835823@linuxfoundation.org>
References: <20210913131109.253835823@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Begunkov <asml.silence@gmail.com>

commit 3a1b8a4e843f96b636431450d8d79061605cf74b upstream.

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
@@ -7669,6 +7669,8 @@ static int io_sqe_files_register(struct
 		return -EINVAL;
 	if (nr_args > IORING_MAX_FIXED_FILES)
 		return -EMFILE;
+	if (nr_args > rlimit(RLIMIT_NOFILE))
+		return -EMFILE;
 	ret = io_rsrc_node_switch_start(ctx);
 	if (ret)
 		return ret;


