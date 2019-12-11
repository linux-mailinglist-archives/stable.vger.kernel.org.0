Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B57BD11B0F7
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 16:27:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733130AbfLKP1d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 10:27:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:33182 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387429AbfLKP1b (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 10:27:31 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8216A2465A;
        Wed, 11 Dec 2019 15:27:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576078050;
        bh=zaE6RCXBQnl5FkCZ5vpGQAygE6wYrRNwLwPYZNFgWVo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eddn95N4at5anxm9tPOompexnbJjwV2mttv30a2FG+cBnJuq43Qxz11W7FLQiNlPB
         p7Sru22ZtY41L/8LahuTzfhGchmQoQ3Bey9sElp4K0gqwmHy4WIlw9bgGc7C6fWQtS
         LXJSeCf8KPU2VU/h+0rWUclSTRZh3bKFEk5tKuQs=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Gustavo L. F. Walbon" <gwalbon@linux.ibm.com>,
        "Mauro S . M . Rodrigues" <maurosr@linux.vnet.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 4.19 43/79] powerpc/security: Fix wrong message when RFI Flush is disable
Date:   Wed, 11 Dec 2019 10:26:07 -0500
Message-Id: <20191211152643.23056-43-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191211152643.23056-1-sashal@kernel.org>
References: <20191211152643.23056-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Gustavo L. F. Walbon" <gwalbon@linux.ibm.com>

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
index a4354c4f6bc50..6a3dde9587ccb 100644
--- a/arch/powerpc/kernel/security.c
+++ b/arch/powerpc/kernel/security.c
@@ -134,26 +134,22 @@ ssize_t cpu_show_meltdown(struct device *dev, struct device_attribute *attr, cha
 
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

