Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6A174A8B99
	for <lists+stable@lfdr.de>; Wed,  4 Sep 2019 21:28:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732629AbfIDQDe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Sep 2019 12:03:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:40176 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732344AbfIDQDc (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Sep 2019 12:03:32 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AD0722070C;
        Wed,  4 Sep 2019 16:03:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567613011;
        bh=VlEPEG/5/6vOlgK2tyw5SjA1y6Lt098z68Ly0L6u+/c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RWCX9O+2b5h/XVQMRc5gvImdSeqgHbKLHHYjzv7M9dzb0DXskR1dCIJV/z7G/Mdrw
         7QN2SLiDRGoWANmwtiKIEPKLWkyTKkfXXuO4UXTKMjRmp5eaQyJSKh9JBaIOT6Hl5H
         g/Hop0DKqkg8wlaz7C/um9OekBEep0Dik9guXmY8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Len Brown <len.brown@intel.com>,
        Sasha Levin <sashal@kernel.org>, linux-pm@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 19/20] tools/power turbostat: fix buffer overrun
Date:   Wed,  4 Sep 2019 12:03:02 -0400
Message-Id: <20190904160303.5062-19-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190904160303.5062-1-sashal@kernel.org>
References: <20190904160303.5062-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>

[ Upstream commit eeb71c950bc6eee460f2070643ce137e067b234c ]

turbostat could be terminated by general protection fault on some latest
hardwares which (for example) support 9 levels of C-states and show 18
"tADDED" lines. That bloats the total output and finally causes buffer
overrun.  So let's extend the buffer to avoid this.

Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Signed-off-by: Len Brown <len.brown@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/power/x86/turbostat/turbostat.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/power/x86/turbostat/turbostat.c b/tools/power/x86/turbostat/turbostat.c
index 532e7bf068689..58cf161887225 100644
--- a/tools/power/x86/turbostat/turbostat.c
+++ b/tools/power/x86/turbostat/turbostat.c
@@ -3014,7 +3014,7 @@ int initialize_counters(int cpu_id)
 
 void allocate_output_buffer()
 {
-	output_buffer = calloc(1, (1 + topo.num_cpus) * 1024);
+	output_buffer = calloc(1, (1 + topo.num_cpus) * 2048);
 	outp = output_buffer;
 	if (outp == NULL)
 		err(-1, "calloc output buffer");
-- 
2.20.1

