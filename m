Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2132349A4C8
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 03:10:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2369617AbiAYACP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 19:02:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1458155AbiAXX2Q (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 18:28:16 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B1E8C0A54D4;
        Mon, 24 Jan 2022 13:32:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C8343B80FA1;
        Mon, 24 Jan 2022 21:32:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01633C340E4;
        Mon, 24 Jan 2022 21:32:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643059965;
        bh=tedjfVLlqp5z8Y5ric/qPSjsl1AyBDAz7qNYDDiK5L4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nk6hIkux0JOWPWMJ21SReA0vynFTuCVd7KqCw06+IidMnJK6RngqgFf/DmCk0IqUD
         Ah+re0Rc5T4/3NotpGnZCSWLRr9GreEHWY4wsIuarW7g7HwPyPzfeKmqhsEomnrOjG
         t6NOrFbBqez8Sc5fOdOkWTL0aV07VJmceuafoUF0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Hou Wenlong <houwenlong93@linux.alibaba.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0793/1039] KVM: x86: Exit to userspace if emulation prepared a completion callback
Date:   Mon, 24 Jan 2022 19:43:02 +0100
Message-Id: <20220124184151.954250852@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hou Wenlong <houwenlong93@linux.alibaba.com>

[ Upstream commit adbfb12d4c4517a8adde23a7fc46538953d56eea ]

em_rdmsr() and em_wrmsr() return X86EMUL_IO_NEEDED if MSR accesses
required an exit to userspace. However, x86_emulate_insn() doesn't return
X86EMUL_*, so x86_emulate_instruction() doesn't directly act on
X86EMUL_IO_NEEDED; instead, it looks for other signals to differentiate
between PIO, MMIO, etc. causing RDMSR/WRMSR emulation not to
exit to userspace now.

Nevertheless, if the userspace_msr_exit_test testcase in selftests
is changed to test RDMSR/WRMSR with a forced emulation prefix,
the test passes.  What happens is that first userspace exit
information is filled but the userspace exit does not happen.
Because x86_emulate_instruction() returns 1, the guest retries
the instruction---but this time RIP has already been adjusted
past the forced emulation prefix, so the guest executes RDMSR/WRMSR
and the userspace exit finally happens.

Since the X86EMUL_IO_NEEDED path has provided a complete_userspace_io
callback, x86_emulate_instruction() can just return 0 if the
callback is not NULL. Then RDMSR/WRMSR instruction emulation will
exit to userspace directly, without the RDMSR/WRMSR vmexit.

Fixes: 1ae099540e8c7 ("KVM: x86: Allow deflecting unknown MSR accesses to user space")
Signed-off-by: Hou Wenlong <houwenlong93@linux.alibaba.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Message-Id: <56f9df2ee5c05a81155e2be366c9dc1f7adc8817.1635842679.git.houwenlong93@linux.alibaba.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/x86.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/kvm/x86.c b/arch/x86/kvm/x86.c
index 5d5a8e75edcb7..00628031de98d 100644
--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -8203,6 +8203,9 @@ restart:
 			writeback = false;
 		r = 0;
 		vcpu->arch.complete_userspace_io = complete_emulated_mmio;
+	} else if (vcpu->arch.complete_userspace_io) {
+		writeback = false;
+		r = 0;
 	} else if (r == EMULATION_RESTART)
 		goto restart;
 	else
-- 
2.34.1



