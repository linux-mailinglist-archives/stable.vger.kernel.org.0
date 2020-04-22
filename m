Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0ED591B43E4
	for <lists+stable@lfdr.de>; Wed, 22 Apr 2020 14:04:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726948AbgDVMET (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Apr 2020 08:04:19 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:39074 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726539AbgDVMET (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Apr 2020 08:04:19 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03MBwRhm108352;
        Wed, 22 Apr 2020 12:03:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding; s=corp-2020-01-29;
 bh=0sge0UWysT17PtNdI9Z8VmS+FyRtHkKG1FJsSBeTKNA=;
 b=q8E9NsMQYqPf81xi+Pj3nn7wwTbBI4A7B6ZN76ZesHwwJewdpvI0NRlhCk0Z4MChwaIc
 jh5NQF/myFzldo5XHp0D01AUDK1i4UlYIIYLZyFQVykC6j2X0AWpUUurG7xCkIZPyIcM
 8mwrZriF6xakPDsblTfDUv15MZaB/NktaCGS1UELzd7ml7vpTniV4w7kI0iYaZOcgxry
 iruKvnXcuokumvlrYEXBGOZ6VnRBL9S9AleADM6c84fJj6JagQryQQ5EPxneQfC+vxvl
 P87wM+0hNuP/oZQCI+bP7HKWt5QKO1SB72bYwuMacO+/1IB/JQ0mwX0ES2rjQ70Fod6I Hg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 30grpgptbc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 22 Apr 2020 12:03:51 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 03MC2aHW176872;
        Wed, 22 Apr 2020 12:03:50 GMT
Received: from pps.reinject (localhost [127.0.0.1])
        by aserp3020.oracle.com with ESMTP id 30gbbgr0ya-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Wed, 22 Apr 2020 12:03:50 +0000
Received: from aserp3020.oracle.com (aserp3020.oracle.com [127.0.0.1])
        by pps.reinject (8.16.0.36/8.16.0.36) with SMTP id 03MC3nu4180211;
        Wed, 22 Apr 2020 12:03:49 GMT
Received: from control-surface.uk.oracle.com (dhcp-10-175-178-214.vpn.oracle.com [10.175.178.214])
        by aserp3020.oracle.com with ESMTP id 30gbbgr0ve-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
        Wed, 22 Apr 2020 12:03:49 +0000
Received: from control-surface.uk.oracle.com (localhost [127.0.0.1])
        by control-surface.uk.oracle.com (8.15.2/8.15.2) with ESMTPS id 03MC3ltD080679
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
        Wed, 22 Apr 2020 13:03:47 +0100
Received: (from jch@localhost)
        by control-surface.uk.oracle.com (8.15.2/8.15.2/Submit) id 03MC3lhA080678;
        Wed, 22 Apr 2020 13:03:47 +0100
X-Authentication-Warning: control-surface.uk.oracle.com: jch set sender to john.haxby@oracle.com using -f
From:   John Haxby <john.haxby@oracle.com>
To:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <ak@linux.intel.com>,
        Jonathan Corbet <corbet@lwn.net>
Cc:     x86@kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, John Haxby <john.haxby@oracle.com>,
        stable@vger.kernel.org
Subject: [PATCH 1/1] x86/fpu: Allow clearcpuid= to clear several bits
Date:   Wed, 22 Apr 2020 13:03:19 +0100
Message-Id: <03a3a4d135b17115db9ad91413e21af73e244500.1587555769.git.john.haxby@oracle.com>
X-Mailer: git-send-email 2.25.3
In-Reply-To: <cover.1587555769.git.john.haxby@oracle.com>
References: <cover.1587555769.git.john.haxby@oracle.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9598 signatures=668686
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0
 lowpriorityscore=0 adultscore=0 suspectscore=0 bulkscore=0 clxscore=1011
 malwarescore=0 phishscore=0 spamscore=0 priorityscore=1501 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2003020000
 definitions=main-2004220096
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Prior to 0c2a3913d6f5, clearcpuid= could be specified several times on
the command line to clear several bits. The old multiple option is a
little anachronistic so change clearcpuid to accept a comma-separated
list of numbers. Up to about eight bits can be cleared.

Fixes: 0c2a3913d6f5 ("x86/fpu: Parse clearcpuid= as early XSAVE argument")
Signed-off-by: John Haxby <john.haxby@oracle.com>
Cc: stable@vger.kernel.org
---
 .../admin-guide/kernel-parameters.txt         | 24 ++++++++++---------
 arch/x86/kernel/fpu/init.c                    | 18 ++++++++------
 2 files changed, 24 insertions(+), 18 deletions(-)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index f2a93c8679e8..f380781be9e0 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -577,18 +577,20 @@
 			loops can be debugged more effectively on production
 			systems.
 
-	clearcpuid=BITNUM [X86]
-			Disable CPUID feature X for the kernel. See
+	clearcpuid=BITNUM[,BITNUM,...] [X86]
+			Disable CPUID features for the kernel. See
 			arch/x86/include/asm/cpufeatures.h for the valid bit
-			numbers. Note the Linux specific bits are not necessarily
-			stable over kernel options, but the vendor specific
-			ones should be.
-			Also note that user programs calling CPUID directly
-			or using the feature without checking anything
-			will still see it. This just prevents it from
-			being used by the kernel or shown in /proc/cpuinfo.
-			Also note the kernel might malfunction if you disable
-			some critical bits.
+			numbers. Up to about eight bits can be cleared. Note the
+			Linux specific bits are not necessarily stable over
+			kernel options, but the vendor specific ones should be.
+			Also note that user programs calling CPUID directly or
+			using the feature without checking anything will still
+			see it. This just prevents it from being used by the
+			kernel or shown in /proc/cpuinfo.  Also note the kernel
+			might malfunction if you disable some critical bits.
+			Consider using a virtual machine emulating an older CPU
+			type for clearing many bits or for making the cleared
+			bits visible to user programs.
 
 	cma=nn[MG]@[start[MG][-end[MG]]]
 			[ARM,X86,KNL]
diff --git a/arch/x86/kernel/fpu/init.c b/arch/x86/kernel/fpu/init.c
index 6ce7e0a23268..8d826505c22e 100644
--- a/arch/x86/kernel/fpu/init.c
+++ b/arch/x86/kernel/fpu/init.c
@@ -243,8 +243,6 @@ static void __init fpu__init_system_ctx_switch(void)
 static void __init fpu__init_parse_early_param(void)
 {
 	char arg[32];
-	char *argptr = arg;
-	int bit;
 
 #ifdef CONFIG_X86_32
 	if (cmdline_find_option_bool(boot_command_line, "no387"))
@@ -268,11 +266,17 @@ static void __init fpu__init_parse_early_param(void)
 		setup_clear_cpu_cap(X86_FEATURE_XSAVES);
 
 	if (cmdline_find_option(boot_command_line, "clearcpuid", arg,
-				sizeof(arg)) &&
-	    get_option(&argptr, &bit) &&
-	    bit >= 0 &&
-	    bit < NCAPINTS * 32)
-		setup_clear_cpu_cap(bit);
+				sizeof(arg))) {
+		/* cpuid bit numbers are mostly three digits */
+		enum  { nints = sizeof(arg)/(3+1) + 1 };
+		int i, bits[nints];
+
+		get_options(arg, nints, bits);
+		for (i = 1; i <= bits[0]; i++) {
+			if (bits[i] >= 0 && bits[i] < NCAPINTS * 32)
+				setup_clear_cpu_cap(bits[i]);
+		}
+	}
 }
 
 /*
-- 
2.25.3

