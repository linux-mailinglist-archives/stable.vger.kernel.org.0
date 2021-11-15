Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4009845250C
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 02:43:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357587AbhKPBqh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 20:46:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:33162 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241583AbhKOSX1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 13:23:27 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A773E6327E;
        Mon, 15 Nov 2021 17:53:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636998822;
        bh=Q2vCxzNaHkcGB2ll9BfhkLx7TCnsjGRdHcxOfAwybwk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JWPAlMpNaSqYPFlMKQcwVgZdOnu1rLdmbvoLKs7hxJXECypfvJ5oqXQp6GfLOTFUj
         pwWkvYF743AQBIwWxJ1mq5qV7joACfkcWz8EoDyBepN+lAsgarXQsyFEKBwwCVD5fm
         kZMNClDNAXnBerrDDbvzvkiz/e22fbrnxUkyl8yE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zheyu Ma <zheyuma97@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 067/849] cavium: Fix return values of the probe function
Date:   Mon, 15 Nov 2021 17:52:30 +0100
Message-Id: <20211115165422.313295834@linuxfoundation.org>
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

[ Upstream commit c69b2f46876825c726bd8a97c7fa852d8932bc32 ]

During the process of driver probing, the probe function should return < 0
for failure, otherwise, the kernel will treat value > 0 as success.

Signed-off-by: Zheyu Ma <zheyuma97@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/cavium/thunder/nicvf_main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/cavium/thunder/nicvf_main.c b/drivers/net/ethernet/cavium/thunder/nicvf_main.c
index e2b290135fd97..a61107e05216c 100644
--- a/drivers/net/ethernet/cavium/thunder/nicvf_main.c
+++ b/drivers/net/ethernet/cavium/thunder/nicvf_main.c
@@ -1224,7 +1224,7 @@ static int nicvf_register_misc_interrupt(struct nicvf *nic)
 	if (ret < 0) {
 		netdev_err(nic->netdev,
 			   "Req for #%d msix vectors failed\n", nic->num_vec);
-		return 1;
+		return ret;
 	}
 
 	sprintf(nic->irq_name[irq], "%s Mbox", "NICVF");
@@ -1243,7 +1243,7 @@ static int nicvf_register_misc_interrupt(struct nicvf *nic)
 	if (!nicvf_check_pf_ready(nic)) {
 		nicvf_disable_intr(nic, NICVF_INTR_MBOX, 0);
 		nicvf_unregister_interrupts(nic);
-		return 1;
+		return -EIO;
 	}
 
 	return 0;
-- 
2.33.0



