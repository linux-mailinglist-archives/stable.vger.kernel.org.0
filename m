Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6265D1134D9
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 19:28:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729240AbfLDS0N (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Dec 2019 13:26:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:37616 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728784AbfLDR77 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Dec 2019 12:59:59 -0500
Received: from localhost (unknown [217.68.49.72])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0DF1C20675;
        Wed,  4 Dec 2019 17:59:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575482399;
        bh=884x5ShrfFbzeDpMRlDucGW/FgT0RTwPFiSeSuVL/Xw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J921b+PQKApR+yg1dnCF7oYfJkbOrpHmMI6Wj8XG0RbVm9vQBSoyDqwkD1PENMyHc
         882CelFqFNvwsm1o9JZ/Qo95Y8RtyyN6VduTTh8/cR5/yyWBKcA/yb+ZX8JSly+xeR
         ke3AK6BJJqgr0DuU/TKshSQ3belzEmMlXtc0670M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 71/92] net: dev: Use unsigned integer as an argument to left-shift
Date:   Wed,  4 Dec 2019 18:50:11 +0100
Message-Id: <20191204174334.568891601@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191204174327.215426506@linuxfoundation.org>
References: <20191204174327.215426506@linuxfoundation.org>
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
index 0b211d482c961..861b71377e5e1 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -3298,7 +3298,7 @@ static inline u32 netif_msg_init(int debug_value, int default_msg_enable_bits)
 	if (debug_value == 0)	/* no output */
 		return 0;
 	/* set low N bits */
-	return (1 << debug_value) - 1;
+	return (1U << debug_value) - 1;
 }
 
 static inline void __netif_tx_lock(struct netdev_queue *txq, int cpu)
-- 
2.20.1



