Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4653E20E5A2
	for <lists+stable@lfdr.de>; Tue, 30 Jun 2020 00:07:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728320AbgF2Vj7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 17:39:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:60646 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728307AbgF2Sk3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 14:40:29 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CA8E923EF2;
        Mon, 29 Jun 2020 15:18:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593443906;
        bh=PPeWyYS4FCFQJSFCRFag4CcXyIoAO/wk/iRh2ObDfuA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CtHRuCCP3jaIG/tWjp4XvAH9i7bhSO2/CtnEBcXYshvbrK26DiNdva4YOpbU8c98k
         mSloObqj4X0A8I+M6PA/KH304lnHTs0EdX9vMxslDr/t7xmZiRUtEqww3kzImhKilV
         XdvlBRfa0n05nLI2FapFEaCXqgXC35fBHFQ1kuuE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Thomas Falcon <tlfalcon@linux.ibm.com>,
        "David S . Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 5.7 006/265] ibmveth: Fix max MTU limit
Date:   Mon, 29 Jun 2020 11:13:59 -0400
Message-Id: <20200629151818.2493727-7-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200629151818.2493727-1-sashal@kernel.org>
References: <20200629151818.2493727-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.7.7-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.7.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.7.7-rc1
X-KernelTest-Deadline: 2020-07-01T15:14+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Falcon <tlfalcon@linux.ibm.com>

[ Upstream commit 5948378b26d89f8aa5eac37629dbd0616ce8d7a7 ]

The max MTU limit defined for ibmveth is not accounting for
virtual ethernet buffer overhead, which is twenty-two additional
bytes set aside for the ethernet header and eight additional bytes
of an opaque handle reserved for use by the hypervisor. Update the
max MTU to reflect this overhead.

Fixes: d894be57ca92 ("ethernet: use net core MTU range checking in more drivers")
Fixes: 110447f8269a ("ethernet: fix min/max MTU typos")
Signed-off-by: Thomas Falcon <tlfalcon@linux.ibm.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/ibm/ibmveth.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/ibm/ibmveth.c b/drivers/net/ethernet/ibm/ibmveth.c
index 96d36ae5049e1..c5c732601e35e 100644
--- a/drivers/net/ethernet/ibm/ibmveth.c
+++ b/drivers/net/ethernet/ibm/ibmveth.c
@@ -1715,7 +1715,7 @@ static int ibmveth_probe(struct vio_dev *dev, const struct vio_device_id *id)
 	}
 
 	netdev->min_mtu = IBMVETH_MIN_MTU;
-	netdev->max_mtu = ETH_MAX_MTU;
+	netdev->max_mtu = ETH_MAX_MTU - IBMVETH_BUFF_OH;
 
 	memcpy(netdev->dev_addr, mac_addr_p, ETH_ALEN);
 
-- 
2.25.1

