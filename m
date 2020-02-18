Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D4AEA16317E
	for <lists+stable@lfdr.de>; Tue, 18 Feb 2020 21:01:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726723AbgBRUBC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Feb 2020 15:01:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:40456 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728712AbgBRUBB (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 18 Feb 2020 15:01:01 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4C30B24670;
        Tue, 18 Feb 2020 20:01:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582056060;
        bh=OgNurUw7ZIV9uIg954/9ZZV6/+R5DLqLOsAcVlC0myo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eZXJ2bBtXUlMfoydKSn5cQoMKuhRl8mI/v3cdLEGhcw83h4g3Vq7QyjFzbdjHazPh
         NFtlYY078sFILxjExFSBMeUFaBKGTJ6tIyGlVLVwEksQdYGVlmHDt52P06TluX3yEn
         +Tf0xTIDUQdgHKnorGMmwoF1LNNMpzLo1QYb43fA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.5 02/80] io_uring: retry raw bdev writes if we hit -EOPNOTSUPP
Date:   Tue, 18 Feb 2020 20:54:23 +0100
Message-Id: <20200218190432.275656418@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200218190432.043414522@linuxfoundation.org>
References: <20200218190432.043414522@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jens Axboe <axboe@kernel.dk>

commit faac996ccd5da95bc56b91aa80f2643c2d0a1c56 upstream.

For non-blocking issue, we set IOCB_NOWAIT in the kiocb. However, on a
raw block device, this yields an -EOPNOTSUPP return, as non-blocking
writes aren't supported. Turn this -EOPNOTSUPP into -EAGAIN, so we retry
from blocking context with IOCB_NOWAIT cleared.

Cc: stable@vger.kernel.org # 5.5
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/io_uring.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1978,6 +1978,12 @@ static int io_write(struct io_kiocb *req
 			ret2 = call_write_iter(req->file, kiocb, &iter);
 		else
 			ret2 = loop_rw_iter(WRITE, req->file, kiocb, &iter);
+		/*
+		 * Raw bdev writes will -EOPNOTSUPP for IOCB_NOWAIT. Just
+		 * retry them without IOCB_NOWAIT.
+		 */
+		if (ret2 == -EOPNOTSUPP && (kiocb->ki_flags & IOCB_NOWAIT))
+			ret2 = -EAGAIN;
 		if (!force_nonblock || ret2 != -EAGAIN) {
 			kiocb_done(kiocb, ret2, nxt, req->in_async);
 		} else {


