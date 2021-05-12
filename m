Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABA4E37C5BC
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 17:41:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233392AbhELPmu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 11:42:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:55348 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236414AbhELPhx (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 11:37:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C88C961C5F;
        Wed, 12 May 2021 15:19:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620832783;
        bh=8OXsMbHI/ZYKcUDdic0MdkI5wGcbxa5+XY0URUkODhc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RW9LrDm9p+vHNhERufoo2pd8a0WHUYwgUSPn0kTqjLTTQPomVgWWYtY5WrnK3VGzk
         YKFiBDckLjYovbUynO8/grps3i7vEJVVLPOZmEdg6xWqbcIIcgAlBApGYOnLwp55M3
         zci+c1AspSVVWQUIgcEY9Ts7pqahk4X2ZNRPfoNY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Wang Wensheng <wangwensheng4@huawei.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 422/530] IB/hfi1: Fix error return code in parse_platform_config()
Date:   Wed, 12 May 2021 16:48:52 +0200
Message-Id: <20210512144833.644251297@linuxfoundation.org>
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

From: Wang Wensheng <wangwensheng4@huawei.com>

[ Upstream commit 4c7d9c69adadfc31892c7e8e134deb3546552106 ]

Fix to return a negative error code from the error handling case instead
of 0, as done elsewhere in this function.

Fixes: 7724105686e7 ("IB/hfi1: add driver files")
Link: https://lore.kernel.org/r/20210408113140.103032-1-wangwensheng4@huawei.com
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Wang Wensheng <wangwensheng4@huawei.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/hfi1/firmware.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/infiniband/hw/hfi1/firmware.c b/drivers/infiniband/hw/hfi1/firmware.c
index 0e83d4b61e46..2cf102b5abd4 100644
--- a/drivers/infiniband/hw/hfi1/firmware.c
+++ b/drivers/infiniband/hw/hfi1/firmware.c
@@ -1916,6 +1916,7 @@ int parse_platform_config(struct hfi1_devdata *dd)
 			dd_dev_err(dd, "%s: Failed CRC check at offset %ld\n",
 				   __func__, (ptr -
 				   (u32 *)dd->platform_config.data));
+			ret = -EINVAL;
 			goto bail;
 		}
 		/* Jump the CRC DWORD */
-- 
2.30.2



