Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D1724524FA
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 02:43:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232391AbhKPBqV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 20:46:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:35522 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241538AbhKOSWf (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 13:22:35 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BA40E63416;
        Mon, 15 Nov 2021 17:53:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636998794;
        bh=L7NEpTlyYyiobl5GSjv62Sk7HZv4zLiUjSV4LlnqAJw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ByQ1tMQ6gBJGpnDbzRsN7pK3hqznLg4ulVjLpXW9fc/kCa0eKuelTmbvBODecZRME
         b9ygfQEHLnOvX+/fu4HiSrPZfDeJVgccPf/MWJcy01O5fn7CAQ9lNEFf3p7tfclSqR
         FzW+HTfs2EgartTCq1wiKxOJE/rlbRYliksosAaA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zheyu Ma <zheyuma97@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 063/849] cavium: Return negative value when pci_alloc_irq_vectors() fails
Date:   Mon, 15 Nov 2021 17:52:26 +0100
Message-Id: <20211115165422.164597259@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165419.961798833@linuxfoundation.org>
References: <20211115165419.961798833@linuxfoundation.org>
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
index 9361f964bb9b2..816453a4f8d6c 100644
--- a/drivers/net/ethernet/cavium/thunder/nic_main.c
+++ b/drivers/net/ethernet/cavium/thunder/nic_main.c
@@ -1193,7 +1193,7 @@ static int nic_register_interrupts(struct nicpf *nic)
 		dev_err(&nic->pdev->dev,
 			"Request for #%d msix vectors failed, returned %d\n",
 			   nic->num_vec, ret);
-		return 1;
+		return ret;
 	}
 
 	/* Register mailbox interrupt handler */
-- 
2.33.0



