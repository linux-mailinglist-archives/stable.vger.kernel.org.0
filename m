Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87A8543248C
	for <lists+stable@lfdr.de>; Mon, 18 Oct 2021 19:18:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232840AbhJRRUj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Oct 2021 13:20:39 -0400
Received: from smtp-relay-canonical-0.canonical.com ([185.125.188.120]:51070
        "EHLO smtp-relay-canonical-0.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232153AbhJRRUj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Oct 2021 13:20:39 -0400
Received: from ascalon (unknown [192.188.8.63])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by smtp-relay-canonical-0.canonical.com (Postfix) with ESMTPSA id 217884004F;
        Mon, 18 Oct 2021 17:18:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1634577506;
        bh=jdO2z6q9L58AVBBMM3jXNb/74k8IQBeYybcmjeCK7Gw=;
        h=From:To:Cc:Subject:Date:Message-Id;
        b=wPKdXlnWtroVp8iUZHBB9WhrsXLs71qCTPrVIwEROO4oK6wX28J/MJrcdPbwTEuBI
         lHiNz/vccPjkvK4yYf6vOTtku5IcUW5B+zgX/7gD/wFbOl5JNTaiNsPcHasAmjFMYd
         eP3/NoVXJBFNXOUXKyveiywcSvmzKTseRbDwUPlACPwdwmavgbGP9PY15x1WLNh2Je
         t64ID/uXjmbmCodkK7bBpWAFpuT1Vz2RU6r2HYz5zviOO1XwPVfi7ZNIA48IgS1OaE
         rArPNgqhx6rdw5evagxkcbcmT+l0Wv5eCsVNAoV7ng2AvSkT9AjGvvtLutLyKozukd
         5cS+mMXg3B6zg==
Received: from kamal by ascalon with local (Exim 4.90_1)
        (envelope-from <kamal@ascalon>)
        id 1mcWHH-0004ut-PP; Mon, 18 Oct 2021 10:18:23 -0700
From:   Kamal Mostafa <kamal@canonical.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Kamal Mostafa <kamal@canonical.com>, stable@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] [linux-5.10.y] io_uring: fix splice_fd_in checks backport typo
Date:   Mon, 18 Oct 2021 10:18:08 -0700
Message-Id: <20211018171808.18383-1-kamal@canonical.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The linux-5.10.y backport of commit "io_uring: add ->splice_fd_in checks"
includes a typo: "|" where "||" should be. (The original upstream commit
is fine.)

Fixes: 54eb6211b979 ("io_uring: add ->splice_fd_in checks")
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org # v5.10
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 fs/io_uring.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 26753d0cb431..0736487165da 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -5559,7 +5559,7 @@ static int io_timeout_remove_prep(struct io_kiocb *req,
 		return -EINVAL;
 	if (unlikely(req->flags & (REQ_F_FIXED_FILE | REQ_F_BUFFER_SELECT)))
 		return -EINVAL;
-	if (sqe->ioprio || sqe->buf_index || sqe->len || sqe->timeout_flags |
+	if (sqe->ioprio || sqe->buf_index || sqe->len || sqe->timeout_flags ||
 	    sqe->splice_fd_in)
 		return -EINVAL;
 
-- 
2.17.1

