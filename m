Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4872020157A
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 18:23:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390623AbgFSQWc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 12:22:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:56436 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390612AbgFSPAG (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 11:00:06 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5231B218AC;
        Fri, 19 Jun 2020 15:00:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592578806;
        bh=IOZWJSLAfCXni2wXh/hljcXuStlMCsfYOW6iECGONUk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fTpzx+v8nVLagEsaPVVCZKhemkiOs1TLeO5+WZjvG/ODZJtPoNXituJ6AbJViKTh/
         FX5Kc3HaTTTuNh4VBetD3+kHAmrLrEPRqj8sGTdAcLj5mRXOiPBNKIxpRbO6AiKyuS
         DOb4cmY0BQeC3y+P5HQeiE4Jyq28ZvE1Lwd1UhDk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Alexey Malahov <Alexey.Malahov@baikalelectronics.ru>,
        Serge Semin <Sergey.Semin@baikalelectronics.ru>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Paul Burton <paulburton@kernel.org>,
        Ralf Baechle <ralf@linux-mips.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 164/267] mips: MAAR: Use more precise address mask
Date:   Fri, 19 Jun 2020 16:32:29 +0200
Message-Id: <20200619141656.668826999@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141648.840376470@linuxfoundation.org>
References: <20200619141648.840376470@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 1bb9448777c5..f9a7c137be9f 100644
--- a/arch/mips/include/asm/mipsregs.h
+++ b/arch/mips/include/asm/mipsregs.h
@@ -749,7 +749,7 @@
 
 /* MAAR bit definitions */
 #define MIPS_MAAR_VH		(_U64CAST_(1) << 63)
-#define MIPS_MAAR_ADDR		((BIT_ULL(BITS_PER_LONG - 12) - 1) << 12)
+#define MIPS_MAAR_ADDR		GENMASK_ULL(55, 12)
 #define MIPS_MAAR_ADDR_SHIFT	12
 #define MIPS_MAAR_S		(_ULCAST_(1) << 1)
 #define MIPS_MAAR_VL		(_ULCAST_(1) << 0)
-- 
2.25.1



