Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C53A113F86E
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 20:18:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732306AbgAPQyg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 11:54:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:39262 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732274AbgAPQyg (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 11:54:36 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EF57A2192A;
        Thu, 16 Jan 2020 16:54:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579193675;
        bh=dahKvLZdNJjC4GxaMJR7cqCS8Yq9xqQmKrKzt7UrVV0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ObwTGaUlXFQQc6iLBcKZvsPzwB7H0PM4bLYQi6KAK+adn7RCEu4FNG9bsArW+QWTr
         7nfFwXRH4xZ9YW5YHKXdxfGZLp3Uh7LO4BWlZuHzmaIVqcY26qEVK2sx1yR/pEadXz
         6aKgIAPIfbn++x96Y0L1Qw4rsenvp7P9ejE9mraQ=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Can Guo <cang@codeaurora.org>, Avri Altman <avri.altman@wdc.com>,
        Christoph Hellwig <hch@lst.de>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>, linux-scsi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 200/205] scsi: ufs: Give an unique ID to each ufs-bsg
Date:   Thu, 16 Jan 2020 11:42:55 -0500
Message-Id: <20200116164300.6705-200-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116164300.6705-1-sashal@kernel.org>
References: <20200116164300.6705-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Can Guo <cang@codeaurora.org>

[ Upstream commit 8c850a0296004409e7bcb9464712fb2807da656a ]

Considering there can be multiple UFS hosts in SoC, give each ufs-bsg an
unique ID by appending the scsi host number to its device name.

Link: https://lore.kernel.org/r/0101016eca8dc9d7-d24468d3-04d2-4ef3-a906-abe8b8cbcd3d-000000@us-west-2.amazonses.com
Fixes: df032bf27a41 ("scsi: ufs: Add a bsg endpoint that supports UPIUs")
Signed-off-by: Can Guo <cang@codeaurora.org>
Reviewed-by: Avri Altman <avri.altman@wdc.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/ufs/ufs_bsg.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/ufs/ufs_bsg.c b/drivers/scsi/ufs/ufs_bsg.c
index dc2f6d2b46ed..d2197a31abe5 100644
--- a/drivers/scsi/ufs/ufs_bsg.c
+++ b/drivers/scsi/ufs/ufs_bsg.c
@@ -202,7 +202,7 @@ int ufs_bsg_probe(struct ufs_hba *hba)
 	bsg_dev->parent = get_device(parent);
 	bsg_dev->release = ufs_bsg_node_release;
 
-	dev_set_name(bsg_dev, "ufs-bsg");
+	dev_set_name(bsg_dev, "ufs-bsg%u", shost->host_no);
 
 	ret = device_add(bsg_dev);
 	if (ret)
-- 
2.20.1

