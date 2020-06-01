Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E37921EAB3C
	for <lists+stable@lfdr.de>; Mon,  1 Jun 2020 20:17:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731590AbgFASPb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Jun 2020 14:15:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:35794 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731585AbgFASP2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Jun 2020 14:15:28 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6A0FD2065C;
        Mon,  1 Jun 2020 18:15:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591035327;
        bh=BDvc6Ul4JpUEu0xyaXOuBkOI3neeAE1ZCxh7AFG5C6I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kvJcVCpwdTDJ5Phv+zFNqlwfG3A1OGqT0KXaDZC2PaqztkpalUwDZBfyA7dszQMQG
         NTq6ASZF6PlhNIozXZoB1lYbpVRlR27zPX2+NJzswTJxJysR8tFRIHkN52X5eaofNc
         6SsjxYoQ/xZRasOoVpv6uJU9EjPm6NB6RMmC5c6U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peng Hao <richard.peng@oppo.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.6 110/177] mmc: block: Fix use-after-free issue for rpmb
Date:   Mon,  1 Jun 2020 19:54:08 +0200
Message-Id: <20200601174057.793784262@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200601174048.468952319@linuxfoundation.org>
References: <20200601174048.468952319@linuxfoundation.org>
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
index 32db16f6debc..2d19291ebc84 100644
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



