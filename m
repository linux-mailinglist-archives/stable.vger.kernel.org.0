Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7FA37796D6
	for <lists+stable@lfdr.de>; Mon, 29 Jul 2019 21:56:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404249AbfG2Tzz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jul 2019 15:55:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:48694 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404251AbfG2Tzu (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jul 2019 15:55:50 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C726921655;
        Mon, 29 Jul 2019 19:55:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564430150;
        bh=+/rm5CDoZsI6YgQXhHNsuleyRNVQTh7kw9Su+PBQ8xA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oRdSGXb0vuQme68/BcsC9XCaGMNFNpw40XeP0c8SLGVKmFeohDLuDnLJ4B829hccx
         eQY3Ge4ix5ledr6KeJFVYJwVujUIZTylfO2RiMYJs+ijL7Nyc9tUmOLXDFgvIhD9m5
         UgI5QNy9/fOA7K0ZwMELomJKqkx1kUIoyryHLBmY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Kozak <kozzi11@gmail.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.2 213/215] io_uring: ensure ->list is initialized for poll commands
Date:   Mon, 29 Jul 2019 21:23:29 +0200
Message-Id: <20190729190816.805465347@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190729190739.971253303@linuxfoundation.org>
References: <20190729190739.971253303@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jens Axboe <axboe@kernel.dk>

commit 36703247d5f52a679df9da51192b6950fe81689f upstream.

Daniel reports that when testing an http server that uses io_uring
to poll for incoming connections, sometimes it hard crashes. This is
due to an uninitialized list member for the io_uring request. Normally
this doesn't trigger and none of the test cases caught it.

Reported-by: Daniel Kozak <kozzi11@gmail.com>
Tested-by: Daniel Kozak <kozzi11@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/io_uring.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1489,6 +1489,8 @@ static int io_poll_add(struct io_kiocb *
 	INIT_LIST_HEAD(&poll->wait.entry);
 	init_waitqueue_func_entry(&poll->wait, io_poll_wake);
 
+	INIT_LIST_HEAD(&req->list);
+
 	mask = vfs_poll(poll->file, &ipt.pt) & poll->events;
 
 	spin_lock_irq(&ctx->completion_lock);


