Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23DAB2E3D56
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:15:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2440380AbgL1OO0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:14:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:49354 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2440405AbgL1OOZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:14:25 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6F511207A9;
        Mon, 28 Dec 2020 14:13:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609164825;
        bh=Sf2ERPWxygFs6awfkr+YQBBjETZGTP56ffahybQ6ZnI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fAUfw4XwpeauKywC8/XU1Q/0jYGgKY4SFsWx2/NUAcZuC/epVLbDSBESroxBK4WWq
         AEFY/DNo/2j1Jzd27AnVNbTcjW21pIynSAM4lrIMvdOLnU12GRJ2uBUuwpzRvsrJY8
         o1noxLcXIYIKGHE39CPW2lbjXfRku/Z341kaLRHk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Ravi Bangoria <ravi.bangoria@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 281/717] powerpc/xmon: Fix build failure for 8xx
Date:   Mon, 28 Dec 2020 13:44:39 +0100
Message-Id: <20201228125034.488748161@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ravi Bangoria <ravi.bangoria@linux.ibm.com>

[ Upstream commit f3e90408019b353fd1fcd338091fb8d3c4a1c1a5 ]

With CONFIG_PPC_8xx and CONFIG_XMON set, kernel build fails with

  arch/powerpc/xmon/xmon.c:1379:12: error: 'find_free_data_bpt' defined
  but not used [-Werror=unused-function]

Fix it by enclosing find_free_data_bpt() inside #ifndef CONFIG_PPC_8xx.

Fixes: 30df74d67d48 ("powerpc/watchpoint/xmon: Support 2nd DAWR")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Ravi Bangoria <ravi.bangoria@linux.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20201130034406.288047-1-ravi.bangoria@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/xmon/xmon.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/powerpc/xmon/xmon.c b/arch/powerpc/xmon/xmon.c
index 55c43a6c91112..5559edf36756c 100644
--- a/arch/powerpc/xmon/xmon.c
+++ b/arch/powerpc/xmon/xmon.c
@@ -1383,6 +1383,7 @@ static long check_bp_loc(unsigned long addr)
 	return 1;
 }
 
+#ifndef CONFIG_PPC_8xx
 static int find_free_data_bpt(void)
 {
 	int i;
@@ -1394,6 +1395,7 @@ static int find_free_data_bpt(void)
 	printf("Couldn't find free breakpoint register\n");
 	return -1;
 }
+#endif
 
 static void print_data_bpts(void)
 {
-- 
2.27.0



