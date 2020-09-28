Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35FA627B0FC
	for <lists+stable@lfdr.de>; Mon, 28 Sep 2020 17:35:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726281AbgI1PfO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Sep 2020 11:35:14 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:29483 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726310AbgI1PfO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Sep 2020 11:35:14 -0400
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601307313;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=J3rzuo7zJOX22NydR7GLnnKTFuPemymtgB85z2Njrr4=;
        b=gQX4V3cdmoEZdNT7WGVWu4ohzKIb7b3ZZr2mm7lP75Yac6TQE3Y3xwfRiOXJALgOl8uBeZ
        inseLicBKn5s2Y0+vQAyoLMYZo6y0Z1M3yKvq7Ua1ZbignrxZa4ILeocCAb2HcFeMN/HGe
        lY9NM17PJxqJ0Aw5W4lbMil0kxPkXT0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-432-S4PyOOrsOHG02MB5Ru_B0Q-1; Mon, 28 Sep 2020 11:35:11 -0400
X-MC-Unique: S4PyOOrsOHG02MB5Ru_B0Q-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B42281084D76;
        Mon, 28 Sep 2020 15:35:09 +0000 (UTC)
Received: from steredhat.redhat.com (ovpn-115-63.ams2.redhat.com [10.36.115.63])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 48E2E78482;
        Mon, 28 Sep 2020 15:35:08 +0000 (UTC)
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     stable@vger.kernel.org
Cc:     gregkh@linuxfoundation.org, io-uring@vger.kernel.org,
        axboe@kernel.dk
Subject: [PATCH 5.8] io_uring: ensure open/openat2 name is cleaned on cancelation
Date:   Mon, 28 Sep 2020 17:35:07 +0200
Message-Id: <20200928153507.27420-1-sgarzare@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jens Axboe <axboe@kernel.dk>

[ Upstream commit f3cd4850504ff612d0ea77a0aaf29b66c98fcefe ]

If we cancel these requests, we'll leak the memory associated with the
filename. Add them to the table of ops that need cleaning, if
REQ_F_NEED_CLEANUP is set.

Cc: stable@vger.kernel.org
Fixes: e62753e4e292 ("io_uring: call statx directly")
Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
---
 fs/io_uring.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index d05023ca74bd..864341445926 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -5252,6 +5252,8 @@ static void io_cleanup_req(struct io_kiocb *req)
 		break;
 	case IORING_OP_OPENAT:
 	case IORING_OP_OPENAT2:
+		if (req->open.filename)
+			putname(req->open.filename);
 		break;
 	case IORING_OP_SPLICE:
 	case IORING_OP_TEE:
-- 
2.26.2

