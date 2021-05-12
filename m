Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1FB837C30E
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 17:18:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232065AbhELPRK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 11:17:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:50810 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232511AbhELPOG (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 11:14:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E571661461;
        Wed, 12 May 2021 15:04:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620831875;
        bh=p/uZoDS1K9GWy2LxpKGK8mnTRIMRArO6DehKgw5B3qU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bq2nEwRaN+TZ8ljmOlGhSKWnfpgDeLSPgePpZIOuFX71TmcTt9hEyHzoEizv/m3rm
         oQcBWN5ZFRxHutsu3uMAMvR7wbDFkVKMrawvs0PyjRVFwO+FOP6w7PyuykVJrZuX6V
         bnRE2DIWb8hKlE5C8xkRhB7Vw7IVSu4sfIUBeQgw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Subject: [PATCH 5.10 050/530] md: md_open returns -EBUSY when entering racing area
Date:   Wed, 12 May 2021 16:42:40 +0200
Message-Id: <20210512144821.386618889@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144819.664462530@linuxfoundation.org>
References: <20210512144819.664462530@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhao Heming <heming.zhao@suse.com>

commit 6a4db2a60306eb65bfb14ccc9fde035b74a4b4e7 upstream.

commit d3374825ce57 ("md: make devices disappear when they are no longer
needed.") introduced protection between mddev creating & removing. The
md_open shouldn't create mddev when all_mddevs list doesn't contain
mddev. With currently code logic, there will be very easy to trigger
soft lockup in non-preempt env.

This patch changes md_open returning from -ERESTARTSYS to -EBUSY, which
will break the infinitely retry when md_open enter racing area.

This patch is partly fix soft lockup issue, full fix needs mddev_find
is split into two functions: mddev_find & mddev_find_or_alloc. And
md_open should call new mddev_find (it only does searching job).

For more detail, please refer with Christoph's "split mddev_find" patch
in later commits.

---
 drivers/md/md.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -7857,8 +7857,7 @@ static int md_open(struct block_device *
 		/* Wait until bdev->bd_disk is definitely gone */
 		if (work_pending(&mddev->del_work))
 			flush_workqueue(md_misc_wq);
-		/* Then retry the open from the top */
-		return -ERESTARTSYS;
+		return -EBUSY;
 	}
 	BUG_ON(mddev != bdev->bd_disk->private_data);
 


