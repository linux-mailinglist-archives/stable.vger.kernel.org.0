Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0661328BD5
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 19:41:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236515AbhCASjv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 13:39:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:44972 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239915AbhCASbj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 13:31:39 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id AA6EE652FC;
        Mon,  1 Mar 2021 17:41:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614620472;
        bh=WByou/aDB0FXbiuLuZKDk4F5KwCaITLr2hXUKqyHEGk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=duXq19kLfNxRrKkQN6LB/UyTcir8mfr6rmOtTC9mXU3VGyzQqZ5JLKH1YCZ/Or9pt
         IG0MXexkMVQhUjlcTFQ8+TIzIjzDLOEctDHJ/GBloFxVYMtfNKy6U85QGpMyFlreJq
         W5uhcMv7RBHaUlRQV7TmA+fy9UrrnTm7rOaIr1mM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dany Madden <drt@linux.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 164/775] ibmvnic: change IBMVNIC_MAX_IND_DESCS to 16
Date:   Mon,  1 Mar 2021 17:05:32 +0100
Message-Id: <20210301161209.744906740@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dany Madden <drt@linux.ibm.com>

[ Upstream commit a6f2fe5f108c11ff8023d07f9c00cc3c9c3203b8 ]

The supported indirect subcrq entries on Power8 is 16. Power9
supports 128. Redefined this value to 16 to minimize the driver from
having to reset when migrating between Power9 and Power8. In our rx/tx
performance testing, we found no performance difference between 16 and
128 at this time.

Fixes: f019fb6392e5 ("ibmvnic: Introduce indirect subordinate Command Response Queue buffer")
Signed-off-by: Dany Madden <drt@linux.ibm.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/ibm/ibmvnic.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/ibm/ibmvnic.h b/drivers/net/ethernet/ibm/ibmvnic.h
index 3cccbba703658..72fea3b1c87d9 100644
--- a/drivers/net/ethernet/ibm/ibmvnic.h
+++ b/drivers/net/ethernet/ibm/ibmvnic.h
@@ -31,7 +31,7 @@
 #define IBMVNIC_BUFFS_PER_POOL	100
 #define IBMVNIC_MAX_QUEUES	16
 #define IBMVNIC_MAX_QUEUE_SZ   4096
-#define IBMVNIC_MAX_IND_DESCS  128
+#define IBMVNIC_MAX_IND_DESCS  16
 #define IBMVNIC_IND_ARR_SZ	(IBMVNIC_MAX_IND_DESCS * 32)
 
 #define IBMVNIC_TSO_BUF_SZ	65536
-- 
2.27.0



