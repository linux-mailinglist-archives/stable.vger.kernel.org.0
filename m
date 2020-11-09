Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 058972ABDAB
	for <lists+stable@lfdr.de>; Mon,  9 Nov 2020 14:48:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730395AbgKINsC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 08:48:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:51178 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729451AbgKIM41 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Nov 2020 07:56:27 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7DCF121D40;
        Mon,  9 Nov 2020 12:56:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604926581;
        bh=S/XBF6RTTDB5o3OMdU/e4ivsmisnUo9csUL+fMjxRWQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pnOylXKkCoayiXsn4bVgR9/2b7xjJJGeTmSauWaCTsWKXH35Ss4zMq0omemKBHjBq
         l91lIQFMe8eG1NsOfUR/FUwGYxRJYRvx8pWi9Q1BdPJt8Hbemw44R12cQCeNY64jxM
         mclL7IvTh/mx3seaGBGD7pyRfBRvPDpl5Kq7DTbc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Oliver OHalloran <oohall@gmail.com>,
        Joel Stanley <joel@jms.id.au>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 11/86] powerpc/powernv/smp: Fix spurious DBG() warning
Date:   Mon,  9 Nov 2020 13:54:18 +0100
Message-Id: <20201109125021.403452146@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201109125020.852643676@linuxfoundation.org>
References: <20201109125020.852643676@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Oliver O'Halloran <oohall@gmail.com>

[ Upstream commit f6bac19cf65c5be21d14a0c9684c8f560f2096dd ]

When building with W=1 we get the following warning:

 arch/powerpc/platforms/powernv/smp.c: In function ‘pnv_smp_cpu_kill_self’:
 arch/powerpc/platforms/powernv/smp.c:276:16: error: suggest braces around
 	empty body in an ‘if’ statement [-Werror=empty-body]
   276 |      cpu, srr1);
       |                ^
 cc1: all warnings being treated as errors

The full context is this block:

 if (srr1 && !generic_check_cpu_restart(cpu))
 	DBG("CPU%d Unexpected exit while offline srr1=%lx!\n",
 			cpu, srr1);

When building with DEBUG undefined DBG() expands to nothing and GCC emits
the warning due to the lack of braces around an empty statement.

Signed-off-by: Oliver O'Halloran <oohall@gmail.com>
Reviewed-by: Joel Stanley <joel@jms.id.au>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20200804005410.146094-2-oohall@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/platforms/powernv/smp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/platforms/powernv/smp.c b/arch/powerpc/platforms/powernv/smp.c
index ad7b1a3dbed09..c605c78a80896 100644
--- a/arch/powerpc/platforms/powernv/smp.c
+++ b/arch/powerpc/platforms/powernv/smp.c
@@ -41,7 +41,7 @@
 #include <asm/udbg.h>
 #define DBG(fmt...) udbg_printf(fmt)
 #else
-#define DBG(fmt...)
+#define DBG(fmt...) do { } while (0)
 #endif
 
 static void pnv_smp_setup_cpu(int cpu)
-- 
2.27.0



