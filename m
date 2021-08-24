Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5707B3F65E7
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 19:17:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234028AbhHXRSD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Aug 2021 13:18:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:55478 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238413AbhHXRQD (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Aug 2021 13:16:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F329061A8B;
        Tue, 24 Aug 2021 17:01:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629824509;
        bh=IFWUA4+G9fEBgOZWy1Vl9HXWNbw5fFgWb7maZ0Vpv3o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=avL8G5hfhv+/WjETKlNXutDdkTtZkmDHaHMxsmxH5YfX0S8rUv6B/ZNQgtKaBvYJ4
         IQ++WQct+4agQYxowudYEL+SsN6Lvx/H4TI4NQXk/Y4Ae+dtQ/vcVgmcxbyb3hWbpA
         0Kq2v9BXS6qpj7GVyAPPNCszlEqJ/ykNNwDNghtl8i9gQMe1uqaaSEEXe1n8hnbyrT
         uZBCINwwH/vQb/GRoYUilnrqKRgNYSmA25ZwUeHukTTN/SqZmxht3XnTOFMUlVR414
         /bhjmn8tSUI7P+DMI8zXVx+4HrvmixangEttOxWFk0QAwCKt0+KIoHpPOj3QUdWsgI
         KM4Qn1aimlWlQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "kaixi.fan" <fankaixi.li@bytedance.com>,
        xiexiaohui <xiexiaohui.xxh@bytedance.com>,
        Cong Wang <cong.wang@bytedance.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 42/61] ovs: clear skb->tstamp in forwarding path
Date:   Tue, 24 Aug 2021 13:00:47 -0400
Message-Id: <20210824170106.710221-43-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210824170106.710221-1-sashal@kernel.org>
References: <20210824170106.710221-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.143-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.4.143-rc1
X-KernelTest-Deadline: 2021-08-26T17:01+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "kaixi.fan" <fankaixi.li@bytedance.com>

[ Upstream commit 01634047bf0d5c2d9b7d8095bb4de1663dbeedeb ]

fq qdisc requires tstamp to be cleared in the forwarding path. Now ovs
doesn't clear skb->tstamp. We encountered a problem with linux
version 5.4.56 and ovs version 2.14.1, and packets failed to
dequeue from qdisc when fq qdisc was attached to ovs port.

Fixes: fb420d5d91c1 ("tcp/fq: move back to CLOCK_MONOTONIC")
Signed-off-by: kaixi.fan <fankaixi.li@bytedance.com>
Signed-off-by: xiexiaohui <xiexiaohui.xxh@bytedance.com>
Reviewed-by: Cong Wang <cong.wang@bytedance.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/openvswitch/vport.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/openvswitch/vport.c b/net/openvswitch/vport.c
index 3fc38d16c456..19af0efeb8dc 100644
--- a/net/openvswitch/vport.c
+++ b/net/openvswitch/vport.c
@@ -499,6 +499,7 @@ void ovs_vport_send(struct vport *vport, struct sk_buff *skb, u8 mac_proto)
 	}
 
 	skb->dev = vport->dev;
+	skb->tstamp = 0;
 	vport->ops->send(skb);
 	return;
 
-- 
2.30.2

