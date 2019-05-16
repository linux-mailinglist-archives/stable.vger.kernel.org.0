Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 65B0B20C1A
	for <lists+stable@lfdr.de>; Thu, 16 May 2019 18:02:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727384AbfEPQBl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 May 2019 12:01:41 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:42888 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727025AbfEPP6q (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 May 2019 11:58:46 -0400
Received: from [167.98.27.226] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1hRImJ-0006zQ-Ge; Thu, 16 May 2019 16:58:43 +0100
Received: from ben by deadeye with local (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1hRImF-0001St-57; Thu, 16 May 2019 16:58:39 +0100
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From:   Ben Hutchings <ben@decadent.org.uk>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC:     akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        "Josh Poimboeuf" <jpoimboe@redhat.com>
Date:   Thu, 16 May 2019 16:55:33 +0100
Message-ID: <lsq.1558022133.629926369@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
X-Patchwork-Hint: ignore
Subject: [PATCH 3.16 81/86] x86/speculation/mds: Add 'mitigations='
 support for MDS
In-Reply-To: <lsq.1558022132.52852998@decadent.org.uk>
X-SA-Exim-Connect-IP: 167.98.27.226
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

3.16.68-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Josh Poimboeuf <jpoimboe@redhat.com>

commit 5c14068f87d04adc73ba3f41c2a303d3c3d1fa12 upstream.

Add MDS to the new 'mitigations=' cmdline option.

Signed-off-by: Josh Poimboeuf <jpoimboe@redhat.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
[bwh: Backported to 3.16:
 - Drop the auto,nosmt option, which we can't support
 - Adjust filenames, context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -1920,6 +1920,7 @@ bytes respectively. Such letter suffixes
 					       nospectre_v2 [X86]
 					       spectre_v2_user=off [X86]
 					       spec_store_bypass_disable=off [X86]
+					       mds=off [X86]
 
 			auto (default)
 				Mitigate all CPU vulnerabilities, but leave SMT
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -287,7 +287,7 @@ static const char * const mds_strings[]
 
 static void __init mds_select_mitigation(void)
 {
-	if (!boot_cpu_has_bug(X86_BUG_MDS)) {
+	if (!boot_cpu_has_bug(X86_BUG_MDS) || cpu_mitigations_off()) {
 		mds_mitigation = MDS_MITIGATION_OFF;
 		return;
 	}

