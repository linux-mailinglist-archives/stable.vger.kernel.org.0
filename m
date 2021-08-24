Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96AE63F6532
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 19:10:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239425AbhHXRKl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Aug 2021 13:10:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:52012 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239328AbhHXRJD (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Aug 2021 13:09:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 29D4661A3D;
        Tue, 24 Aug 2021 17:00:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629824415;
        bh=Nd9FkhKEIIRkYHkdbVLek5Ox9yqkm9V+rP4Ajje0j6o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=outrFbHO83eTS75c6QpJOGvgNbKclqf5Z87qbR2d31h64P+IS8WDqyJiqW6kKbxMY
         yzy+Kyb1qqf9pR1ff9IDQ917ywe/OoUyPVWCgql3WF5NNvnALG7MkZUBaiS1fRh8CN
         crCGuN0tzfGgXtzhzZOhA08QBnTHcbyZMPS+w78wKbPNlF7UkacAImicRoaP/eM7QQ
         LOH0L63aMjUiPZyzTl78QfuMsGcPh0cJJAnI4KGQevEI6/8RTGBY39HodW1fjA3FR4
         2jSvNSwW4R5lNNV4b1DV2jAulN8RGRbb9AcqfQb+JCO8xQTVaeGsbYdWDn80AvMEiE
         WQsIZ9WHiMMyQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "kaixi.fan" <fankaixi.li@bytedance.com>,
        xiexiaohui <xiexiaohui.xxh@bytedance.com>,
        Cong Wang <cong.wang@bytedance.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 65/98] ovs: clear skb->tstamp in forwarding path
Date:   Tue, 24 Aug 2021 12:58:35 -0400
Message-Id: <20210824165908.709932-66-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210824165908.709932-1-sashal@kernel.org>
References: <20210824165908.709932-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.61-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.10.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.10.61-rc1
X-KernelTest-Deadline: 2021-08-26T16:58+00:00
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
index 82d801f063b7..1c05d4bef331 100644
--- a/net/openvswitch/vport.c
+++ b/net/openvswitch/vport.c
@@ -503,6 +503,7 @@ void ovs_vport_send(struct vport *vport, struct sk_buff *skb, u8 mac_proto)
 	}
 
 	skb->dev = vport->dev;
+	skb->tstamp = 0;
 	vport->ops->send(skb);
 	return;
 
-- 
2.30.2

