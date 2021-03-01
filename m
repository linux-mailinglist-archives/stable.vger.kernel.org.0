Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1302F32939A
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 22:29:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238765AbhCAV3C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 16:29:02 -0500
Received: from smtp-fw-2101.amazon.com ([72.21.196.25]:57005 "EHLO
        smtp-fw-2101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244613AbhCAVYg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Mar 2021 16:24:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1614633876; x=1646169876;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=3BUXgp0npEjwbl/+EEk/Ah6sZ5igVqCLOK20afdXmE0=;
  b=gVY1jC/49d7SaoQRrE5w8E6aqhoirJaBOw7rLiE2oGx0MZlUZdwzrGZT
   rnkZdOlAVK5NR6MKIhl5LDzfCGP3ADAskVrlVNWawMC0gJfZtaMdRIy5P
   Zo5W9vTBs8kl5+/+EiB8KTplFulP79eD3bUYdrQkp5d71SI8HqTcIVRhS
   s=;
X-IronPort-AV: E=Sophos;i="5.81,216,1610409600"; 
   d="scan'208";a="89820445"
Received: from iad12-co-svc-p1-lb1-vlan3.amazon.com (HELO email-inbound-relay-2c-397e131e.us-west-2.amazon.com) ([10.43.8.6])
  by smtp-border-fw-out-2101.iad2.amazon.com with ESMTP; 01 Mar 2021 21:23:48 +0000
Received: from EX13MTAUWB001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan3.pdx.amazon.com [10.236.137.198])
        by email-inbound-relay-2c-397e131e.us-west-2.amazon.com (Postfix) with ESMTPS id 2DFC7A06F2
        for <stable@vger.kernel.org>; Mon,  1 Mar 2021 21:23:47 +0000 (UTC)
Received: from EX13D13UWB004.ant.amazon.com (10.43.161.218) by
 EX13MTAUWB001.ant.amazon.com (10.43.161.249) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 1 Mar 2021 21:23:46 +0000
Received: from EX13MTAUWA001.ant.amazon.com (10.43.160.58) by
 EX13D13UWB004.ant.amazon.com (10.43.161.218) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Mon, 1 Mar 2021 21:23:46 +0000
Received: from dev-dsk-shaoyi-2b-c0ca772a.us-west-2.amazon.com (172.22.152.76)
 by mail-relay.amazon.com (10.43.160.118) with Microsoft SMTP Server id
 15.0.1497.2 via Frontend Transport; Mon, 1 Mar 2021 21:23:46 +0000
Received: by dev-dsk-shaoyi-2b-c0ca772a.us-west-2.amazon.com (Postfix, from userid 13116433)
        id 9940442A70; Mon,  1 Mar 2021 21:23:46 +0000 (UTC)
Date:   Mon, 1 Mar 2021 21:23:46 +0000
From:   Shaoying Xu <shaoyi@amazon.com>
To:     <stable@vger.kernel.org>
CC:     <shaoyi@amazon.com>, <fllinden@amazon.com>
Subject: [PATCH 5.4] arm64 module: set plt* section addresses to 0x0
Message-ID: <20210301212346.GA1021@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit f5c6d0fcf90ce07ee0d686d465b19b247ebd5ed7 upstream.

These plt* and .text.ftrace_trampoline sections specified for arm64 have
non-zero addressses. Non-zero section addresses in a relocatable ELF would
confuse GDB when it tries to compute the section offsets and it ends up
printing wrong symbol addresses. Therefore, set them to zero, which mirrors
the change in commit 5d8591bc0fba ("module: set ksymtab/kcrctab* section
addresses to 0x0").

Reported-by: Frank van der Linden <fllinden@amazon.com>
Signed-off-by: Shaoying Xu <shaoyi@amazon.com>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20210216183234.GA23876@amazon.com
Signed-off-by: Will Deacon <will@kernel.org>
[shaoyi@amazon.com: made same changes in arch/arm64/kernel/module.lds for 5.4]
Signed-off-by: Shaoying Xu <shaoyi@amazon.com>
---
arch/arm64/include/asm/module.lds.h was renamed from arch/arm64/kernel/module.lds
by commit 596b0474d3d9 ("kbuild: preprocess module linker script") since v5.10.
Therefore, made same changes in arch/arm64/kernel/module.lds for 5.4. 

 arch/arm64/kernel/module.lds | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kernel/module.lds b/arch/arm64/kernel/module.lds
index 22e36a21c113..09a0eef71d12 100644
--- a/arch/arm64/kernel/module.lds
+++ b/arch/arm64/kernel/module.lds
@@ -1,5 +1,5 @@
 SECTIONS {
-	.plt (NOLOAD) : { BYTE(0) }
-	.init.plt (NOLOAD) : { BYTE(0) }
-	.text.ftrace_trampoline (NOLOAD) : { BYTE(0) }
+	.plt 0 (NOLOAD) : { BYTE(0) }
+	.init.plt 0 (NOLOAD) : { BYTE(0) }
+	.text.ftrace_trampoline 0 (NOLOAD) : { BYTE(0) }
 }
-- 
2.16.6

