Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 372E9246FAB
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 19:51:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731435AbgHQRvW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 13:51:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:41770 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388656AbgHQQL6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 12:11:58 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6F8DE20772;
        Mon, 17 Aug 2020 16:11:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597680717;
        bh=cVwW3JpkPI2yvj2GLbXy1z9Bl6AxSIj5FTixz3QA3ms=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gLPW4lLWjHhwOYUVlGotBg/VgIzPZI088ftXhi9AjYJGXnr+FI3iHZWXFWlzrOIYM
         ACbNrNAUlOm/+zGEjJFf7kpTjlyNJ5KomnmLHtfljWGD+m+cZCPeiMsXqmCdfeo9Zb
         FQ/3ogY7pZciKIKYs5jggK94JuoPbrHtl/sCm4t8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Luis Chamberlain <mcgrof@kernel.org>,
        Ming Lei <ming.lei@redhat.com>, Christoph Hellwig <hch@lst.de>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 028/168] loop: be paranoid on exit and prevent new additions / removals
Date:   Mon, 17 Aug 2020 17:15:59 +0200
Message-Id: <20200817143735.153140623@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143733.692105228@linuxfoundation.org>
References: <20200817143733.692105228@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Luis Chamberlain <mcgrof@kernel.org>

[ Upstream commit 200f93377220504c5e56754823e7adfea6037f1a ]

Be pedantic on removal as well and hold the mutex.
This should prevent uses of addition while we exit.

Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
Reviewed-by: Ming Lei <ming.lei@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/loop.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index 728681a20b7f4..da68c42aed682 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -2279,6 +2279,8 @@ static void __exit loop_exit(void)
 
 	range = max_loop ? max_loop << part_shift : 1UL << MINORBITS;
 
+	mutex_lock(&loop_ctl_mutex);
+
 	idr_for_each(&loop_index_idr, &loop_exit_cb, NULL);
 	idr_destroy(&loop_index_idr);
 
@@ -2286,6 +2288,8 @@ static void __exit loop_exit(void)
 	unregister_blkdev(LOOP_MAJOR, "loop");
 
 	misc_deregister(&loop_misc);
+
+	mutex_unlock(&loop_ctl_mutex);
 }
 
 module_init(loop_init);
-- 
2.25.1



