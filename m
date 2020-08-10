Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1C642408EF
	for <lists+stable@lfdr.de>; Mon, 10 Aug 2020 17:27:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727895AbgHJP1I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Aug 2020 11:27:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:60928 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728683AbgHJP0w (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Aug 2020 11:26:52 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EEE9322DD6;
        Mon, 10 Aug 2020 15:26:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597073212;
        bh=qRI9lOsRho7/4Hw+5MD8A/vCTNs9jDyDvvANGYuj8Vo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uEuTFusteeMmxXN7CvG+eeRu8GJCO9Gp2qASOoP6Ii1PGmYW6PPsC/qjENwsSJdda
         CPVvxIcwKHUApISeg9ZCAA1TpBglAxqPW2I3TRlvDGpyxjgzpLYCzV43QGkP9NIsfK
         Yt1RWVWQLuFI2n3AV3KtXfpUP5K8a0TXWvpG+N1E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Guoyu Huang <hgy5945@gmail.com>, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.4 07/67] io_uring: Fix use-after-free in io_sq_wq_submit_work()
Date:   Mon, 10 Aug 2020 17:20:54 +0200
Message-Id: <20200810151809.797954399@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200810151809.438685785@linuxfoundation.org>
References: <20200810151809.438685785@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Guoyu Huang <hgy5945@gmail.com>

when ctx->sqo_mm is zero, io_sq_wq_submit_work() frees 'req'
without deleting it from 'task_list'. After that, 'req' is
accessed in io_ring_ctx_wait_and_kill() which lead to
a use-after-free.

Signed-off-by: Guoyu Huang <hgy5945@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/io_uring.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2232,6 +2232,7 @@ restart:
 		if (io_req_needs_user(req) && !cur_mm) {
 			if (!mmget_not_zero(ctx->sqo_mm)) {
 				ret = -EFAULT;
+				goto end_req;
 			} else {
 				cur_mm = ctx->sqo_mm;
 				use_mm(cur_mm);


