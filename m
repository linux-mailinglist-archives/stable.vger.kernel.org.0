Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15C9437C22B
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 17:06:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231887AbhELPHV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 11:07:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:57350 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232192AbhELPFu (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 11:05:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4965B61956;
        Wed, 12 May 2021 15:00:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620831638;
        bh=Tr2taFZ+B9uuMno3GJMN89fBtGGXkeyToDsOSsIv/bQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NQktU2/xaxrikVlIJLBUhhdQ1mCT62TRFX7KbzDnFvR7mP08eZY7ma7I5KxjA7Re2
         tQyz8TjFhctguv06imZkoUh7MXFtkZRcuHa5f6GY3d2vzdE9dGlKpcaFjxxW0gyo6s
         GPhJzBH2soa/2NF2O65s7rC6fqXY7lBIXb257SwA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Wang Wensheng <wangwensheng4@huawei.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 193/244] IB/hfi1: Fix error return code in parse_platform_config()
Date:   Wed, 12 May 2021 16:49:24 +0200
Message-Id: <20210512144749.176758733@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144743.039977287@linuxfoundation.org>
References: <20210512144743.039977287@linuxfoundation.org>
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
index 2b57ba70ddd6..c09080712485 100644
--- a/drivers/infiniband/hw/hfi1/firmware.c
+++ b/drivers/infiniband/hw/hfi1/firmware.c
@@ -1924,6 +1924,7 @@ int parse_platform_config(struct hfi1_devdata *dd)
 			dd_dev_err(dd, "%s: Failed CRC check at offset %ld\n",
 				   __func__, (ptr -
 				   (u32 *)dd->platform_config.data));
+			ret = -EINVAL;
 			goto bail;
 		}
 		/* Jump the CRC DWORD */
-- 
2.30.2



