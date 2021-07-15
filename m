Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8E123CA7E6
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 20:54:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240518AbhGOS45 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 14:56:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:33088 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241133AbhGOS4e (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 15 Jul 2021 14:56:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5B111613DB;
        Thu, 15 Jul 2021 18:53:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626375211;
        bh=gh1Dokpg8mc+rBHS3TG5+qodz7kuClBqeYXQe00w4Rs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mjks87YodjBtZqCUA/T9PUTVzults7WCANLIq6m/DtOsyTOW943lyDoX67MLGj71Q
         de4wf7b4HArG4jkZh/D1f3kQRPXU71Q5bqxfW8+Wvewz1dkytD0lOApFz88lluH+Ym
         Rj0TMzX33ckevcUcz/C3iDoBMGec4B+hk3bZuuy0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yang Yingliang <yangyingliang@huawei.com>
Subject: [PATCH 5.10 208/215] io_uring: fix clear IORING_SETUP_R_DISABLED in wrong function
Date:   Thu, 15 Jul 2021 20:39:40 +0200
Message-Id: <20210715182635.947795275@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210715182558.381078833@linuxfoundation.org>
References: <20210715182558.381078833@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yang Yingliang <yangyingliang@huawei.com>

In commit 3ebba796fa25 ("io_uring: ensure that SQPOLL thread is started for exit"),
the IORING_SETUP_R_DISABLED is cleared in io_sq_offload_start(), but when backport
it to stable-5.10, IORING_SETUP_R_DISABLED is cleared in __io_req_task_submit(),
move clearing IORING_SETUP_R_DISABLED to io_sq_offload_start() to fix this.

Fixes: 6cae8095490ca ("io_uring: ensure that SQPOLL thread is started for exit")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/io_uring.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2087,7 +2087,6 @@ static void __io_req_task_submit(struct
 		__io_req_task_cancel(req, -EFAULT);
 	mutex_unlock(&ctx->uring_lock);
 
-	ctx->flags &= ~IORING_SETUP_R_DISABLED;
 	if (ctx->flags & IORING_SETUP_SQPOLL)
 		io_sq_thread_drop_mm();
 }
@@ -7992,6 +7991,7 @@ static void io_sq_offload_start(struct i
 {
 	struct io_sq_data *sqd = ctx->sq_data;
 
+	ctx->flags &= ~IORING_SETUP_R_DISABLED;
 	if ((ctx->flags & IORING_SETUP_SQPOLL) && sqd->thread)
 		wake_up_process(sqd->thread);
 }


