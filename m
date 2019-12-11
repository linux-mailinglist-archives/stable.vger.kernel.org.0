Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B4E7311B5F3
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 16:57:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731237AbfLKP5p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 10:57:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:40694 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731690AbfLKPO6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 10:14:58 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7242220663;
        Wed, 11 Dec 2019 15:14:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576077297;
        bh=EhvTr/MTOlFXNS/W68gn6gejFmcu49STTLixKu3GOpY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hbgHV+sXo2m53rHUdQ9zpJdYPMOctTFB1BaxCDDV7pfNwEaASAfcY+gXCvCqcSsud
         Z1+mnmnHyy/xb6bpLhieQJlsHjC4drCh9cDu0zQfjWMvjUcM8rlVqg0WvT9RspOs/q
         lBBA/nIuNljKFF+l7tVlj/DjR9hX8sk5t3Wa/Dig=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.3 044/105] io_uring: transform send/recvmsg() -ERESTARTSYS to -EINTR
Date:   Wed, 11 Dec 2019 16:05:33 +0100
Message-Id: <20191211150238.516607407@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191211150221.153659747@linuxfoundation.org>
References: <20191211150221.153659747@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jens Axboe <axboe@kernel.dk>

commit 441cdbd5449b4923cd413d3ba748124f91388be9 upstream.

We should never return -ERESTARTSYS to userspace, transform it into
-EINTR.

Cc: stable@vger.kernel.org # v5.3+
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/io_uring.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1535,6 +1535,8 @@ static int io_send_recvmsg(struct io_kio
 		ret = fn(sock, msg, flags);
 		if (force_nonblock && ret == -EAGAIN)
 			return ret;
+		if (ret == -ERESTARTSYS)
+			ret = -EINTR;
 	}
 
 	io_cqring_add_event(req->ctx, sqe->user_data, ret);


