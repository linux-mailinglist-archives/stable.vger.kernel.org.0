Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF6D735C0A1
	for <lists+stable@lfdr.de>; Mon, 12 Apr 2021 11:22:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241245AbhDLJPH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Apr 2021 05:15:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:35864 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240985AbhDLJLU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Apr 2021 05:11:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C5B30613A2;
        Mon, 12 Apr 2021 09:07:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618218466;
        bh=ZC9P+5xP3+OydY9MNJjPYLvj1I9Z6Phlpj5+CuUf/SI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t5oBdDTMqeaDWCikjmsmK26bp7VQo3iHoqohsyhJCPdez/iiIsJYQHUHGPSZEyS7J
         1BO5nsMc9qPL3NuAPX1+29UN4Zdqmc94MQo482GS6BGwzjpGqL5RIHsF6LvqpEJ1rh
         vScuXp85XzgAEzbVzoO5Y44XYypdXspJyMUU1RhM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yunjian Wang <wangyunjian@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 164/210] net: cls_api: Fix uninitialised struct field bo->unlocked_driver_cb
Date:   Mon, 12 Apr 2021 10:41:09 +0200
Message-Id: <20210412084021.496315714@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210412084016.009884719@linuxfoundation.org>
References: <20210412084016.009884719@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yunjian Wang <wangyunjian@huawei.com>

[ Upstream commit 990b03b05b2fba79de2a1ee9dc359fc552d95ba6 ]

The 'unlocked_driver_cb' struct field in 'bo' is not being initialized
in tcf_block_offload_init(). The uninitialized 'unlocked_driver_cb'
will be used when calling unlocked_driver_cb(). So initialize 'bo' to
zero to avoid the issue.

Addresses-Coverity: ("Uninitialized scalar variable")
Fixes: 0fdcf78d5973 ("net: use flow_indr_dev_setup_offload()")
Signed-off-by: Yunjian Wang <wangyunjian@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sched/cls_api.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/sched/cls_api.c b/net/sched/cls_api.c
index 87cac07da7c3..b3a2cba130a1 100644
--- a/net/sched/cls_api.c
+++ b/net/sched/cls_api.c
@@ -646,7 +646,7 @@ static void tc_block_indr_cleanup(struct flow_block_cb *block_cb)
 	struct net_device *dev = block_cb->indr.dev;
 	struct Qdisc *sch = block_cb->indr.sch;
 	struct netlink_ext_ack extack = {};
-	struct flow_block_offload bo;
+	struct flow_block_offload bo = {};
 
 	tcf_block_offload_init(&bo, dev, sch, FLOW_BLOCK_UNBIND,
 			       block_cb->indr.binder_type,
-- 
2.30.2



