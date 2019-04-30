Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CB114F654
	for <lists+stable@lfdr.de>; Tue, 30 Apr 2019 13:46:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729412AbfD3LqN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Apr 2019 07:46:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:58948 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730516AbfD3LqM (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 30 Apr 2019 07:46:12 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5397D2173E;
        Tue, 30 Apr 2019 11:46:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556624771;
        bh=Bk1OXFfBQ8nFn9DBuyA7O+lCPWPwyZ/9BBvNMa9vLfc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kXmm/JGrBftNYLi5SrvO6riXdo26U9H4y7cerdjQoZWzt4yLkDBaEAyD8k2eRhpVc
         dIc4ZJxp5jEd0j9giY4qY1vL/rUNXmsh0qskwPayX6ZeNjV7fYkaRc8dESeHZ3sSdi
         1LDkBbshnZvbtCArnfLdprkBnEpDpOFTLpEp2/2E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Johannes Thumshirn <jthumshirn@suse.de>,
        Jens Axboe <axboe@kernel.dk>,
        Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 4.19 066/100] aio: clear IOCB_HIPRI
Date:   Tue, 30 Apr 2019 13:38:35 +0200
Message-Id: <20190430113611.914864134@linuxfoundation.org>
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

From: Christoph Hellwig <hch@lst.de>

commit 154989e45fd8de9bfb52bbd6e5ea763e437e54c5 upstream.

No one is going to poll for aio (yet), so we must clear the HIPRI
flag, as we would otherwise send it down the poll queues, where no
one will be polling for completions.

Signed-off-by: Christoph Hellwig <hch@lst.de>

IOCB_HIPRI, not RWF_HIPRI.

Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Cc: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/aio.c |   11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

--- a/fs/aio.c
+++ b/fs/aio.c
@@ -1438,8 +1438,7 @@ static int aio_prep_rw(struct kiocb *req
 		ret = ioprio_check_cap(iocb->aio_reqprio);
 		if (ret) {
 			pr_debug("aio ioprio check cap error: %d\n", ret);
-			fput(req->ki_filp);
-			return ret;
+			goto out_fput;
 		}
 
 		req->ki_ioprio = iocb->aio_reqprio;
@@ -1448,7 +1447,13 @@ static int aio_prep_rw(struct kiocb *req
 
 	ret = kiocb_set_rw_flags(req, iocb->aio_rw_flags);
 	if (unlikely(ret))
-		fput(req->ki_filp);
+		goto out_fput;
+
+	req->ki_flags &= ~IOCB_HIPRI; /* no one is going to poll for this I/O */
+	return 0;
+
+out_fput:
+	fput(req->ki_filp);
 	return ret;
 }
 


