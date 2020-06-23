Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B19E720633E
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 23:29:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389897AbgFWUTz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 16:19:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:37060 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389846AbgFWUTx (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:19:53 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 90C6A2137B;
        Tue, 23 Jun 2020 20:19:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592943593;
        bh=KX2KE0eq4kdHa4OyjcpkBU4QThGAn1ZSwGEXpYkTh50=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iWpcISqWEWjJEIwsoRTd/ZxYBonM8H6OAIjXsiSG9s/Uvd+9qFKLYT3elHw7UlqBV
         0KhyiehQ9Cuwy4KuqNulSs5kzebNy0D9sO9ViV86jb4Ev4OFh6DbEMeUV184/cSmKX
         QOnsrCvMshbWOhy4pGNsNKgZ8kZFvWcBCSW0bmZg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.7 435/477] io_uring: fix possible race condition against REQ_F_NEED_CLEANUP
Date:   Tue, 23 Jun 2020 21:57:12 +0200
Message-Id: <20200623195428.091945669@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623195407.572062007@linuxfoundation.org>
References: <20200623195407.572062007@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>

[ Upstream commit 6f2cc1664db20676069cff27a461ccc97dbfd114 ]

In io_read() or io_write(), when io request is submitted successfully,
it'll go through the below sequence:

    kfree(iovec);
    req->flags &= ~REQ_F_NEED_CLEANUP;
    return ret;

But clearing REQ_F_NEED_CLEANUP might be unsafe. The io request may
already have been completed, and then io_complete_rw_iopoll()
and io_complete_rw() will be called, both of which will also modify
req->flags if needed. This causes a race condition, with concurrent
non-atomic modification of req->flags.

To eliminate this race, in io_read() or io_write(), if io request is
submitted successfully, we don't remove REQ_F_NEED_CLEANUP flag. If
REQ_F_NEED_CLEANUP is set, we'll leave __io_req_aux_free() to the
iovec cleanup work correspondingly.

Cc: stable@vger.kernel.org
Signed-off-by: Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/io_uring.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2614,8 +2614,8 @@ copy_iov:
 		}
 	}
 out_free:
-	kfree(iovec);
-	req->flags &= ~REQ_F_NEED_CLEANUP;
+	if (!(req->flags & REQ_F_NEED_CLEANUP))
+		kfree(iovec);
 	return ret;
 }
 
@@ -2737,8 +2737,8 @@ copy_iov:
 		}
 	}
 out_free:
-	req->flags &= ~REQ_F_NEED_CLEANUP;
-	kfree(iovec);
+	if (!(req->flags & REQ_F_NEED_CLEANUP))
+		kfree(iovec);
 	return ret;
 }
 


