Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F7792E3FF2
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:46:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408336AbgL1OqW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:46:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:59756 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2502967AbgL1OYC (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:24:02 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2895720791;
        Mon, 28 Dec 2020 14:23:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609165426;
        bh=0jDFRuMUyj3LIlnyNKUrkd5ogxo0CDxpR9NwgW+B4o4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rYIfue9GDSEZrkagNbx+FEaQw0Ie1bMgv21CxZEX3iYPbsPidKCbhQD33hDn3h9ic
         sNe6xwJkfz6W+jTx3Xq39iD29No5y0VDDMKfE/hxxi9szmulb5ZcZThi190qPuOoZw
         s209hiyUpaif6Iz7uUFNfcLYYGQ3DvX7t5hi3Ih0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.10 510/717] io_uring: fix io_cqring_events()s noflush
Date:   Mon, 28 Dec 2020 13:48:28 +0100
Message-Id: <20201228125045.395675197@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Begunkov <asml.silence@gmail.com>

commit 59850d226e4907a6f37c1d2fe5ba97546a8691a4 upstream.

Checking !list_empty(&ctx->cq_overflow_list) around noflush in
io_cqring_events() is racy, because if it fails but a request overflowed
just after that, io_cqring_overflow_flush() still will be called.

Remove the second check, it shouldn't be a problem for performance,
because there is cq_check_overflow bit check just above.

Cc: <stable@vger.kernel.org> # 5.5+
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/io_uring.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2242,7 +2242,7 @@ static unsigned io_cqring_events(struct
 		 * we wake up the task, and the next invocation will flush the
 		 * entries. We cannot safely to it from here.
 		 */
-		if (noflush && !list_empty(&ctx->cq_overflow_list))
+		if (noflush)
 			return -1U;
 
 		io_cqring_overflow_flush(ctx, false, NULL, NULL);


