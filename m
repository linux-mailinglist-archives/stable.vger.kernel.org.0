Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C3B891FFF9
	for <lists+stable@lfdr.de>; Thu, 16 May 2019 09:09:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726374AbfEPHJi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 May 2019 03:09:38 -0400
Received: from michel.telenet-ops.be ([195.130.137.88]:58228 "EHLO
        michel.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726277AbfEPHJi (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 May 2019 03:09:38 -0400
Received: from ramsan ([84.194.111.163])
        by michel.telenet-ops.be with bizsmtp
        id Cv9c200043XaVaC06v9cyz; Thu, 16 May 2019 09:09:37 +0200
Received: from rox.of.borg ([192.168.97.57])
        by ramsan with esmtp (Exim 4.90_1)
        (envelope-from <geert@linux-m68k.org>)
        id 1hRAWG-0000eY-3P; Thu, 16 May 2019 09:09:36 +0200
Received: from geert by rox.of.borg with local (Exim 4.90_1)
        (envelope-from <geert@linux-m68k.org>)
        id 1hRAWG-0005sN-1G; Thu, 16 May 2019 09:09:36 +0200
From:   Geert Uytterhoeven <geert@linux-m68k.org>
To:     Josh Poimboeuf <jpoimboe@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Jiri Kosina <jkosina@suse.cz>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ben Hutchings <ben@decadent.org.uk>
Cc:     linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        stable@vger.kernel.org
Subject: [PATCH] cpu/speculation: Warn on unsupported mitigations= parameter
Date:   Thu, 16 May 2019 09:09:35 +0200
Message-Id: <20190516070935.22546-1-geert@linux-m68k.org>
X-Mailer: git-send-email 2.17.1
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Currently, if the user specifies an unsupported mitigation strategy on
the kernel command line, it will be ignored silently.  The code will
fall back to the default strategy, possibly leaving the system more
vulnerable than expected.

This may happen due to e.g. a simple typo, or, for a stable kernel
release, because not all mitigation strategies have been backported.

Inform the user by printing a message.

Fixes: 98af8452945c5565 ("cpu/speculation: Add 'mitigations=' cmdline option")
Cc: stable@vger.kernel.org
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 kernel/cpu.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/kernel/cpu.c b/kernel/cpu.c
index f2ef10460698e9ec..8458fda00e6ddb88 100644
--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -2339,6 +2339,9 @@ static int __init mitigations_parse_cmdline(char *arg)
 		cpu_mitigations = CPU_MITIGATIONS_AUTO;
 	else if (!strcmp(arg, "auto,nosmt"))
 		cpu_mitigations = CPU_MITIGATIONS_AUTO_NOSMT;
+	else
+		pr_crit("Unsupported mitigations=%s, system may still be vulnerable\n",
+			arg);
 
 	return 0;
 }
-- 
2.17.1

