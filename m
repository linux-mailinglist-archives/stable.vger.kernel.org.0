Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70D9E1F2EDB
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 02:46:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731671AbgFIApo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jun 2020 20:45:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:58782 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728975AbgFHXLq (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jun 2020 19:11:46 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 661652151B;
        Mon,  8 Jun 2020 23:11:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591657906;
        bh=WoBvXvBT7w5MB1Ci7HGCPSvkE9k4I+qGx8ouhuGbpBE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KADOENpzi4cxP4t4Fq7cuHlZ+5+7c1TbQP4G88ziw1qCEC+1L9sJp2GKhvxGgdMQ2
         l4eA1wsaLnUV3WAsW4j5Cgcha+p0byqn6nqlFFaNd3Q6SH2HHJSuOmk5hNMC+a95ga
         jKtfn/peoNXyE3+wmbjOHOwWjB2T35S+OQRVoqO4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>,
        linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org
Subject: [PATCH AUTOSEL 5.7 258/274] io_uring: fix overflowed reqs cancellation
Date:   Mon,  8 Jun 2020 19:05:51 -0400
Message-Id: <20200608230607.3361041-258-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608230607.3361041-1-sashal@kernel.org>
References: <20200608230607.3361041-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Begunkov <asml.silence@gmail.com>

[ Upstream commit 7b53d59859bc932b37895d2d37388e7fa29af7a5 ]

Overflowed requests in io_uring_cancel_files() should be shed only of
inflight and overflowed refs. All other left references are owned by
someone else.

If refcount_sub_and_test() fails, it will go further and put put extra
ref, don't do that. Also, don't need to do io_wq_cancel_work()
for overflowed reqs, they will be let go shortly anyway.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/io_uring.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index dd90c3fcd4f5..4038ed0a5c39 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -7467,10 +7467,11 @@ static void io_uring_cancel_files(struct io_ring_ctx *ctx,
 				finish_wait(&ctx->inflight_wait, &wait);
 				continue;
 			}
+		} else {
+			io_wq_cancel_work(ctx->io_wq, &cancel_req->work);
+			io_put_req(cancel_req);
 		}
 
-		io_wq_cancel_work(ctx->io_wq, &cancel_req->work);
-		io_put_req(cancel_req);
 		schedule();
 		finish_wait(&ctx->inflight_wait, &wait);
 	}
-- 
2.25.1

