Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 03CDE318E68
	for <lists+stable@lfdr.de>; Thu, 11 Feb 2021 16:27:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229955AbhBKP0T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Feb 2021 10:26:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:48922 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229997AbhBKPFN (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 11 Feb 2021 10:05:13 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A8AEA64DD8;
        Thu, 11 Feb 2021 15:03:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1613055792;
        bh=Hou3EzeFGnnnBff3YIbD7vysuVQWFhpKzE/7+xwR/JM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XK+UVqywK0xA7PBMyonw7Jv8Uxx+ZJJJcrnH+1hIIxt3RuPgnY3NCjNIVkXjfIDm4
         0s65otIwtYLMkIamzH7fXMOmYqXTKvS9myIIqX8VmHT2GDJJywD5dLeO5nRme4eF2m
         VWTsivGahaaee7eNUKjt+0+iFsEcUYrY7J3OA7i4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH 5.10 01/54] io_uring: simplify io_task_match()
Date:   Thu, 11 Feb 2021 16:01:45 +0100
Message-Id: <20210211150152.950719198@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210211150152.885701259@linuxfoundation.org>
References: <20210211150152.885701259@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Begunkov <asml.silence@gmail.com>

[ Upstream commit 06de5f5973c641c7ae033f133ecfaaf64fe633a6 ]

If IORING_SETUP_SQPOLL is set all requests belong to the corresponding
SQPOLL task, so skip task checking in that case and always match.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/io_uring.c |    6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1472,11 +1472,7 @@ static bool io_task_match(struct io_kioc
 
 	if (!tsk || req->task == tsk)
 		return true;
-	if (ctx->flags & IORING_SETUP_SQPOLL) {
-		if (ctx->sq_data && req->task == ctx->sq_data->thread)
-			return true;
-	}
-	return false;
+	return (ctx->flags & IORING_SETUP_SQPOLL);
 }
 
 /*


