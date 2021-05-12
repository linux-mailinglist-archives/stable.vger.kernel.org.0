Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2DB437C205
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 17:05:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232174AbhELPGL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 11:06:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:59076 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232938AbhELPCW (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 11:02:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 077326145B;
        Wed, 12 May 2021 14:57:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620831470;
        bh=5+r1Z4vufz+JHKQKBotazcmTfCcsqEoLQ6ge8Fm3czw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lYNnEWpoUCSDZvYr8tDt1yKB9ZEKZSlMT2RQ5uQOGLMe1Rd5BngkzoVBzSzYtpfL/
         cDgEwb6VfCau6yr393sgBdd4Fzt4GeGdnYfgb2l9RgVbzZIBFGX29i8Fh5nqC0sb8x
         4BVPklqkHveQc2YZjNx0C5TEYfpUEGBbjUCEnsLI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Mike Travis <travis@sgi.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 133/244] x86/platform/uv: Fix !KEXEC build failure
Date:   Wed, 12 May 2021 16:48:24 +0200
Message-Id: <20210512144747.276078449@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144743.039977287@linuxfoundation.org>
References: <20210512144743.039977287@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ingo Molnar <mingo@kernel.org>

[ Upstream commit c2209ea55612efac75de0a58ef5f7394fae7fa0f ]

When KEXEC is disabled, the UV build fails:

  arch/x86/platform/uv/uv_nmi.c:875:14: error: ‘uv_nmi_kexec_failed’ undeclared (first use in this function)

Since uv_nmi_kexec_failed is only defined in the KEXEC_CORE #ifdef branch,
this code cannot ever have been build tested:

	if (main)
		pr_err("UV: NMI kdump: KEXEC not supported in this kernel\n");
	atomic_set(&uv_nmi_kexec_failed, 1);

Nor is this use possible in uv_handle_nmi():

                atomic_set(&uv_nmi_kexec_failed, 0);

These bugs were introduced in this commit:

    d0a9964e9873: ("x86/platform/uv: Implement simple dump failover if kdump fails")

Which added the uv_nmi_kexec_failed assignments to !KEXEC code, while making the
definition KEXEC-only - apparently without testing the !KEXEC case.

Instead of complicating the #ifdef maze, simplify the code by requiring X86_UV
to depend on KEXEC_CORE. This pattern is present in other architectures as well.

( We'll remove the untested, 7 years old !KEXEC complications from the file in a
  separate commit. )

Fixes: d0a9964e9873: ("x86/platform/uv: Implement simple dump failover if kdump fails")
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Cc: Mike Travis <travis@sgi.com>
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 8ef85139553f..36a28b9e46cb 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -550,6 +550,7 @@ config X86_UV
 	depends on X86_EXTENDED_PLATFORM
 	depends on NUMA
 	depends on EFI
+	depends on KEXEC_CORE
 	depends on X86_X2APIC
 	depends on PCI
 	---help---
-- 
2.30.2



