Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 50245492F1
	for <lists+stable@lfdr.de>; Mon, 17 Jun 2019 23:25:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727661AbfFQVZh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jun 2019 17:25:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:51794 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730090AbfFQVZg (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Jun 2019 17:25:36 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5E3D720657;
        Mon, 17 Jun 2019 21:25:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560806735;
        bh=uMGcgAsYAZxbhh/FHlZiLhemMx3jhyMKrx9MPh0BtHk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=d7UozSVwlqEr7TiirZXpAAyJyRpomGmLS/LYF1Pxy6zcVkwKbS+pl0gAfDOIAhlZm
         4wCwfh2L5zUiwovHlwxFhnFCa87JxwnvR/LZuRHVaP5xtYYS5O9/XCQ8T3Gq5Sm9tF
         VQ90wGSu46MEoTvJydzk1hNNmhQcDOsjYim4Slck=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Keith Busch <keith.busch@intel.com>,
        Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 40/75] nvme: remove the ifdef around nvme_nvm_ioctl
Date:   Mon, 17 Jun 2019 23:09:51 +0200
Message-Id: <20190617210754.327223202@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190617210752.799453599@linuxfoundation.org>
References: <20190617210752.799453599@linuxfoundation.org>
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
index 44d8077fbe95..1cdfea3c094a 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -1311,10 +1311,8 @@ static int nvme_ns_ioctl(struct nvme_ns *ns, unsigned cmd, unsigned long arg)
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



