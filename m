Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F07945BC7D
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 13:28:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244772AbhKXMbF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 07:31:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:42362 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343540AbhKXM3R (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 07:29:17 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5C1D66128B;
        Wed, 24 Nov 2021 12:17:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637756252;
        bh=Oy3xvQNTd6mpdQ0Tztw+G8FAmNyt3qnTliCpxN9/zX0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GCQ7fXWyXqdnx8ki+lnov2Kk8NJIQGa8Jlczcib98t1uxWWIjgyRV3kpEuA6EL+LZ
         iJMFRRdz70z6GkOQ6mCFOVTmpFit9ES+8vih73Bd6EYHZ2biz8nHwnppcXc1gHsg8F
         RiM5rM6YQiswpX2HFmL79jsVrhEwdkulTY/qzJY8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zheyu Ma <zheyuma97@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 020/251] cavium: Return negative value when pci_alloc_irq_vectors() fails
Date:   Wed, 24 Nov 2021 12:54:22 +0100
Message-Id: <20211124115710.939629536@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115710.214900256@linuxfoundation.org>
References: <20211124115710.214900256@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zheyu Ma <zheyuma97@gmail.com>

[ Upstream commit b2cddb44bddc1a9c5949a978bb454bba863264db ]

During the process of driver probing, the probe function should return < 0
for failure, otherwise, the kernel will treat value > 0 as success.

Signed-off-by: Zheyu Ma <zheyuma97@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/cavium/thunder/nic_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/cavium/thunder/nic_main.c b/drivers/net/ethernet/cavium/thunder/nic_main.c
index 819f38a3225db..7f8ea16ad0d0a 100644
--- a/drivers/net/ethernet/cavium/thunder/nic_main.c
+++ b/drivers/net/ethernet/cavium/thunder/nic_main.c
@@ -1128,7 +1128,7 @@ static int nic_register_interrupts(struct nicpf *nic)
 		dev_err(&nic->pdev->dev,
 			"Request for #%d msix vectors failed, returned %d\n",
 			   nic->num_vec, ret);
-		return 1;
+		return ret;
 	}
 
 	/* Register mailbox interrupt handler */
-- 
2.33.0



