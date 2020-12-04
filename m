Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CF222CF7A9
	for <lists+stable@lfdr.de>; Sat,  5 Dec 2020 00:45:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730674AbgLDXoC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Dec 2020 18:44:02 -0500
Received: from mx2.suse.de ([195.135.220.15]:55674 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725847AbgLDXoB (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 4 Dec 2020 18:44:01 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 8F7CCACC0;
        Fri,  4 Dec 2020 23:28:26 +0000 (UTC)
From:   Michal Suchanek <msuchanek@suse.de>
To:     stable@vger.kernel.org
Cc:     Michal Suchanek <msuchanek@suse.de>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: [PATCH] powerpc: Stop exporting __clear_user which is now inlined.
Date:   Sat,  5 Dec 2020 00:28:07 +0100
Message-Id: <20201204232807.31887-1-msuchanek@suse.de>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Stable commit 452e2a83ea23 ("powerpc: Fix __clear_user() with KUAP
enabled") redefines __clear_user as inline function but does not remove
the export.

Fixes: 452e2a83ea23 ("powerpc: Fix __clear_user() with KUAP enabled")

Signed-off-by: Michal Suchanek <msuchanek@suse.de>
---
 arch/powerpc/lib/ppc_ksyms.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/powerpc/lib/ppc_ksyms.c b/arch/powerpc/lib/ppc_ksyms.c
index c7f8e9586316..4b81fd96aa3e 100644
--- a/arch/powerpc/lib/ppc_ksyms.c
+++ b/arch/powerpc/lib/ppc_ksyms.c
@@ -24,7 +24,6 @@ EXPORT_SYMBOL(csum_tcpudp_magic);
 #endif
 
 EXPORT_SYMBOL(__copy_tofrom_user);
-EXPORT_SYMBOL(__clear_user);
 EXPORT_SYMBOL(copy_page);
 
 #ifdef CONFIG_PPC64
-- 
2.26.2

