Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0164527C6E7
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 13:50:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731096AbgI2Ltt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 07:49:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:52740 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731172AbgI2LtY (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:49:24 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4E8192074A;
        Tue, 29 Sep 2020 11:49:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601380163;
        bh=q6YPtV+ymuFY43NbnYVC9BnvV/+ZvOi3H1FD6hb9BW4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kjoIN2BL2fObzKXGjI9DQOfNbPd/DH+x6V292+HocOTiUk+pikXS4Dz7E7ZgjbZzz
         gz9gepyHYqWYmmxrhcA06ggmx2tleqBDhdZq2AWXAuYCUKm2ERVtMm5iD0iW8Ugk3Z
         JjYT9mTpCSgHcbKxpbANyGotfnFOErg5RWzSVYDc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Stefano Garzarella <sgarzare@redhat.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.8 96/99] io_uring: ensure open/openat2 name is cleaned on cancelation
Date:   Tue, 29 Sep 2020 13:02:19 +0200
Message-Id: <20200929105934.476208525@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929105929.719230296@linuxfoundation.org>
References: <20200929105929.719230296@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jens Axboe <axboe@kernel.dk>

commit f3cd4850504ff612d0ea77a0aaf29b66c98fcefe upstream.

If we cancel these requests, we'll leak the memory associated with the
filename. Add them to the table of ops that need cleaning, if
REQ_F_NEED_CLEANUP is set.

Cc: stable@vger.kernel.org
Fixes: e62753e4e292 ("io_uring: call statx directly")
Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/io_uring.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -5254,6 +5254,8 @@ static void io_cleanup_req(struct io_kio
 		break;
 	case IORING_OP_OPENAT:
 	case IORING_OP_OPENAT2:
+		if (req->open.filename)
+			putname(req->open.filename);
 		break;
 	case IORING_OP_SPLICE:
 	case IORING_OP_TEE:


