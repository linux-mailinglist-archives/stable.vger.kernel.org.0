Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 224B0101319
	for <lists+stable@lfdr.de>; Tue, 19 Nov 2019 06:22:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727706AbfKSFWS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Nov 2019 00:22:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:37586 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727675AbfKSFWR (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 Nov 2019 00:22:17 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A4C0E22323;
        Tue, 19 Nov 2019 05:22:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574140937;
        bh=S5eJfKHSm1xAh4NNV73pGbv3I4IsrbCJ7CI0SMopVxI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Kzw5TLJD8ZNk7+lRTZbmFeORD9QUNoQSBDlAWjG4ryaSNyJlk5xU5ramgCFyqrAaX
         ZkZvNmwWuwL5xIMrB+7C4vuUoE8cP8AWRYjseUWVbEDQt/7vr5lf594J9+sPpjZrpx
         00FhbsoH+pA5nwJzo/GbFX1rNJe+zADgj3X2Fpxo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?=E6=9D=8E=E9=80=9A=E6=B4=B2?= <carter.li@eoitek.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.3 36/48] io_uring: ensure registered buffer import returns the IO length
Date:   Tue, 19 Nov 2019 06:19:56 +0100
Message-Id: <20191119051017.332195542@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191119050946.745015350@linuxfoundation.org>
References: <20191119050946.745015350@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jens Axboe <axboe@kernel.dk>

commit 5e559561a8d7e6d4adfce6aa8fbf3daa3dec1577 upstream.

A test case was reported where two linked reads with registered buffers
failed the second link always. This is because we set the expected value
of a request in req->result, and if we don't get this result, then we
fail the dependent links. For some reason the registered buffer import
returned -ERROR/0, while the normal import returns -ERROR/length. This
broke linked commands with registered buffers.

Fix this by making io_import_fixed() correctly return the mapped length.

Cc: stable@vger.kernel.org # v5.3
Reported-by: 李通洲 <carter.li@eoitek.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/io_uring.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1179,7 +1179,7 @@ static int io_import_fixed(struct io_rin
 		}
 	}
 
-	return 0;
+	return len;
 }
 
 static ssize_t io_import_iovec(struct io_ring_ctx *ctx, int rw,


