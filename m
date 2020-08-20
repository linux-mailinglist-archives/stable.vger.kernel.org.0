Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A65C24BD0F
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 14:58:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729058AbgHTM5g (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 08:57:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:33902 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729083AbgHTJlC (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 05:41:02 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 773C720724;
        Thu, 20 Aug 2020 09:41:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597916462;
        bh=usJB+l/bgRxFMU7RdfbA4FT6nQW4eTysKwPja/RlPHM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nY//QjhNfvrPYvQeaBTXJeM9r8ugYdVNwiN15TZ6carYL1y9T1inbyzW9Qtbh9qbi
         Afd6bJ9dj84lSrkXf2Ukb0SoNOHAiCOx5YeF2xV3qjF93k1/z+lqyX7kmVxemWsDJb
         2HzZnlPZc3woDnCR6Saw1VGcUWnObbL7iS3WP2ys=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Colin Ian King <colin.king@canonical.com>,
        Joerg Roedel <jroedel@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 137/204] iommu/omap: Check for failure of a call to omap_iommu_dump_ctx
Date:   Thu, 20 Aug 2020 11:20:34 +0200
Message-Id: <20200820091613.093509816@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820091606.194320503@linuxfoundation.org>
References: <20200820091606.194320503@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

[ Upstream commit dee9d154f40c58d02f69acdaa5cfd1eae6ebc28b ]

It is possible for the call to omap_iommu_dump_ctx to return
a negative error number, so check for the failure and return
the error number rather than pass the negative value to
simple_read_from_buffer.

Fixes: 14e0e6796a0d ("OMAP: iommu: add initial debugfs support")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Link: https://lore.kernel.org/r/20200714192211.744776-1-colin.king@canonical.com
Addresses-Coverity: ("Improper use of negative value")
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/omap-iommu-debug.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/iommu/omap-iommu-debug.c b/drivers/iommu/omap-iommu-debug.c
index 8e19bfa94121e..a99afb5d9011c 100644
--- a/drivers/iommu/omap-iommu-debug.c
+++ b/drivers/iommu/omap-iommu-debug.c
@@ -98,8 +98,11 @@ static ssize_t debug_read_regs(struct file *file, char __user *userbuf,
 	mutex_lock(&iommu_debug_lock);
 
 	bytes = omap_iommu_dump_ctx(obj, p, count);
+	if (bytes < 0)
+		goto err;
 	bytes = simple_read_from_buffer(userbuf, count, ppos, buf, bytes);
 
+err:
 	mutex_unlock(&iommu_debug_lock);
 	kfree(buf);
 
-- 
2.25.1



