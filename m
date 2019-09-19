Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C8A4AB8630
	for <lists+stable@lfdr.de>; Fri, 20 Sep 2019 00:27:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406661AbfISWVA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Sep 2019 18:21:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:35228 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405537AbfISWU5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Sep 2019 18:20:57 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 584F621927;
        Thu, 19 Sep 2019 22:20:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568931656;
        bh=fSg4w60wGc2fe1to3ZNBO/o5AAysdACtKnyKU+ecgZ0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Mp4/gN+sgWMAh3HXPbM1WxoszUvgsiZqnbQyPnL2siFfy9w169blPWQ22PY2mmE+u
         ncRwRC7P8B2BfC55AoNJoiTcE20EQxjV2GrVf5EhUOWEhgEVoQRzhfDLRPl92fN8ni
         TxjSi2XEWEUZJxMVbwORFTl5iYY9m4O1Of6I2Wtg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Len Brown <len.brown@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 65/74] tools/power turbostat: fix buffer overrun
Date:   Fri, 20 Sep 2019 00:04:18 +0200
Message-Id: <20190919214810.836446342@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190919214800.519074117@linuxfoundation.org>
References: <20190919214800.519074117@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index b4c5d96e54c12..7c2c8e74aa9a9 100644
--- a/tools/power/x86/turbostat/turbostat.c
+++ b/tools/power/x86/turbostat/turbostat.c
@@ -3593,7 +3593,7 @@ int initialize_counters(int cpu_id)
 
 void allocate_output_buffer()
 {
-	output_buffer = calloc(1, (1 + topo.num_cpus) * 1024);
+	output_buffer = calloc(1, (1 + topo.num_cpus) * 2048);
 	outp = output_buffer;
 	if (outp == NULL)
 		err(-1, "calloc output buffer");
-- 
2.20.1



