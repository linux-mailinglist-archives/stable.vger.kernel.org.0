Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 149841EAD7F
	for <lists+stable@lfdr.de>; Mon,  1 Jun 2020 20:45:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730830AbgFASJH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Jun 2020 14:09:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:55448 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728839AbgFASJG (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Jun 2020 14:09:06 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EF61A2068D;
        Mon,  1 Jun 2020 18:09:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591034946;
        bh=HVW0Oq4vPyzNpfObjgAt+27ZFCmKdfiWbHLdxnQVxtY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=icz1PvW08JTvR+S7Q7IXRNXG6tZhgAMqxzj6FrZ3isAvQZoEi4QLvHtF/OLBAqu22
         xjDLy72gmeA1gcdlSDtJHIxr/6qQo8etKekq8LiJrwdmLb6vq1bXXMfRmUBePNXPxs
         iGfjVuw/kHnaAc/Ly4v96+H1SX6s+pgcCDqhfDM0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peng Hao <richard.peng@oppo.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 083/142] mmc: block: Fix use-after-free issue for rpmb
Date:   Mon,  1 Jun 2020 19:54:01 +0200
Message-Id: <20200601174046.549387147@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200601174037.904070960@linuxfoundation.org>
References: <20200601174037.904070960@linuxfoundation.org>
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
index 9d01b5dca519..7f480c6b1981 100644
--- a/drivers/mmc/core/block.c
+++ b/drivers/mmc/core/block.c
@@ -2475,8 +2475,8 @@ static int mmc_rpmb_chrdev_release(struct inode *inode, struct file *filp)
 	struct mmc_rpmb_data *rpmb = container_of(inode->i_cdev,
 						  struct mmc_rpmb_data, chrdev);
 
-	put_device(&rpmb->dev);
 	mmc_blk_put(rpmb->md);
+	put_device(&rpmb->dev);
 
 	return 0;
 }
-- 
2.25.1



