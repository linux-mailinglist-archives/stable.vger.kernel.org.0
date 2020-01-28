Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2B6EE14BBBB
	for <lists+stable@lfdr.de>; Tue, 28 Jan 2020 15:49:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727601AbgA1OCW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jan 2020 09:02:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:48632 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726967AbgA1OCV (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Jan 2020 09:02:21 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E2D4024683;
        Tue, 28 Jan 2020 14:02:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580220141;
        bh=gw2aZ1LbbeRJTTJCpYwXXL2rPlgmBOh3zKCfCJdZV6g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=l+xvT8RPZTqAUrevFiFsN6X2kZGQwY7yqmHAHOLr1UhpE/jPiC/FjShWSYYtLdclk
         jXlGMYCcVYRKEcGWJhsUa+pcjuPM1YU3qIBsPNexyt0pXgxUPMr6XzMk95ZEcSfjfU
         5bn0u0iWFuE6gly9o8z5HcqtvD/1Ew2spjsp8CFs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andres Freund <andres@anarazel.de>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.4 033/104] Revert "io_uring: only allow submit from owning task"
Date:   Tue, 28 Jan 2020 14:59:54 +0100
Message-Id: <20200128135821.839050866@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200128135817.238524998@linuxfoundation.org>
References: <20200128135817.238524998@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jens Axboe <axboe@kernel.dk>

commit 73e08e711d9c1d79fae01daed4b0e1fee5f8a275 upstream.

This ends up being too restrictive for tasks that willingly fork and
share the ring between forks. Andres reports that this breaks his
postgresql work. Since we're close to 5.5 release, revert this change
for now.

Cc: stable@vger.kernel.org
Fixes: 44d282796f81 ("io_uring: only allow submit from owning task")
Reported-by: Andres Freund <andres@anarazel.de>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 fs/io_uring.c |    6 ------
 1 file changed, 6 deletions(-)

--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -3716,12 +3716,6 @@ SYSCALL_DEFINE6(io_uring_enter, unsigned
 			wake_up(&ctx->sqo_wait);
 		submitted = to_submit;
 	} else if (to_submit) {
-		if (current->mm != ctx->sqo_mm ||
-		    current_cred() != ctx->creds) {
-			ret = -EPERM;
-			goto out;
-		}
-
 		to_submit = min(to_submit, ctx->sq_entries);
 
 		mutex_lock(&ctx->uring_lock);


