Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE8EF1F29C7
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 02:05:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731206AbgFHXVm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jun 2020 19:21:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:45936 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731200AbgFHXVm (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jun 2020 19:21:42 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8327020842;
        Mon,  8 Jun 2020 23:21:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591658501;
        bh=HXy9QkS4DekEeRywjSWFzBjwCqscsZtP1slMzTKcyMU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G1COJ0fXv2w1eFX5Z8oujBQ8Yn7/+GmJNmiSAmt4gAqiGI6DhV7EHMrGsT9eJ63Rg
         nFzz2ybafH1IHnGQ+rakwew1AA7k8nMMw0JMp14yzElKPvAuRTsvKRj6rRookH05da
         esxvYckb6D7jNBozlaBsva6Juyqwrc7A6mOe6rNI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Serge Semin <Sergey.Semin@baikalelectronics.ru>,
        Alexey Malahov <Alexey.Malahov@baikalelectronics.ru>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Paul Burton <paulburton@kernel.org>,
        Ralf Baechle <ralf@linux-mips.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org,
        Sasha Levin <sashal@kernel.org>, linux-mips@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 133/175] mips: MAAR: Use more precise address mask
Date:   Mon,  8 Jun 2020 19:18:06 -0400
Message-Id: <20200608231848.3366970-133-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608231848.3366970-1-sashal@kernel.org>
References: <20200608231848.3366970-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Serge Semin <Sergey.Semin@baikalelectronics.ru>

[ Upstream commit bbb5946eb545fab8ad8f46bce8a803e1c0c39d47 ]

Indeed according to the MIPS32 Privileged Resource Architecgture the MAAR
pair register address field either takes [12:31] bits for non-XPA systems
and [12:55] otherwise. In any case the current address mask is just
wrong for 64-bit and 32-bits XPA chips. So lets extend it to 59-bits
of physical address value. This shall cover the 64-bits architecture and
systems with XPA enabled, and won't cause any problem for non-XPA 32-bit
systems, since address values exceeding the architecture specific MAAR
mask will be just truncated with setting zeros in the unsupported upper
bits.

Co-developed-by: Alexey Malahov <Alexey.Malahov@baikalelectronics.ru>
Signed-off-by: Alexey Malahov <Alexey.Malahov@baikalelectronics.ru>
Signed-off-by: Serge Semin <Sergey.Semin@baikalelectronics.ru>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: Paul Burton <paulburton@kernel.org>
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Rob Herring <robh+dt@kernel.org>
Cc: devicetree@vger.kernel.org
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/include/asm/mipsregs.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/mips/include/asm/mipsregs.h b/arch/mips/include/asm/mipsregs.h
index bdbdc19a2b8f..3afdb39d092a 100644
--- a/arch/mips/include/asm/mipsregs.h
+++ b/arch/mips/include/asm/mipsregs.h
@@ -750,7 +750,7 @@
 
 /* MAAR bit definitions */
 #define MIPS_MAAR_VH		(_U64CAST_(1) << 63)
-#define MIPS_MAAR_ADDR		((BIT_ULL(BITS_PER_LONG - 12) - 1) << 12)
+#define MIPS_MAAR_ADDR		GENMASK_ULL(55, 12)
 #define MIPS_MAAR_ADDR_SHIFT	12
 #define MIPS_MAAR_S		(_ULCAST_(1) << 1)
 #define MIPS_MAAR_VL		(_ULCAST_(1) << 0)
-- 
2.25.1

