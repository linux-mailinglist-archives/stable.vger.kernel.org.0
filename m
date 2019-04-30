Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E9719F6F1
	for <lists+stable@lfdr.de>; Tue, 30 Apr 2019 13:54:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730823AbfD3Luk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Apr 2019 07:50:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:37734 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730873AbfD3Lug (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 30 Apr 2019 07:50:36 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 343AC21734;
        Tue, 30 Apr 2019 11:50:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556625035;
        bh=aQ1rL1k9S06B0KOKHQbHGPsnAnrmOYzAs+UycxW6/1U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Aqyk8UcU7448x19Yk5Dc38WX/OnGWdYs9bC+p+TLL1Zv1DGLIUba7BY1N+6/p/Q7W
         SfU+3LQeQCZNlmSL2ZN2fcoONxQiZOCPCgvMlHTjxvIUwuJRYIEzqq6ri2/uzh/9vi
         4m4Spg5z8vtrRO4BoHBqOsZlu3z+iYtD1rKvg73o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dongli Zhang <dongli.zhang@oracle.com>,
        Jan Kara <jack@suse.cz>, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.0 49/89] loop: do not print warn message if partition scan is successful
Date:   Tue, 30 Apr 2019 13:38:40 +0200
Message-Id: <20190430113611.999291753@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190430113609.741196396@linuxfoundation.org>
References: <20190430113609.741196396@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dongli Zhang <dongli.zhang@oracle.com>

commit 40853d6fc619a6fd3d3177c3973a2eac9b598a80 upstream.

Do not print warn message when the partition scan returns 0.

Fixes: d57f3374ba48 ("loop: Move special partition reread handling in loop_clr_fd()")
Signed-off-by: Dongli Zhang <dongli.zhang@oracle.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/block/loop.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -1111,8 +1111,9 @@ out_unlock:
 			err = __blkdev_reread_part(bdev);
 		else
 			err = blkdev_reread_part(bdev);
-		pr_warn("%s: partition scan of loop%d failed (rc=%d)\n",
-			__func__, lo_number, err);
+		if (err)
+			pr_warn("%s: partition scan of loop%d failed (rc=%d)\n",
+				__func__, lo_number, err);
 		/* Device is gone, no point in returning error */
 		err = 0;
 	}


