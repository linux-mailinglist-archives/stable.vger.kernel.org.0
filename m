Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AE647111E66
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 00:02:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728338AbfLCWzg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Dec 2019 17:55:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:50052 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730357AbfLCWzg (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Dec 2019 17:55:36 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9F94A2053B;
        Tue,  3 Dec 2019 22:55:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575413736;
        bh=moSTdx0b15r8AFXw/a0cj2pHvsjwbdBEGVmg1DcRV+o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EWCjyUstn1enZ7U66dFBd35gcTpr42Ka/vk6XBdMHLY5cY7ADpvhK7X5J6vkKpGHY
         w0KZ10z5R/Ix2TYjPQof5MWqBmoyE2RnG7Qo2BV9dZ38RveP3HfmMyZVNWBrZBXyFh
         M2u01ZqzUQr/zGRv9lcdTSpF8MpBhOgS7CcJjoLs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 241/321] net: dev: Use unsigned integer as an argument to left-shift
Date:   Tue,  3 Dec 2019 23:35:07 +0100
Message-Id: <20191203223439.679216273@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191203223427.103571230@linuxfoundation.org>
References: <20191203223427.103571230@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit f4d7b3e23d259c44f1f1c39645450680fcd935d6 ]

1 << 31 is Undefined Behaviour according to the C standard.
Use U type modifier to avoid theoretical overflow.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/netdevice.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 8c2fec0bcb265..5ada5fd9652dd 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -3790,7 +3790,7 @@ static inline u32 netif_msg_init(int debug_value, int default_msg_enable_bits)
 	if (debug_value == 0)	/* no output */
 		return 0;
 	/* set low N bits */
-	return (1 << debug_value) - 1;
+	return (1U << debug_value) - 1;
 }
 
 static inline void __netif_tx_lock(struct netdev_queue *txq, int cpu)
-- 
2.20.1



