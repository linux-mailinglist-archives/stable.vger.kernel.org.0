Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6014F20D9B8
	for <lists+stable@lfdr.de>; Mon, 29 Jun 2020 22:12:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733300AbgF2TuF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 15:50:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:47668 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732703AbgF2Tkg (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 15:40:36 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5C03E24803;
        Mon, 29 Jun 2020 15:25:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593444329;
        bh=YfelfwEUbcmCm/7aOeEl7t6zt0M79VdUgGvywh71Yzk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BJ0v7dXOU2iXSFDa4wmF344S5avXRRwtuNdcdurQG55rYPXq8Hzoh3lozWHBfsr59
         NoIVJZOljnrQ6OGyNBzrzNbPtbWwV8qYbYq8+hQc8BnFBDli0Dkpp2Q6A+0f7AZCT8
         7+M7RXtxOEDkorYAEI3zEZ49r9hnMC2BXGzxEZcI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sabrina Dubroca <sd@queasysnail.net>,
        Stefano Brivio <sbrivio@redhat.com>,
        "David S . Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 5.4 003/178] geneve: allow changing DF behavior after creation
Date:   Mon, 29 Jun 2020 11:22:28 -0400
Message-Id: <20200629152523.2494198-4-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200629152523.2494198-1-sashal@kernel.org>
References: <20200629152523.2494198-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.50-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.4.50-rc1
X-KernelTest-Deadline: 2020-07-01T15:25+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sabrina Dubroca <sd@queasysnail.net>

[ Upstream commit 56c09de347e40804fc8dad155272fb9609e0a97b ]

Currently, trying to change the DF parameter of a geneve device does
nothing:

    # ip -d link show geneve1
    14: geneve1: <snip>
        link/ether <snip>
        geneve id 1 remote 10.0.0.1 ttl auto df set dstport 6081 <snip>
    # ip link set geneve1 type geneve id 1 df unset
    # ip -d link show geneve1
    14: geneve1: <snip>
        link/ether <snip>
        geneve id 1 remote 10.0.0.1 ttl auto df set dstport 6081 <snip>

We just need to update the value in geneve_changelink.

Fixes: a025fb5f49ad ("geneve: Allow configuration of DF behaviour")
Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
Reviewed-by: Stefano Brivio <sbrivio@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/geneve.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/geneve.c b/drivers/net/geneve.c
index cac75c7d1d018..19d9d78a6df2c 100644
--- a/drivers/net/geneve.c
+++ b/drivers/net/geneve.c
@@ -1649,6 +1649,7 @@ static int geneve_changelink(struct net_device *dev, struct nlattr *tb[],
 	geneve->collect_md = metadata;
 	geneve->use_udp6_rx_checksums = use_udp6_rx_checksums;
 	geneve->ttl_inherit = ttl_inherit;
+	geneve->df = df;
 	geneve_unquiesce(geneve, gs4, gs6);
 
 	return 0;
-- 
2.25.1

