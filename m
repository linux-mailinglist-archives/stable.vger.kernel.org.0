Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 66010167530
	for <lists+stable@lfdr.de>; Fri, 21 Feb 2020 09:30:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388658AbgBUIY1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Feb 2020 03:24:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:36912 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729774AbgBUIY0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 21 Feb 2020 03:24:26 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D3A58206ED;
        Fri, 21 Feb 2020 08:24:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582273466;
        bh=bsY2Ez2fjYKqL4INXHo6t0AnfkI2oIAHfv+cfuoZhC0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tsAdHtfE2jGGFgkhE5r7lnafBmoOuDF+yF3PjUXK0KB5yUYlTBIwZBSLozQMp1Zcf
         BFp6QDWKwDkMkN2ln/miU7JgtqpR0c1qoaD4KGVSpvTyQl1f1YwXIBdCCdZfaWXhLq
         1Qrb30768XvveXkUvbvYfrEyRxAra+haB/Pebin4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Shubhrajyoti Datta <shubhrajyoti.datta@xilinx.com>,
        Michal Simek <michal.simek@xilinx.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 182/191] microblaze: Prevent the overflow of the start
Date:   Fri, 21 Feb 2020 08:42:35 +0100
Message-Id: <20200221072312.635260580@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200221072250.732482588@linuxfoundation.org>
References: <20200221072250.732482588@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shubhrajyoti Datta <shubhrajyoti.datta@xilinx.com>

[ Upstream commit 061d2c1d593076424c910cb1b64ecdb5c9a6923f ]

In case the start + cache size is more than the max int the
start overflows.
Prevent the same.

Signed-off-by: Shubhrajyoti Datta <shubhrajyoti.datta@xilinx.com>
Signed-off-by: Michal Simek <michal.simek@xilinx.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/microblaze/kernel/cpu/cache.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/microblaze/kernel/cpu/cache.c b/arch/microblaze/kernel/cpu/cache.c
index 0bde47e4fa694..dcba53803fa5f 100644
--- a/arch/microblaze/kernel/cpu/cache.c
+++ b/arch/microblaze/kernel/cpu/cache.c
@@ -92,7 +92,8 @@ static inline void __disable_dcache_nomsr(void)
 #define CACHE_LOOP_LIMITS(start, end, cache_line_length, cache_size)	\
 do {									\
 	int align = ~(cache_line_length - 1);				\
-	end = min(start + cache_size, end);				\
+	if (start <  UINT_MAX - cache_size)				\
+		end = min(start + cache_size, end);			\
 	start &= align;							\
 } while (0)
 
-- 
2.20.1



