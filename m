Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B855E1EAEAC
	for <lists+stable@lfdr.de>; Mon,  1 Jun 2020 20:56:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729839AbgFASz6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Jun 2020 14:55:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:43842 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729727AbgFASBB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Jun 2020 14:01:01 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B8CC02065C;
        Mon,  1 Jun 2020 18:01:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591034461;
        bh=34qFoiIdx3EASLYtjJ8hDED8J4SS7nLVvZXR6s/rHWs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OWRIEJFisv/Eq0+3JC+0dwrEDbOeX57CRRWye4Jdm9YNCoWzPTn9MH/om0PXe0+ME
         N5awOnkgPykJ8rTbxTFfbsXrVOy74fK7hRr361VHIX3E7DPzzeKcsx6kkHdRKG5lou
         80D/tBj360s7CDVKw+QPJZXQRRbTE9Ctpw5saTIc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peng Hao <richard.peng@oppo.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 41/77] mmc: block: Fix use-after-free issue for rpmb
Date:   Mon,  1 Jun 2020 19:53:46 +0200
Message-Id: <20200601174023.793334810@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200601174016.396817032@linuxfoundation.org>
References: <20200601174016.396817032@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Peng Hao <richard.peng@oppo.com>

[ Upstream commit 202500d21654874aa03243e91f96de153ec61860 ]

The data structure member “rpmb->md” was passed to a call of the function
“mmc_blk_put” after a call of the function “put_device”. Reorder these
function calls to keep the data accesses consistent.

Fixes: 1c87f7357849 ("mmc: block: Fix bug when removing RPMB chardev ")
Signed-off-by: Peng Hao <richard.peng@oppo.com>
Cc: stable@vger.kernel.org
[Uffe: Fixed up mangled patch and updated commit message]
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/core/block.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mmc/core/block.c b/drivers/mmc/core/block.c
index 916b88ee2de4..cbb72b460755 100644
--- a/drivers/mmc/core/block.c
+++ b/drivers/mmc/core/block.c
@@ -2333,8 +2333,8 @@ static int mmc_rpmb_chrdev_release(struct inode *inode, struct file *filp)
 	struct mmc_rpmb_data *rpmb = container_of(inode->i_cdev,
 						  struct mmc_rpmb_data, chrdev);
 
-	put_device(&rpmb->dev);
 	mmc_blk_put(rpmb->md);
+	put_device(&rpmb->dev);
 
 	return 0;
 }
-- 
2.25.1



