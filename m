Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8FB8712C70E
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 18:55:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732458AbfL2Rx0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 12:53:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:40390 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732167AbfL2RxZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Dec 2019 12:53:25 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4719E206A4;
        Sun, 29 Dec 2019 17:53:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577642004;
        bh=d/OxfB3P0umzB0DvmM0BQBZusnP0OtOdTXH9gvu0Fo0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nEGrreVF+1Qe+9FKpMX2nyoIlN338KWjh+8B5zGFo2xdDFMxLomQH0qb3rjuHiBts
         RgY9XpRh/8RXfPsXUqnk5I3onSaaSyo9X5AU9NNqEefqHC8VNMn+ZePU8pDsnjnnpY
         wCoGWExmqOzqlBoJtRm4v0jLZ6S3+GtjRMYmhEm4=
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
Subject: [PATCH 5.4 302/434] x86/crash: Add a forward declaration of struct kimage
Date:   Sun, 29 Dec 2019 18:25:55 +0100
Message-Id: <20191229172722.012794847@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191229172702.393141737@linuxfoundation.org>
References: <20191229172702.393141737@linuxfoundation.org>
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
index 0acf5ee45a21..ef5638f641f2 100644
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



