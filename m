Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 982F811951E
	for <lists+stable@lfdr.de>; Tue, 10 Dec 2019 22:19:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727093AbfLJVS6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Dec 2019 16:18:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:37056 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729016AbfLJVMg (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Dec 2019 16:12:36 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 304E822B48;
        Tue, 10 Dec 2019 21:12:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576012355;
        bh=VS0842Du/Ba/NlUL/G3mBTQHBJKcTT41h1fajZiiH3I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=niUlfQBgVTksYQxHw6YICizalPa1tBNd0QdbYYUr2DFHwFofgivDLcxgLlYc49Lr9
         VPTe+E97JxxH86PQx+O9ZBQ66DzunDx+VvzFQTyN46nVwxQQ8HNmFruqVAGoQkxKDB
         gIeRWMrBJ/LpjO2YOET5wxTHl/3S9S71vaXR8kig=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Lianbo Jiang <lijiang@redhat.com>,
        kbuild test robot <lkp@intel.com>,
        Borislav Petkov <bp@suse.de>, bhe@redhat.com,
        d.hatayama@fujitsu.com, dhowells@redhat.com, dyoung@redhat.com,
        ebiederm@xmission.com, horms@verge.net.au,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        =?UTF-8?q?J=C3=BCrgen=20Gross?= <jgross@suse.com>,
        kexec@lists.infradead.org, Thomas Gleixner <tglx@linutronix.de>,
        Tom Lendacky <thomas.lendacky@amd.com>, vgoyal@redhat.com,
        x86-ml <x86@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.4 283/350] x86/crash: Add a forward declaration of struct kimage
Date:   Tue, 10 Dec 2019 16:06:28 -0500
Message-Id: <20191210210735.9077-244-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191210210735.9077-1-sashal@kernel.org>
References: <20191210210735.9077-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lianbo Jiang <lijiang@redhat.com>

[ Upstream commit 112eee5d06007dae561f14458bde7f2a4879ef4e ]

Add a forward declaration of struct kimage to the crash.h header because
future changes will invoke a crash-specific function from the realmode
init path and the compiler will complain otherwise like this:

  In file included from arch/x86/realmode/init.c:11:
  ./arch/x86/include/asm/crash.h:5:32: warning: ‘struct kimage’ declared inside\
   parameter list will not be visible outside of this definition or declaration
      5 | int crash_load_segments(struct kimage *image);
        |                                ^~~~~~
  ./arch/x86/include/asm/crash.h:6:37: warning: ‘struct kimage’ declared inside\
   parameter list will not be visible outside of this definition or declaration
      6 | int crash_copy_backup_region(struct kimage *image);
        |                                     ^~~~~~
  ./arch/x86/include/asm/crash.h:7:39: warning: ‘struct kimage’ declared inside\
   parameter list will not be visible outside of this definition or declaration
      7 | int crash_setup_memmap_entries(struct kimage *image,
        |

 [ bp: Rewrite the commit message. ]

Reported-by: kbuild test robot <lkp@intel.com>
Signed-off-by: Lianbo Jiang <lijiang@redhat.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Cc: bhe@redhat.com
Cc: d.hatayama@fujitsu.com
Cc: dhowells@redhat.com
Cc: dyoung@redhat.com
Cc: ebiederm@xmission.com
Cc: horms@verge.net.au
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jürgen Gross <jgross@suse.com>
Cc: kexec@lists.infradead.org
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Cc: vgoyal@redhat.com
Cc: x86-ml <x86@kernel.org>
Link: https://lkml.kernel.org/r/20191108090027.11082-4-lijiang@redhat.com
Link: https://lkml.kernel.org/r/201910310233.EJRtTMWP%25lkp@intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/include/asm/crash.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/x86/include/asm/crash.h b/arch/x86/include/asm/crash.h
index 0acf5ee45a21a..ef5638f641f2b 100644
--- a/arch/x86/include/asm/crash.h
+++ b/arch/x86/include/asm/crash.h
@@ -2,6 +2,8 @@
 #ifndef _ASM_X86_CRASH_H
 #define _ASM_X86_CRASH_H
 
+struct kimage;
+
 int crash_load_segments(struct kimage *image);
 int crash_copy_backup_region(struct kimage *image);
 int crash_setup_memmap_entries(struct kimage *image,
-- 
2.20.1

