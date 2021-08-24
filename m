Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 464E03F63FA
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 19:00:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234145AbhHXRAH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Aug 2021 13:00:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:39040 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235115AbhHXQ6X (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Aug 2021 12:58:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D537861409;
        Tue, 24 Aug 2021 16:57:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629824235;
        bh=PbXbYZZIft3+AyzZCLRk2xr1pZ7SS6ZFFPbutBko77w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oBvsXSvn20xAEFnVoLt407v1kAIOFqLhSN7C1jBOn5yYmD4xH4+lTdeVf/DPADCuJ
         wACJttnnqop/m7X5tB+2kjLs4ySlZ4WGdbPPMt0kTjZbAdqSAK8BUltypeI/y/BJrH
         kV5Wd/l5G5EhHJ/S1YedEQ14cUiFZNana9r0asooRe4nqnQd/70ij7H9L4kdyFJ9zB
         K9Fv4DnhXlM82b1vvobH2cAHt7BOzmjzL7DGsYcboVOOFQGkl59rjQz6gIjfIbRsfI
         rO2ICnw3WwNqjE92BYCdHjPNCXp69aAnzMQ1ls+MVE8FGuVZqaDFrC36IArIfPFYiC
         pVOSSOKPXXkpA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "kaixi.fan" <fankaixi.li@bytedance.com>,
        xiexiaohui <xiexiaohui.xxh@bytedance.com>,
        Cong Wang <cong.wang@bytedance.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 068/127] ovs: clear skb->tstamp in forwarding path
Date:   Tue, 24 Aug 2021 12:55:08 -0400
Message-Id: <20210824165607.709387-69-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210824165607.709387-1-sashal@kernel.org>
References: <20210824165607.709387-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.13.13-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.13.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.13.13-rc1
X-KernelTest-Deadline: 2021-08-26T16:55+00:00
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
index 88deb5b41429..cf2ce5812489 100644
--- a/net/openvswitch/vport.c
+++ b/net/openvswitch/vport.c
@@ -507,6 +507,7 @@ void ovs_vport_send(struct vport *vport, struct sk_buff *skb, u8 mac_proto)
 	}
 
 	skb->dev = vport->dev;
+	skb->tstamp = 0;
 	vport->ops->send(skb);
 	return;
 
-- 
2.30.2

