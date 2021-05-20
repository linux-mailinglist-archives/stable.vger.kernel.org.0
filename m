Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 355AC38A764
	for <lists+stable@lfdr.de>; Thu, 20 May 2021 12:40:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237411AbhETKhy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 May 2021 06:37:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:39842 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237825AbhETKfj (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 May 2021 06:35:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0980A61C62;
        Thu, 20 May 2021 09:53:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621504433;
        bh=S4EPmOGhWiuMWGNKe7t0Ij091sAS3B5qwwBRaUlda2k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=l+D/30/LwbdC98aUn925bCmBfcO0+7IKBl2joIbVmDnyZYsuq3I9sS32xlZ9fL21P
         oCmpe1YQZNJvdA2UCcBoAcCyAXStCzNkpo8xZA/vlrGQWbG49C1ws3zzTFsHfk8uN9
         4AB6wJKpFnbSdBAYDxj7KQ36prtxdSLQhw8QksV0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Wang Wensheng <wangwensheng4@huawei.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 209/323] IB/hfi1: Fix error return code in parse_platform_config()
Date:   Thu, 20 May 2021 11:21:41 +0200
Message-Id: <20210520092127.290936006@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210520092120.115153432@linuxfoundation.org>
References: <20210520092120.115153432@linuxfoundation.org>
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
index 5aea8f47e670..c54359376cda 100644
--- a/drivers/infiniband/hw/hfi1/firmware.c
+++ b/drivers/infiniband/hw/hfi1/firmware.c
@@ -1885,6 +1885,7 @@ int parse_platform_config(struct hfi1_devdata *dd)
 			dd_dev_err(dd, "%s: Failed CRC check at offset %ld\n",
 				   __func__, (ptr -
 				   (u32 *)dd->platform_config.data));
+			ret = -EINVAL;
 			goto bail;
 		}
 		/* Jump the CRC DWORD */
-- 
2.30.2



