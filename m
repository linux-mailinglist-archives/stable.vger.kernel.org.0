Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9E64D11B83A
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 17:14:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730076AbfLKPHx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 10:07:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:55162 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730156AbfLKPHw (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 10:07:52 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5E0BA208C3;
        Wed, 11 Dec 2019 15:07:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576076871;
        bh=LxkpKmY76okQTg+AgmMzvZzLQNdZsYbEck/TtAYcZOU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=M3aAtibd2VH3zkAalj7aiK3skjLtsJ1rJxJ6xQxytd5yuXNfLM/pO8MO8KipUMlrM
         GUKbq9y3FIlbkMbxJ3BqXg1JPzUD6/P1jqZnl7ke2OY8pzu0X107HdPSF/TiBpBA/e
         dwl3j7Zp8wav9d5aBJ38yHzHoROqQM3ekd7UPU0k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Masayoshi Mizuma <m.mizuma@jp.fujitsu.com>,
        Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 5.4 22/92] fuse: fix leak of fuse_io_priv
Date:   Wed, 11 Dec 2019 16:05:13 +0100
Message-Id: <20191211150229.026735059@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191211150221.977775294@linuxfoundation.org>
References: <20191211150221.977775294@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miklos Szeredi <mszeredi@redhat.com>

commit f1ebdeffc6f325e30e0ddb9f7a70f1370fa4b851 upstream.

exit_aio() is sometimes stuck in wait_for_completion() after aio is issued
with direct IO and the task receives a signal.

The reason is failure to call ->ki_complete() due to a leaked reference to
fuse_io_priv.  This happens in fuse_async_req_send() if
fuse_simple_background() returns an error (e.g. -EINTR).

In this case the error value is propagated via io->err, so return success
to not confuse callers.

This issue is tracked as a virtio-fs issue:
https://gitlab.com/virtio-fs/qemu/issues/14

Reported-by: Masayoshi Mizuma <m.mizuma@jp.fujitsu.com>
Fixes: 45ac96ed7c36 ("fuse: convert direct_io to simple api")
Cc: <stable@vger.kernel.org> # v5.4
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/fuse/file.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/fs/fuse/file.c
+++ b/fs/fuse/file.c
@@ -713,8 +713,10 @@ static ssize_t fuse_async_req_send(struc
 
 	ia->ap.args.end = fuse_aio_complete_req;
 	err = fuse_simple_background(fc, &ia->ap.args, GFP_KERNEL);
+	if (err)
+		fuse_aio_complete_req(fc, &ia->ap.args, err);
 
-	return err ?: num_bytes;
+	return num_bytes;
 }
 
 static ssize_t fuse_send_read(struct fuse_io_args *ia, loff_t pos, size_t count,


