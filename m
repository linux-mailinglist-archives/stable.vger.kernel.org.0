Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 989BF17206F
	for <lists+stable@lfdr.de>; Thu, 27 Feb 2020 15:43:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731159AbgB0Omw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Feb 2020 09:42:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:47432 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731095AbgB0Ntq (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 27 Feb 2020 08:49:46 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 486B020578;
        Thu, 27 Feb 2020 13:49:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582811385;
        bh=bsY2Ez2fjYKqL4INXHo6t0AnfkI2oIAHfv+cfuoZhC0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HN0CHcj0Dpjg8axcInQ46d3YhfMWR4dfFhlLrY+xrNObORIdp0izqLmMkG+gKfOTI
         QzYRrbCKRZiOwB/f9kovd9KZ1J8J17vS+Rh7JRq/tgmWZkUQVQZ7byNpMaXchjdHj6
         mwYev9aR+EdIx/UJJJcWOaEJuCA5z01QN1+m7sgI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Shubhrajyoti Datta <shubhrajyoti.datta@xilinx.com>,
        Michal Simek <michal.simek@xilinx.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 112/165] microblaze: Prevent the overflow of the start
Date:   Thu, 27 Feb 2020 14:36:26 +0100
Message-Id: <20200227132247.488651715@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200227132230.840899170@linuxfoundation.org>
References: <20200227132230.840899170@linuxfoundation.org>
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



