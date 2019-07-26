Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B9C5576E1B
	for <lists+stable@lfdr.de>; Fri, 26 Jul 2019 17:40:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728470AbfGZPiB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Jul 2019 11:38:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:43718 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388672AbfGZP3G (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 26 Jul 2019 11:29:06 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 13AB322C7E;
        Fri, 26 Jul 2019 15:29:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564154946;
        bh=SLkY0kzv+7zTX5Msvvotv5x3ROGVMcKp6MdENo7d3Ts=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RxJc0G88rKvkIpm+O4u1ggkdHDQmXpvR/UvtevqPfSpyDDX3Emv38vytGU2RsEBML
         WA9AbHZQ5gAg/BlA22hsjDfpzS/E+XpyR4tMUh17t5QHJKKjVc6r+dL/Fr7r7a+i2G
         mSNjmYPNn0TUYWJ7wWJiuZ560e4ECVNXAGYn2s5E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Haiyang Zhang <haiyangz@microsoft.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.1 03/62] hv_netvsc: Fix extra rcu_read_unlock in netvsc_recv_callback()
Date:   Fri, 26 Jul 2019 17:24:15 +0200
Message-Id: <20190726152302.069212417@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190726152301.720139286@linuxfoundation.org>
References: <20190726152301.720139286@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Haiyang Zhang <haiyangz@microsoft.com>

[ Upstream commit be4363bdf0ce9530f15aa0a03d1060304d116b15 ]

There is an extra rcu_read_unlock left in netvsc_recv_callback(),
after a previous patch that removes RCU from this function.
This patch removes the extra RCU unlock.

Fixes: 345ac08990b8 ("hv_netvsc: pass netvsc_device to receive callback")
Signed-off-by: Haiyang Zhang <haiyangz@microsoft.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/hyperv/netvsc_drv.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/net/hyperv/netvsc_drv.c
+++ b/drivers/net/hyperv/netvsc_drv.c
@@ -849,7 +849,6 @@ int netvsc_recv_callback(struct net_devi
 
 	if (unlikely(!skb)) {
 		++net_device_ctx->eth_stats.rx_no_memory;
-		rcu_read_unlock();
 		return NVSP_STAT_FAIL;
 	}
 


