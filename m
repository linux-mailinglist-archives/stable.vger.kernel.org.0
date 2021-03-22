Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B98B34434D
	for <lists+stable@lfdr.de>; Mon, 22 Mar 2021 13:52:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231469AbhCVMtd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Mar 2021 08:49:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:35346 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232310AbhCVMmM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Mar 2021 08:42:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 341D5619CC;
        Mon, 22 Mar 2021 12:39:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616416791;
        bh=WwQCH5+fOgSh3lPnUj1VIZVKF9X8El3gXDN/q2/vJ+8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jd/+w5heZmnyADHLNuPcDXCQMTaAccX6KZy7/5iYjNW8SF6Qmq2nheJzJdp1ayZ8s
         4NtUhlrOp70EkQ2wI9bFDbxEiIVLki58BzOHaa+KXJsuhZaLV8sZliIirmXwn/xE3O
         XOMaZ0LrqRI0TLmNnWmL5TEHJOZvb9EDbobNTuQs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 106/157] io_uring: clear IOCB_WAITQ for non -EIOCBQUEUED return
Date:   Mon, 22 Mar 2021 13:27:43 +0100
Message-Id: <20210322121937.129579242@linuxfoundation.org>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210322121933.746237845@linuxfoundation.org>
References: <20210322121933.746237845@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jens Axboe <axboe@kernel.dk>

[ Upstream commit b5b0ecb736f1ce1e68eb50613c0cfecff10198eb ]

The callback can only be armed, if we get -EIOCBQUEUED returned. It's
important that we clear the WAITQ bit for other cases, otherwise we can
queue for async retry and filemap will assume that we're armed and
return -EAGAIN instead of just blocking for the IO.

Cc: stable@vger.kernel.org # 5.9+
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/io_uring.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 7625b3e2db2c..06e9c2181995 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -3501,6 +3501,7 @@ static int io_read(struct io_kiocb *req, bool force_nonblock,
 		goto out_free;
 	} else if (ret > 0 && ret < io_size) {
 		/* we got some bytes, but not all. retry. */
+		kiocb->ki_flags &= ~IOCB_WAITQ;
 		goto retry;
 	}
 done:
-- 
2.30.1



