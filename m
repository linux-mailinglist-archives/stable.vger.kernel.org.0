Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8849A1FB764
	for <lists+stable@lfdr.de>; Tue, 16 Jun 2020 17:47:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731186AbgFPPpn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Jun 2020 11:45:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:37164 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731142AbgFPPpm (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Jun 2020 11:45:42 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D4C2D20C09;
        Tue, 16 Jun 2020 15:45:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592322342;
        bh=rm1bzAXLBXkymLfucPHjI52gwCHPLfYj8Fb3tWjdOxM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E9bh1UZ1DdFkq3JHLGmOfhZaWTV4H5EmkRg4zZrldxUEYIeFz0bTTD06v3zcdZlOC
         s80tACP+KOopFOQT1dBbFoslhL3jvcrU4mQIuGEI0I+Cwr0518qnEgdauim64i+gxn
         VQRNwAD2YOl1nRcupdR2un03rXYCnDknML9i7508=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.7 054/163] io_uring: re-set iov base/len for buffer select retry
Date:   Tue, 16 Jun 2020 17:33:48 +0200
Message-Id: <20200616153109.432071451@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200616153106.849127260@linuxfoundation.org>
References: <20200616153106.849127260@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jens Axboe <axboe@kernel.dk>

commit dddb3e26f6d88c5344d28cb5ff9d3d6fa05c4f7a upstream.

We already have the buffer selected, but we should set the iter list
again.

Cc: stable@vger.kernel.org # v5.7
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/io_uring.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2333,8 +2333,14 @@ static ssize_t __io_iov_buffer_select(st
 static ssize_t io_iov_buffer_select(struct io_kiocb *req, struct iovec *iov,
 				    bool needs_lock)
 {
-	if (req->flags & REQ_F_BUFFER_SELECTED)
+	if (req->flags & REQ_F_BUFFER_SELECTED) {
+		struct io_buffer *kbuf;
+
+		kbuf = (struct io_buffer *) (unsigned long) req->rw.addr;
+		iov[0].iov_base = u64_to_user_ptr(kbuf->addr);
+		iov[0].iov_len = kbuf->len;
 		return 0;
+	}
 	if (!req->rw.len)
 		return 0;
 	else if (req->rw.len > 1)


