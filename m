Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 50ED24937A
	for <lists+stable@lfdr.de>; Mon, 17 Jun 2019 23:31:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730614AbfFQV2x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jun 2019 17:28:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:56004 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730098AbfFQV2w (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Jun 2019 17:28:52 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 390E6204FD;
        Mon, 17 Jun 2019 21:28:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560806931;
        bh=7mhOnTIPb3Hhp5jz/5cT4L+GGAk+PVIfUVBMlPo+PzA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OG3TdfDjnUnRrgcMYx933Lp1LYCfsun+kJPH0QqcklL2AK6qa9oW6OhMhYexRb1mI
         TCM/LrL0GYO10gZ3HKRCoy3FgFPRFq68nR6yDFB8pjnyetJ8M6bXsPAZgfC4pw8oia
         ALEhimyp55p6cM3Aj4bUeFsyuCRknJRwH3mN+Ic8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Keith Busch <keith.busch@intel.com>,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 32/53] nvme: remove the ifdef around nvme_nvm_ioctl
Date:   Mon, 17 Jun 2019 23:10:15 +0200
Message-Id: <20190617210751.091865076@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190617210745.104187490@linuxfoundation.org>
References: <20190617210745.104187490@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 3f98bcc58cd5f1e4668db289dcab771874cc0920 ]

We already have a proper stub if lightnvm is not enabled, so don't bother
with the ifdef.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Keith Busch <keith.busch@intel.com>
Reviewed-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/core.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index 65f3f1a34b6b..d98ffb1ce629 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -1042,10 +1042,8 @@ static int nvme_ioctl(struct block_device *bdev, fmode_t mode,
 	case NVME_IOCTL_SUBMIT_IO:
 		return nvme_submit_io(ns, (void __user *)arg);
 	default:
-#ifdef CONFIG_NVM
 		if (ns->ndev)
 			return nvme_nvm_ioctl(ns, cmd, arg);
-#endif
 		if (is_sed_ioctl(cmd))
 			return sed_ioctl(ns->ctrl->opal_dev, cmd,
 					 (void __user *) arg);
-- 
2.20.1



