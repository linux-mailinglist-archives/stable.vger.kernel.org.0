Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6F8924B4FB
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 12:16:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731134AbgHTKPh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 06:15:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:34712 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731251AbgHTKPY (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 06:15:24 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AC5782078D;
        Thu, 20 Aug 2020 10:15:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597918524;
        bh=jEodp2XBbycLqhu6saZoTXE2lkh+HwkeWPk6lozDk6k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uPtWvkz21DPqMsQGt3pYOAATLiuei3Z7STjuEqC/OZbSw8sfDVFfZ5io4gUcTwleS
         gV341705pnj9mH4QL4Ab7v3Or5eMFWSpA4T1h+QE1k+Bfa0hTCQ/LrfSDjsBYq/w0k
         vOq5plWp8WPWRDHrQ0BMnKypaPloiR0QCM08YRgc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Colin Ian King <colin.king@canonical.com>,
        Joerg Roedel <jroedel@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 202/228] iommu/omap: Check for failure of a call to omap_iommu_dump_ctx
Date:   Thu, 20 Aug 2020 11:22:57 +0200
Message-Id: <20200820091617.641668399@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820091607.532711107@linuxfoundation.org>
References: <20200820091607.532711107@linuxfoundation.org>
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
index 505548aafeff2..cec33e90e3998 100644
--- a/drivers/iommu/omap-iommu-debug.c
+++ b/drivers/iommu/omap-iommu-debug.c
@@ -101,8 +101,11 @@ static ssize_t debug_read_regs(struct file *file, char __user *userbuf,
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



