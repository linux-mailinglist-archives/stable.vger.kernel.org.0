Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8747D452180
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 02:02:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245721AbhKPBFD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 20:05:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:44598 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245528AbhKOTUm (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:20:42 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 18B756326C;
        Mon, 15 Nov 2021 18:36:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637001376;
        bh=xU5mAr2fSHAmtuHJDMQz3frIcUuBU7jc4nnLNWWtpXo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WYK6OhPA+3QNVdgyT0Za1jdREwXOlfVfjpdi3zLXXU9lZ6Ua0htCd9FyHkr75HeWf
         KHCCo6eN4O2bakzIEHQ4QhP3OMHBK1Z0gs1lDQzm+jsU5N40kuT8h3chvHJNoZeif9
         849IawN44FXgdI00euAcEjw9vOM+uMoTUkvf+5Yo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Beld Zhang <beldzhang@gmail.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>, stable@kernel.org
Subject: [PATCH 5.15 133/917] io_uring: honour zeroes as io-wq worker limits
Date:   Mon, 15 Nov 2021 17:53:48 +0100
Message-Id: <20211115165433.281797198@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Begunkov <asml.silence@gmail.com>

commit bad119b9a00019054f0c9e2045f312ed63ace4f4 upstream.

When we pass in zero as an io-wq worker number limit it shouldn't
actually change the limits but return the old value, follow that
behaviour with deferred limits setup as well.

Cc: stable@kernel.org # 5.15
Reported-by: Beld Zhang <beldzhang@gmail.com>
Fixes: e139a1ec92f8d ("io_uring: apply max_workers limit to all future users")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/1b222a92f7a78a24b042763805e891a4cdd4b544.1636384034.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/io_uring.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -10684,7 +10684,9 @@ static int io_register_iowq_max_workers(
 
 	BUILD_BUG_ON(sizeof(new_count) != sizeof(ctx->iowq_limits));
 
-	memcpy(ctx->iowq_limits, new_count, sizeof(new_count));
+	for (i = 0; i < ARRAY_SIZE(new_count); i++)
+		if (new_count[i])
+			ctx->iowq_limits[i] = new_count[i];
 	ctx->iowq_limits_set = true;
 
 	ret = -EINVAL;


