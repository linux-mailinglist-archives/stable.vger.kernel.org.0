Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7EDE43A114
	for <lists+stable@lfdr.de>; Mon, 25 Oct 2021 21:34:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235474AbhJYThP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Oct 2021 15:37:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:53236 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236223AbhJYTdw (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Oct 2021 15:33:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 61CF660F70;
        Mon, 25 Oct 2021 19:29:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635190179;
        bh=pS3NwPU5wtw4KcfK7qzVyZHdhWZZgTELk8qV9NoY6ic=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lkyhfyemJ1SzPt6cj4EV/hGfyZYheTqxX2U+rhXoTHAh+eJJ8I/68SjuLj7mpRlsH
         UnxNii+9kZ+eNQnAH/dkmu988cQcVvA6Nda2ghQc/TK4vrUahkUdmIdinYPKwcfMMF
         cWuY6BMRVEH05kbEjZclHXo9uWV05uWpysKZrJYw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 5.10 03/95] io_uring: fix splice_fd_in checks backport typo
Date:   Mon, 25 Oct 2021 21:14:00 +0200
Message-Id: <20211025190956.861015682@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211025190956.374447057@linuxfoundation.org>
References: <20211025190956.374447057@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kamal Mostafa <kamal@canonical.com>

The linux-5.10.y backport of commit "io_uring: add ->splice_fd_in checks"
includes a typo: "|" where "||" should be. (The original upstream commit
is fine.)

Fixes: 54eb6211b979 ("io_uring: add ->splice_fd_in checks")
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org # v5.10
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/io_uring.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -5559,7 +5559,7 @@ static int io_timeout_remove_prep(struct
 		return -EINVAL;
 	if (unlikely(req->flags & (REQ_F_FIXED_FILE | REQ_F_BUFFER_SELECT)))
 		return -EINVAL;
-	if (sqe->ioprio || sqe->buf_index || sqe->len || sqe->timeout_flags |
+	if (sqe->ioprio || sqe->buf_index || sqe->len || sqe->timeout_flags ||
 	    sqe->splice_fd_in)
 		return -EINVAL;
 


