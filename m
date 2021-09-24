Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EED384173AC
	for <lists+stable@lfdr.de>; Fri, 24 Sep 2021 14:58:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345809AbhIXM71 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Sep 2021 08:59:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:53950 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345249AbhIXM5r (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Sep 2021 08:57:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 59B6A613A2;
        Fri, 24 Sep 2021 12:52:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632487924;
        bh=TbiP7MDWr1dYJ3oEy78muZkYFlS4VnAsNanY1WHxLgc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Fg0tjXwGYeQrVPje7GSpidFxttfXrX/jRt8Hjh/L7t8QFrQfstrXzf9wwroWP9Gib
         en4h5AqTNcDbGeAvPCwSKVufUuZyGXGDO98zUHnXHONdjJeGCREPmIZ1QDzhR4unP0
         5Z8gjEgJ24eCdniQxzRoiLfphAE7Txd2jI3RHKHA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Yang Yingliang <yangyingliang@huawei.com>,
        Chaitanya Kulkarni <kch@nvidia.com>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.14 015/100] n64cart: fix return value check in n64cart_probe()
Date:   Fri, 24 Sep 2021 14:43:24 +0200
Message-Id: <20210924124341.955825378@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210924124341.214446495@linuxfoundation.org>
References: <20210924124341.214446495@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yang Yingliang <yangyingliang@huawei.com>

commit 221e8360834c59f0c9952630fa5904a94ebd2bb8 upstream.

In case of error, the function devm_platform_ioremap_resource()
returns ERR_PTR() and never returns NULL. The NULL test in the
return value check should be replaced with IS_ERR().

Fixes: d9b2a2bbbb4d ("block: Add n64 cart driver")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
Link: https://lore.kernel.org/r/20210909090608.2989716-1-yangyingliang@huawei.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/block/n64cart.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/block/n64cart.c
+++ b/drivers/block/n64cart.c
@@ -129,8 +129,8 @@ static int __init n64cart_probe(struct p
 	}
 
 	reg_base = devm_platform_ioremap_resource(pdev, 0);
-	if (!reg_base)
-		return -EINVAL;
+	if (IS_ERR(reg_base))
+		return PTR_ERR(reg_base);
 
 	disk = blk_alloc_disk(NUMA_NO_NODE);
 	if (!disk)


