Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A66345BF1C
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 13:52:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345914AbhKXMzU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 07:55:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:56144 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344747AbhKXMwM (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 07:52:12 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1BF7961546;
        Wed, 24 Nov 2021 12:30:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637757008;
        bh=sOvN8ReABjdKw0D76U+nIlYqWhqqkeoit7HW6S1x830=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1U3s0EYL5zNLMUIKWN+pB4OyE0oryqv1plSiBUYV20+L94D/xf5SUaJj27ZC7uLbu
         u1Ajpetm543vP8SWzVemYhplJ3XTBHtX8gzt92y1q7ZiJU9V/oxkoHxL1tWmTapMkx
         Nk2gmfV8cmOTh2z+7jxEHsFD9BSFUxEwrQVwHUsw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zheyu Ma <zheyuma97@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 026/323] cavium: Return negative value when pci_alloc_irq_vectors() fails
Date:   Wed, 24 Nov 2021 12:53:36 +0100
Message-Id: <20211124115719.755882712@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115718.822024889@linuxfoundation.org>
References: <20211124115718.822024889@linuxfoundation.org>
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
index 90497a27df184..7c0a67f1f43f7 100644
--- a/drivers/net/ethernet/cavium/thunder/nic_main.c
+++ b/drivers/net/ethernet/cavium/thunder/nic_main.c
@@ -1175,7 +1175,7 @@ static int nic_register_interrupts(struct nicpf *nic)
 		dev_err(&nic->pdev->dev,
 			"Request for #%d msix vectors failed, returned %d\n",
 			   nic->num_vec, ret);
-		return 1;
+		return ret;
 	}
 
 	/* Register mailbox interrupt handler */
-- 
2.33.0



