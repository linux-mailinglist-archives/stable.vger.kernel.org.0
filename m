Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B43CA1F285
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 14:06:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729626AbfEOLLn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 07:11:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:46388 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729414AbfEOLLl (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 May 2019 07:11:41 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4FB8B2084F;
        Wed, 15 May 2019 11:11:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557918700;
        bh=MImSsXvWpLoPg86zZhy9nBvmMuJY3uBgGLoSEpjiewo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nKQbjYPYcVQA/zdt239AkmF2wayhffzSipSeA1gQzrdGBILJVPpeV/P+3NbafrIWj
         hhtdyO/bn2ab5f6oWoaEfKBcut2aiJeYINZF4Iv20FHwsjBvNK+KhlQoQgOFBkdXgh
         hmpPq7DtvamFtlOEbaK/dCpuNdd3X8NFenmpH/qw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@suse.de>,
        Frederic Weisbecker <frederic@kernel.org>,
        Jon Masters <jcm@redhat.com>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH 4.4 232/266] x86/kvm: Expose X86_FEATURE_MD_CLEAR to guests
Date:   Wed, 15 May 2019 12:55:39 +0200
Message-Id: <20190515090730.851971386@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190515090722.696531131@linuxfoundation.org>
References: <20190515090722.696531131@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

commit 6c4dbbd14730c43f4ed808a9c42ca41625925c22 upstream.

X86_FEATURE_MD_CLEAR is a new CPUID bit which is set when microcode
provides the mechanism to invoke a flush of various exploitable CPU buffers
by invoking the VERW instruction.

Hand it through to guests so they can adjust their mitigations.

This also requires corresponding qemu changes, which are available
separately.

[ tglx: Massaged changelog ]

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Borislav Petkov <bp@suse.de>
Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Reviewed-by: Frederic Weisbecker <frederic@kernel.org>
Reviewed-by: Jon Masters <jcm@redhat.com>
Tested-by: Jon Masters <jcm@redhat.com>
[bwh: Backported to 4.4: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/cpuid.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -366,7 +366,7 @@ static inline int __do_cpuid_ent(struct
 	/* cpuid 7.0.edx*/
 	const u32 kvm_cpuid_7_0_edx_x86_features =
 		F(SPEC_CTRL) | F(SPEC_CTRL_SSBD) | F(ARCH_CAPABILITIES) |
-		F(INTEL_STIBP);
+		F(INTEL_STIBP) | F(MD_CLEAR);
 
 	/* all calls to cpuid_count() should be made on the same cpu */
 	get_cpu();


