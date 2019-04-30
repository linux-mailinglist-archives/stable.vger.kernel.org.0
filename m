Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 65789F77E
	for <lists+stable@lfdr.de>; Tue, 30 Apr 2019 14:00:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727071AbfD3L7d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Apr 2019 07:59:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:59402 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728087AbfD3Lq2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 30 Apr 2019 07:46:28 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 31B6121744;
        Tue, 30 Apr 2019 11:46:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556624787;
        bh=TjLZqtyb6luG6jJUsMYn1zemKgi8FYvKfA9jey+XKrs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CyC28JYw1Fj9F+WnRFyEz6SS4vzNj+AhaKCrOABzuLHISegO/066Eu+qV8SunicRG
         vj4MOWZ+QKH9ybO6VFJTw42WIzLtJvx+K+ZojBzpHpBuxUQvfEtRby7qwmWDP32E7y
         hOwPq6KSjPH9fmgCyf5BjQf8Sw3Y5So1NbySJplg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Jens Axboe <axboe@kernel.dk>,
        Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 4.19 072/100] aio: abstract out io_event filler helper
Date:   Tue, 30 Apr 2019 13:38:41 +0200
Message-Id: <20190430113612.146110455@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190430113608.616903219@linuxfoundation.org>
References: <20190430113608.616903219@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jens Axboe <axboe@kernel.dk>

commit 875736bb3f3ded168469f6a14df7a938416a99d5 upstream.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Cc: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/aio.c |   14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

--- a/fs/aio.c
+++ b/fs/aio.c
@@ -1059,6 +1059,15 @@ static inline void iocb_put(struct aio_k
 	}
 }
 
+static void aio_fill_event(struct io_event *ev, struct aio_kiocb *iocb,
+			   long res, long res2)
+{
+	ev->obj = (u64)(unsigned long)iocb->ki_user_iocb;
+	ev->data = iocb->ki_user_data;
+	ev->res = res;
+	ev->res2 = res2;
+}
+
 /* aio_complete
  *	Called when the io request on the given iocb is complete.
  */
@@ -1086,10 +1095,7 @@ static void aio_complete(struct aio_kioc
 	ev_page = kmap_atomic(ctx->ring_pages[pos / AIO_EVENTS_PER_PAGE]);
 	event = ev_page + pos % AIO_EVENTS_PER_PAGE;
 
-	event->obj = (u64)(unsigned long)iocb->ki_user_iocb;
-	event->data = iocb->ki_user_data;
-	event->res = res;
-	event->res2 = res2;
+	aio_fill_event(event, iocb, res, res2);
 
 	kunmap_atomic(ev_page);
 	flush_dcache_page(ctx->ring_pages[pos / AIO_EVENTS_PER_PAGE]);


