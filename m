Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D30EAFD65E
	for <lists+stable@lfdr.de>; Fri, 15 Nov 2019 07:24:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727206AbfKOGV1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Nov 2019 01:21:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:50166 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727254AbfKOGVY (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 15 Nov 2019 01:21:24 -0500
Received: from localhost (unknown [104.132.150.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7A069207FA;
        Fri, 15 Nov 2019 06:21:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573798883;
        bh=h69u4/bLP0zchwXZ5WAw+xSwvyOl8O8zEdR6h+sZVrY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uZa0IWHuPS1wbB52oBXEueFS3N5dYwPvVBVhQldsswbo9GrwFJUSn//YphrzjdFcO
         jVXYefHYfFcdlHVICxnsqtV612nYChlaHeQ5V/9PPK7J0FJkRWVyqmfcStAcUc+W65
         5oYip5c7SwsJAZYxm0PDa0q1NCAEEPIPT3nU6+hA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
        Borislav Petkov <bp@suse.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tony Luck <tony.luck@intel.com>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH 4.4 16/20] x86/tsx: Add "auto" option to the tsx= cmdline parameter
Date:   Fri, 15 Nov 2019 14:20:45 +0800
Message-Id: <20191115062014.685895776@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191115062006.854443935@linuxfoundation.org>
References: <20191115062006.854443935@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>

commit 7531a3596e3272d1f6841e0d601a614555dc6b65 upstream.

Platforms which are not affected by X86_BUG_TAA may want the TSX feature
enabled. Add "auto" option to the TSX cmdline parameter. When tsx=auto
disable TSX when X86_BUG_TAA is present, otherwise enable TSX.

More details on X86_BUG_TAA can be found here:
https://www.kernel.org/doc/html/latest/admin-guide/hw-vuln/tsx_async_abort.html

 [ bp: Extend the arg buffer to accommodate "auto\0". ]

Signed-off-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Tony Luck <tony.luck@intel.com>
Reviewed-by: Josh Poimboeuf <jpoimboe@redhat.com>
[bwh: Backported to 4.4: adjust filename]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Documentation/kernel-parameters.txt |    3 +++
 arch/x86/kernel/cpu/tsx.c           |    7 ++++++-
 2 files changed, 9 insertions(+), 1 deletion(-)

--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -4073,6 +4073,9 @@ bytes respectively. Such letter suffixes
 				update. This new MSR allows for the reliable
 				deactivation of the TSX functionality.)
 
+			auto	- Disable TSX if X86_BUG_TAA is present,
+				  otherwise enable TSX on the system.
+
 			Not specifying this option is equivalent to tsx=off.
 
 			See Documentation/hw-vuln/tsx_async_abort.rst
--- a/arch/x86/kernel/cpu/tsx.c
+++ b/arch/x86/kernel/cpu/tsx.c
@@ -75,7 +75,7 @@ static bool __init tsx_ctrl_is_supported
 
 void __init tsx_init(void)
 {
-	char arg[4] = {};
+	char arg[5] = {};
 	int ret;
 
 	if (!tsx_ctrl_is_supported())
@@ -87,6 +87,11 @@ void __init tsx_init(void)
 			tsx_ctrl_state = TSX_CTRL_ENABLE;
 		} else if (!strcmp(arg, "off")) {
 			tsx_ctrl_state = TSX_CTRL_DISABLE;
+		} else if (!strcmp(arg, "auto")) {
+			if (boot_cpu_has_bug(X86_BUG_TAA))
+				tsx_ctrl_state = TSX_CTRL_DISABLE;
+			else
+				tsx_ctrl_state = TSX_CTRL_ENABLE;
 		} else {
 			tsx_ctrl_state = TSX_CTRL_DISABLE;
 			pr_err("tsx: invalid option, defaulting to off\n");


