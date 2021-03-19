Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F2613414E0
	for <lists+stable@lfdr.de>; Fri, 19 Mar 2021 06:32:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233756AbhCSFb2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Mar 2021 01:31:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233867AbhCSFbA (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Mar 2021 01:31:00 -0400
X-Greylist: delayed 105 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 18 Mar 2021 22:31:00 PDT
Received: from forwardcorp1j.mail.yandex.net (forwardcorp1j.mail.yandex.net [IPv6:2a02:6b8:0:1619::183])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F631C06174A;
        Thu, 18 Mar 2021 22:31:00 -0700 (PDT)
Received: from iva8-d077482f1536.qloud-c.yandex.net (iva8-d077482f1536.qloud-c.yandex.net [IPv6:2a02:6b8:c0c:2f26:0:640:d077:482f])
        by forwardcorp1j.mail.yandex.net (Yandex) with ESMTP id E1F562E1B84;
        Fri, 19 Mar 2021 08:29:12 +0300 (MSK)
Received: from iva4-f06c35e68a0a.qloud-c.yandex.net (iva4-f06c35e68a0a.qloud-c.yandex.net [2a02:6b8:c0c:152e:0:640:f06c:35e6])
        by iva8-d077482f1536.qloud-c.yandex.net (mxbackcorp/Yandex) with ESMTP id F4JR1WuDB2-TC0GjsVY;
        Fri, 19 Mar 2021 08:29:12 +0300
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yandex-team.ru; s=default;
        t=1616131752; bh=Dbj3zhIAXgbrCEyU+4WpDvLYq3op3cfi+fy9JIsbaZg=;
        h=Message-Id:Date:Subject:To:From:Cc;
        b=y9HVkI6YU1rUJHbIH7oYBfbfltPAveJyX9NcHzugdwo/ZcJJlQo6m5g2xObWG0agx
         MfXmvL123mv/xqk+DKTbHVqnQpBApY81IdCbrhEpG19hJHcAFnT0rHFbkn7lipcgt8
         ijIsM6vk8BvRj9pVcBcc4oxixibCSjZukZoZt0Is=
Authentication-Results: iva8-d077482f1536.qloud-c.yandex.net; dkim=pass header.i=@yandex-team.ru
Received: from 95.108.174.193-red.dhcp.yndx.net (95.108.174.193-red.dhcp.yndx.net [95.108.174.193])
        by iva4-f06c35e68a0a.qloud-c.yandex.net (smtpcorp/Yandex) with ESMTPSA id tCWJ5LeHWA-TCnCvl1E;
        Fri, 19 Mar 2021 08:29:12 +0300
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (Client certificate not present)
From:   Dmitry Monakhov <dmtrmonakhov@yandex-team.ru>
To:     linux-kernel@vger.kernel.org
Cc:     linux-fsdevel@vger.kernel.org, stable@vger.kernel.org,
        axboe@kernel.dk, Dmitry Monakhov <dmtrmonakhov@yandex-team.ru>
Subject: [PATCH] io_uring: Try to merge io requests only for regular files
Date:   Fri, 19 Mar 2021 05:28:59 +0000
Message-Id: <20210319052859.3220-1-dmtrmonakhov@yandex-team.ru>
X-Mailer: git-send-email 2.18.0
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Otherwise we may endup blocking on pipe or socket.

Fixes: 6d5d5ac ("io_uring: extend async work merge")
Testcase: https://github.com/dmonakhov/liburing/commit/16d171b6ef9d68e6db66650a83d98c5c721d01f6
Signed-off-by: Dmitry Monakhov <dmtrmonakhov@yandex-team.ru>
---
 fs/io_uring.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 478df7e..848657c 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2183,6 +2183,9 @@ static int __io_submit_sqe(struct io_ring_ctx *ctx, struct io_kiocb *req,
 static struct async_list *io_async_list_from_req(struct io_ring_ctx *ctx,
 						 struct io_kiocb *req)
 {
+	if (!(req->flags & REQ_F_ISREG))
+		return NULL;
+
 	switch (req->submit.opcode) {
 	case IORING_OP_READV:
 	case IORING_OP_READ_FIXED:
-- 
2.7.4

