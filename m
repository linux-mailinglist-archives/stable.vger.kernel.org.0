Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 585D42A167C
	for <lists+stable@lfdr.de>; Sat, 31 Oct 2020 12:46:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728343AbgJaLqE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 31 Oct 2020 07:46:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:47240 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728335AbgJaLqB (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 31 Oct 2020 07:46:01 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 07CCD2074F;
        Sat, 31 Oct 2020 11:46:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604144761;
        bh=mD/6nzptLuU1T7vST7dSm16Yk48MWkSFc6PueFYV63U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k+7W3eX8hwBicXayNZNmrtJSB3aeIvV69LzdStGQdV83w7sMu4/3QcnlWToQQlwq9
         Ly85zv3mkVhb8Em1IPaf6zUhELH33HyTneSdX/vGcMW3LXEQF6yI4uyX50EAB0/kdg
         vtT8olL2UJPgGB2B+iEu5WPeOfKf+w0rUIlvBLbA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.9 72/74] io_uring: dont reuse linked_timeout
Date:   Sat, 31 Oct 2020 12:36:54 +0100
Message-Id: <20201031113503.485405748@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201031113500.031279088@linuxfoundation.org>
References: <20201031113500.031279088@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Begunkov <asml.silence@gmail.com>

commit ff5771613cd7b3a76cd16cb54aa81d30d3c11d48 upstream.

Clear linked_timeout for next requests in __io_queue_sqe() so we won't
queue it up unnecessary when it's going to be punted.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Cc: stable@vger.kernel.org # v5.9
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/io_uring.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -6249,8 +6249,10 @@ err:
 	if (nxt) {
 		req = nxt;
 
-		if (req->flags & REQ_F_FORCE_ASYNC)
+		if (req->flags & REQ_F_FORCE_ASYNC) {
+			linked_timeout = NULL;
 			goto punt;
+		}
 		goto again;
 	}
 exit:


