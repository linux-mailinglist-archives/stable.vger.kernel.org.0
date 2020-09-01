Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B66532594FD
	for <lists+stable@lfdr.de>; Tue,  1 Sep 2020 17:45:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728142AbgIAPpY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Sep 2020 11:45:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:33464 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731480AbgIAPpS (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Sep 2020 11:45:18 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 70C28206FA;
        Tue,  1 Sep 2020 15:45:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598975117;
        bh=AC80ehk6MWnB6KDYF3opTQgFibhyfg/7C7NTDOOw+IM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1bDjcCZJF7cijzu+axAS0D9uTO1xk1pq4jCzdNbLX58kNl+sk0evyuByTDanyIODI
         48Y9QuZ1IVGXK7IbqdRuXyBR8tqV15rx8gE87O+IBjqJcc+XNC1B32zceS0nA88Lis
         76KPmqK/R15ywjHA37DUipCI1s3+3CXuz1pEa9Ek=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andres Freund <andres@anarazel.de>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.8 186/255] io_uring: clear req->result on IOPOLL re-issue
Date:   Tue,  1 Sep 2020 17:10:42 +0200
Message-Id: <20200901151009.598705719@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200901151000.800754757@linuxfoundation.org>
References: <20200901151000.800754757@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jens Axboe <axboe@kernel.dk>

commit 56450c20fe10d4d93f58019109aa4e06fc0b9206 upstream.

Make sure we clear req->result, which was set to -EAGAIN for retry
purposes, when moving it to the reissue list. Otherwise we can end up
retrying a request more than once, which leads to weird results in
the io-wq handling (and other spots).

Cc: stable@vger.kernel.org
Reported-by: Andres Freund <andres@anarazel.de>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/io_uring.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1810,6 +1810,7 @@ static void io_iopoll_complete(struct io
 
 		req = list_first_entry(done, struct io_kiocb, list);
 		if (READ_ONCE(req->result) == -EAGAIN) {
+			req->result = 0;
 			req->iopoll_completed = 0;
 			list_move_tail(&req->list, &again);
 			continue;


