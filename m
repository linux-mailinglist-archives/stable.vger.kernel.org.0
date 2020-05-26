Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 256001E1AB3
	for <lists+stable@lfdr.de>; Tue, 26 May 2020 07:28:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725959AbgEZF2v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 May 2020 01:28:51 -0400
Received: from mga05.intel.com ([192.55.52.43]:37666 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725771AbgEZF2u (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 26 May 2020 01:28:50 -0400
IronPort-SDR: R2KPo5WOs7BOqmxknrE1BqnD6MeX6wez7QPVTNsYoy4PeRLXOP8RzxKaRRTlZtLqCpUmQ884iA
 mrTxho32bMyw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 May 2020 22:28:50 -0700
IronPort-SDR: PXyP/aEXuYvGVakR4IXAMHD2zuHe9IytR1+X3zCVrRkeyj65kZoSgTG/yPOHnW3ORzNr76Qq3V
 TYIDCPiYbDwQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,436,1583222400"; 
   d="scan'208";a="266334379"
Received: from tassilo.jf.intel.com (HELO tassilo.localdomain) ([10.7.201.21])
  by orsmga003.jf.intel.com with ESMTP; 25 May 2020 22:28:50 -0700
Received: by tassilo.localdomain (Postfix, from userid 1000)
        id F2932301C5E; Mon, 25 May 2020 22:28:49 -0700 (PDT)
From:   Andi Kleen <andi@firstfloor.org>
To:     x86@kernel.org
Cc:     keescook@chromium.org, linux-kernel@vger.kernel.org,
        sashal@kernel.org, Andi Kleen <ak@linux.intel.com>,
        stable@vger.kernel.org
Subject: [PATCH v1] x86: Pin cr4 FSGSBASE
Date:   Mon, 25 May 2020 22:28:48 -0700
Message-Id: <20200526052848.605423-1-andi@firstfloor.org>
X-Mailer: git-send-email 2.25.4
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

Since there seem to be kernel modules floating around that set
FSGSBASE incorrectly, prevent this in the CR4 pinning. Currently
CR4 pinning just checks that bits are set, this also checks
that the FSGSBASE bit is not set, and if it is clears it again.

Note this patch will need to be undone when the full FSGSBASE
patches are merged. But it's a reasonable solution for v5.2+
stable at least. Sadly the older kernels don't have the necessary
infrastructure for this (although a simpler version of this
could be added there too)

Cc: stable@vger.kernel.org # v5.2+
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 arch/x86/kernel/cpu/common.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index bed0cb83fe24..1f5b7871ae9a 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -385,6 +385,11 @@ void native_write_cr4(unsigned long val)
 		/* Warn after we've set the missing bits. */
 		WARN_ONCE(bits_missing, "CR4 bits went missing: %lx!?\n",
 			  bits_missing);
+		if (val & X86_CR4_FSGSBASE) {
+			WARN_ONCE(1, "CR4 unexpectedly set FSGSBASE!?\n");
+			val &= ~X86_CR4_FSGSBASE;
+			goto set_register;
+		}
 	}
 }
 EXPORT_SYMBOL(native_write_cr4);
-- 
2.25.4

