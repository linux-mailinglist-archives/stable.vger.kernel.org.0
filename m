Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFC2D1AC776
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 16:55:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729215AbgDPOza (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Apr 2020 10:55:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:43570 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2441792AbgDPN4b (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Apr 2020 09:56:31 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A0E002078B;
        Thu, 16 Apr 2020 13:56:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587045391;
        bh=u0Quab+B5xAY1WdEbEgSNg29A46PeZKLIIvqfGttVbQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NKjtalq5KxvW+QqI/ovkajGY2gk0GNawie+XW/tVBhReSLtC7ZU6OP9oa1zP9am3X
         Vz+bmHcMdbIQhQRzScXdvPX3nepb6t4CvefUa0F146IdUzANx+3XY9ddL9knIYtVj5
         GI2dAB/QDxSRCW4gjT8aI4ypop3OZq/ykAf80S60=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Subject: [PATCH 5.6 115/254] io_uring: ensure openat sets O_LARGEFILE if needed
Date:   Thu, 16 Apr 2020 15:23:24 +0200
Message-Id: <20200416131340.594170498@linuxfoundation.org>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200416131325.804095985@linuxfoundation.org>
References: <20200416131325.804095985@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jens Axboe <axboe@kernel.dk>

commit 08a1d26eb894a9dcf79f674558a284ad1ffef517 upstream.

OPENAT2 correctly sets O_LARGEFILE if it has to, but that escaped the
OPENAT opcode. Dmitry reports that his test case that compares openat()
and IORING_OP_OPENAT sees failures on large files:

---
 fs/io_uring.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2571,6 +2571,8 @@ static int io_openat_prep(struct io_kioc
 	req->open.how.mode = READ_ONCE(sqe->len);
 	fname = u64_to_user_ptr(READ_ONCE(sqe->addr));
 	req->open.how.flags = READ_ONCE(sqe->open_flags);
+	if (force_o_largefile())
+		req->open.how.flags |= O_LARGEFILE;
 
 	req->open.filename = getname(fname);
 	if (IS_ERR(req->open.filename)) {


