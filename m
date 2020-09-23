Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF84C275685
	for <lists+stable@lfdr.de>; Wed, 23 Sep 2020 12:41:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726419AbgIWKlV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Sep 2020 06:41:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726130AbgIWKlV (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Sep 2020 06:41:21 -0400
X-Greylist: delayed 471 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 23 Sep 2020 03:41:20 PDT
Received: from vultr.net.flygoat.com (vultr.net.flygoat.com [IPv6:2001:19f0:6001:3633:5400:2ff:fe8c:553])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1195C0613CE;
        Wed, 23 Sep 2020 03:41:20 -0700 (PDT)
Received: from localhost.localdomain (unknown [IPv6:2001:da8:20f:4430:250:56ff:fe9a:7470])
        by vultr.net.flygoat.com (Postfix) with ESMTPSA id 41176200E0;
        Wed, 23 Sep 2020 10:33:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=flygoat.com; s=vultr;
        t=1600857208; bh=uHQfasNA1XFcYr/xwx522TWpQM1A3Ga0OYLOoxt3Xtg=;
        h=From:To:Cc:Subject:Date:From;
        b=YTrRJynwsyCkysTLzOEc9Yel/jb6x1d+bGYDmLgh3Wde6G9y4A8TFyxvQGZoRyluR
         dnyW9OL0nB/f2rVMXGbFaHCRVGd1ypcjiAv66JyG35nIMgISMguuxPx+Jh2Qsf+c+e
         Pkfs6P5HQdCBjFY1YGlPbNLVGKBOcQST2983E/6mjbPJW+JIM7nEjQTgS/NmnRW6pc
         CZCYLXgtTUOXJX7WOJm2LWK2djLCxkyVK6Cd72kFDiyo+fse5EO9LBJUo4fKdKbNYE
         7cFPO5E4wiOY4ihU3afW2z1T4Od+XVnDyz463NrB0F44HxsPdNcKwInAmF9TMK9z2I
         FI2B7a1iK0L4w==
From:   Jiaxun Yang <jiaxun.yang@flygoat.com>
To:     linux-mips@vger.kernel.org
Cc:     Jiaxun Yang <jiaxun.yang@flygoat.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        stable@vger.kernel.org, Paul Burton <paulburton@kernel.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH] MIPS: Loongson2ef: Disable Loongson MMI instructions
Date:   Wed, 23 Sep 2020 18:33:12 +0800
Message-Id: <20200923103312.55507-1-jiaxun.yang@flygoat.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

It was missed when I was forking Loongson2ef from Loongson64 but
should be applied to Loongson2ef as march=loongson2f
will also enable Loongson MMI in GCC-9+.

Signed-off-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
Fixes: 71e2f4dd5a65 ("MIPS: Fork loongson2ef from loongson64")
Reported-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: stable@vger.kernel.org # v5.8+
---
 arch/mips/loongson2ef/Platform | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/mips/loongson2ef/Platform b/arch/mips/loongson2ef/Platform
index 4ab55f1123a0..ae023b9a1c51 100644
--- a/arch/mips/loongson2ef/Platform
+++ b/arch/mips/loongson2ef/Platform
@@ -44,6 +44,10 @@ ifdef CONFIG_CPU_LOONGSON2F_WORKAROUNDS
   endif
 endif
 
+# Some -march= flags enable MMI instructions, and GCC complains about that
+# support being enabled alongside -msoft-float. Thus explicitly disable MMI.
+cflags-y += $(call cc-option,-mno-loongson-mmi)
+
 #
 # Loongson Machines' Support
 #
-- 
2.28.0

