Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB86F24AB53
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 02:09:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727982AbgHTACo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Aug 2020 20:02:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:59726 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727971AbgHTACl (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 19 Aug 2020 20:02:41 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BCE0420FC3;
        Thu, 20 Aug 2020 00:02:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597881761;
        bh=cBWRrPXAZq+OpXD8QP6SeV0mkgjHFxpB8eaf/FyXlsA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=D5B1hwz+RaotMcosuH5f4v7r4q3sdjd6PDm1glPS8dq1lxZxvW/VwzesnmJ9/O0R7
         5M8IGKFg9qRYcpXUOQFuQRP9y7SHCpveVF08VhwXH5qjZI1zP18uV+b3i+phHIPrWR
         Jp90i10L0ZOuWtFjA/qKcHDRkEMkRJ5+dWFNcBW8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Ungerer <gerg@linux-m68k.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-m68k@lists.linux-m68k.org
Subject: [PATCH AUTOSEL 5.4 08/22] m68knommu: fix overwriting of bits in ColdFire V3 cache control
Date:   Wed, 19 Aug 2020 20:02:15 -0400
Message-Id: <20200820000229.215333-8-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200820000229.215333-1-sashal@kernel.org>
References: <20200820000229.215333-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Ungerer <gerg@linux-m68k.org>

[ Upstream commit bdee0e793cea10c516ff48bf3ebb4ef1820a116b ]

The Cache Control Register (CACR) of the ColdFire V3 has bits that
control high level caching functions, and also enable/disable the use
of the alternate stack pointer register (the EUSP bit) to provide
separate supervisor and user stack pointer registers. The code as
it is today will blindly clear the EUSP bit on cache actions like
invalidation. So it is broken for this case - and that will result
in failed booting (interrupt entry and exit processing will be
completely hosed).

This only affects ColdFire V3 parts that support the alternate stack
register (like the 5329 for example) - generally speaking new parts do,
older parts don't. It has no impact on ColdFire V3 parts with the single
stack pointer, like the 5307 for example.

Fix the cache bit defines used, so they maintain the EUSP bit when
carrying out cache actions through the CACR register.

Signed-off-by: Greg Ungerer <gerg@linux-m68k.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/m68k/include/asm/m53xxacr.h | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/m68k/include/asm/m53xxacr.h b/arch/m68k/include/asm/m53xxacr.h
index 9138a624c5c81..692f90e7fecc1 100644
--- a/arch/m68k/include/asm/m53xxacr.h
+++ b/arch/m68k/include/asm/m53xxacr.h
@@ -89,9 +89,9 @@
  * coherency though in all cases. And for copyback caches we will need
  * to push cached data as well.
  */
-#define CACHE_INIT	  CACR_CINVA
-#define CACHE_INVALIDATE  CACR_CINVA
-#define CACHE_INVALIDATED CACR_CINVA
+#define CACHE_INIT        (CACHE_MODE + CACR_CINVA - CACR_EC)
+#define CACHE_INVALIDATE  (CACHE_MODE + CACR_CINVA)
+#define CACHE_INVALIDATED (CACHE_MODE + CACR_CINVA)
 
 #define ACR0_MODE	((CONFIG_RAMBASE & 0xff000000) + \
 			 (0x000f0000) + \
-- 
2.25.1

