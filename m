Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A14FAD9E94
	for <lists+stable@lfdr.de>; Thu, 17 Oct 2019 00:04:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438610AbfJPV7o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Oct 2019 17:59:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:54840 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2438607AbfJPV7n (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 16 Oct 2019 17:59:43 -0400
Received: from localhost (unknown [192.55.54.58])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 279B5222C2;
        Wed, 16 Oct 2019 21:59:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571263183;
        bh=OvHNm/qVCMS+oT5kxGIv21k4COUn0WEv4e0HUk1HUqc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oOgiPwEy9YzTNJ10iIIlPEhBlh1/Lp/i0i35TfJFHPpPm90JK1A02VGkkkphOdKYB
         lO58MjRAgfLUcLbo0KzSq4EM2o9mRHmk277EnrulmzADInvG8io26u44GDXJQTTn+n
         t+3YZyAQ26ekjcnx1rPByD4ST2EyKynXbb/yrDac=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stefan Hajnoczi <stefanha@redhat.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.3 110/112] io_uring: only flush workqueues on fileset removal
Date:   Wed, 16 Oct 2019 14:51:42 -0700
Message-Id: <20191016214907.445814511@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191016214844.038848564@linuxfoundation.org>
References: <20191016214844.038848564@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jens Axboe <axboe@kernel.dk>

commit 8a99734081775c012a4a6c442fdef0379fe52bdf upstream.

We should not remove the workqueue, we just need to ensure that the
workqueues are synced. The workqueues are torn down on ctx removal.

Cc: stable@vger.kernel.org
Fixes: 6b06314c47e1 ("io_uring: add file set registration")
Reported-by: Stefan Hajnoczi <stefanha@redhat.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/io_uring.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2566,7 +2566,8 @@ static void io_destruct_skb(struct sk_bu
 {
 	struct io_ring_ctx *ctx = skb->sk->sk_user_data;
 
-	io_finish_async(ctx);
+	if (ctx->sqo_wq)
+		flush_workqueue(ctx->sqo_wq);
 	unix_destruct_scm(skb);
 }
 


