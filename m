Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8FF8212C9E7
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 19:19:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728045AbfL2RZp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 12:25:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:45930 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727706AbfL2RZp (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Dec 2019 12:25:45 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EC90220409;
        Sun, 29 Dec 2019 17:25:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577640344;
        bh=/4gVWON24o3gT/sJg+4JO2SrZ5r/nsfaYVwhQp0Oat4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=u5/ZMhsKjmwBZzqoG6OZtLnKjT4NeVL3yNMPDXWNsiqaUEcgBdhcyispQv0TFTQEe
         wA1kfZZsKbEuyAtV3qg+sUxfJwtfr6p2dLnQhe1Qpu7VBUcFR/Si1oPKgmBqPr+YTU
         oIhZyH8/T20rZzF6alqcD7nxyWd8RN+PPLKHRdic=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kbuild test robot <lkp@intel.com>,
        Lianbo Jiang <lijiang@redhat.com>,
        Borislav Petkov <bp@suse.de>, bhe@redhat.com,
        d.hatayama@fujitsu.com, dhowells@redhat.com, dyoung@redhat.com,
        ebiederm@xmission.com, horms@verge.net.au,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        =?UTF-8?q?J=C3=BCrgen=20Gross?= <jgross@suse.com>,
        kexec@lists.infradead.org, Thomas Gleixner <tglx@linutronix.de>,
        Tom Lendacky <thomas.lendacky@amd.com>, vgoyal@redhat.com,
        x86-ml <x86@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 118/161] x86/crash: Add a forward declaration of struct kimage
Date:   Sun, 29 Dec 2019 18:19:26 +0100
Message-Id: <20191229162433.898340980@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191229162355.500086350@linuxfoundation.org>
References: <20191229162355.500086350@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index a7adb2bfbf0b..6b8ad6fa3979 100644
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



