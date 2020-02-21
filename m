Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3E95916751C
	for <lists+stable@lfdr.de>; Fri, 21 Feb 2020 09:30:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388494AbgBUIXb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Feb 2020 03:23:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:35588 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388490AbgBUIXb (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Feb 2020 03:23:31 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1325424676;
        Fri, 21 Feb 2020 08:23:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582273410;
        bh=HhQ4HBxToqOlP2WfNDtZs5pT2ABW7zoq0eEpp6vCOrA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lZwqciHKW8VEhTSe/n6PlT6w5DnsTHsdFDV+IJLnYJK6EEyVCcEriGZMOiCcF+plF
         zEPSyLk17aHEB9uOgJpmWACYN04QsUCP/ieX94wLkYmsaTZKRDF2o2XdNaIwhtOMGt
         2v4VN4wsTbqnFKKsdQkUs+gQrhQ6NkfSx2eQn7E8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Liang Chen <liangchen.linux@gmail.com>,
        Christoph Hellwig <hch@lst.de>, Coly Li <colyli@suse.de>,
        Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 159/191] bcache: cached_dev_free needs to put the sb page
Date:   Fri, 21 Feb 2020 08:42:12 +0100
Message-Id: <20200221072309.946803647@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200221072250.732482588@linuxfoundation.org>
References: <20200221072250.732482588@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Liang Chen <liangchen.linux@gmail.com>

[ Upstream commit e8547d42095e58bee658f00fef8e33d2a185c927 ]

Same as cache device, the buffer page needs to be put while
freeing cached_dev.  Otherwise a page would be leaked every
time a cached_dev is stopped.

Signed-off-by: Liang Chen <liangchen.linux@gmail.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Coly Li <colyli@suse.de>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/bcache/super.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index c45d9ad010770..5b5cbfadd003d 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -1226,6 +1226,9 @@ static void cached_dev_free(struct closure *cl)
 
 	mutex_unlock(&bch_register_lock);
 
+	if (dc->sb_bio.bi_inline_vecs[0].bv_page)
+		put_page(bio_first_page_all(&dc->sb_bio));
+
 	if (!IS_ERR_OR_NULL(dc->bdev))
 		blkdev_put(dc->bdev, FMODE_READ|FMODE_WRITE|FMODE_EXCL);
 
-- 
2.20.1



