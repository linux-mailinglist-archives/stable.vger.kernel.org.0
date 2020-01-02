Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 564D912F156
	for <lists+stable@lfdr.de>; Thu,  2 Jan 2020 23:59:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727734AbgABWNj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jan 2020 17:13:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:53572 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727428AbgABWNi (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 Jan 2020 17:13:38 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8CC7521D7D;
        Thu,  2 Jan 2020 22:13:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578003218;
        bh=FfGRDsOa077Vrq/0aEEXxJBym2aW9dkpdNIfmIGUXtg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dChddzFOzPe5sJFL6YqiTK0BdIm6xLOS7h95vcAoUGSvbLV/M5rmTMYmwdSvsdVoY
         12Nw6itxlacOoh9PUh2OfOoDThamdawXp1rIt3iBd3d55bvGz4PPyi//xpGqyGKSyF
         xRv0qfjYvqeOX1NOpapnmsAkIoseeBOMg2OGi6vU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Gustavo L. F. Walbon" <gwalbon@linux.ibm.com>,
        "Mauro S. M. Rodrigues" <maurosr@linux.vnet.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 069/191] powerpc/security: Fix wrong message when RFI Flush is disable
Date:   Thu,  2 Jan 2020 23:05:51 +0100
Message-Id: <20200102215837.338429804@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200102215829.911231638@linuxfoundation.org>
References: <20200102215829.911231638@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gustavo L. F. Walbon <gwalbon@linux.ibm.com>

[ Upstream commit 4e706af3cd8e1d0503c25332b30cad33c97ed442 ]

The issue was showing "Mitigation" message via sysfs whatever the
state of "RFI Flush", but it should show "Vulnerable" when it is
disabled.

If you have "L1D private" feature enabled and not "RFI Flush" you are
vulnerable to meltdown attacks.

"RFI Flush" is the key feature to mitigate the meltdown whatever the
"L1D private" state.

SEC_FTR_L1D_THREAD_PRIV is a feature for Power9 only.

So the message should be as the truth table shows:

  CPU | L1D private | RFI Flush |                sysfs
  ----|-------------|-----------|-------------------------------------
   P9 |    False    |   False   | Vulnerable
   P9 |    False    |   True    | Mitigation: RFI Flush
   P9 |    True     |   False   | Vulnerable: L1D private per thread
   P9 |    True     |   True    | Mitigation: RFI Flush, L1D private per thread
   P8 |    False    |   False   | Vulnerable
   P8 |    False    |   True    | Mitigation: RFI Flush

Output before this fix:
  # cat /sys/devices/system/cpu/vulnerabilities/meltdown
  Mitigation: RFI Flush, L1D private per thread
  # echo 0 > /sys/kernel/debug/powerpc/rfi_flush
  # cat /sys/devices/system/cpu/vulnerabilities/meltdown
  Mitigation: L1D private per thread

Output after fix:
  # cat /sys/devices/system/cpu/vulnerabilities/meltdown
  Mitigation: RFI Flush, L1D private per thread
  # echo 0 > /sys/kernel/debug/powerpc/rfi_flush
  # cat /sys/devices/system/cpu/vulnerabilities/meltdown
  Vulnerable: L1D private per thread

Signed-off-by: Gustavo L. F. Walbon <gwalbon@linux.ibm.com>
Signed-off-by: Mauro S. M. Rodrigues <maurosr@linux.vnet.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20190502210907.42375-1-gwalbon@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kernel/security.c | 16 ++++++----------
 1 file changed, 6 insertions(+), 10 deletions(-)

diff --git a/arch/powerpc/kernel/security.c b/arch/powerpc/kernel/security.c
index 298a2e3ad6f4..d341b464f23c 100644
--- a/arch/powerpc/kernel/security.c
+++ b/arch/powerpc/kernel/security.c
@@ -142,26 +142,22 @@ ssize_t cpu_show_meltdown(struct device *dev, struct device_attribute *attr, cha
 
 	thread_priv = security_ftr_enabled(SEC_FTR_L1D_THREAD_PRIV);
 
-	if (rfi_flush || thread_priv) {
+	if (rfi_flush) {
 		struct seq_buf s;
 		seq_buf_init(&s, buf, PAGE_SIZE - 1);
 
-		seq_buf_printf(&s, "Mitigation: ");
-
-		if (rfi_flush)
-			seq_buf_printf(&s, "RFI Flush");
-
-		if (rfi_flush && thread_priv)
-			seq_buf_printf(&s, ", ");
-
+		seq_buf_printf(&s, "Mitigation: RFI Flush");
 		if (thread_priv)
-			seq_buf_printf(&s, "L1D private per thread");
+			seq_buf_printf(&s, ", L1D private per thread");
 
 		seq_buf_printf(&s, "\n");
 
 		return s.len;
 	}
 
+	if (thread_priv)
+		return sprintf(buf, "Vulnerable: L1D private per thread\n");
+
 	if (!security_ftr_enabled(SEC_FTR_L1D_FLUSH_HV) &&
 	    !security_ftr_enabled(SEC_FTR_L1D_FLUSH_PR))
 		return sprintf(buf, "Not affected\n");
-- 
2.20.1



