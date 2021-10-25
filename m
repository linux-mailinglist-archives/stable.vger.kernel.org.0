Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2A7043A119
	for <lists+stable@lfdr.de>; Mon, 25 Oct 2021 21:34:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235661AbhJYThR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Oct 2021 15:37:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:52126 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236274AbhJYTeE (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Oct 2021 15:34:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EC06360FE8;
        Mon, 25 Oct 2021 19:29:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635190195;
        bh=n1tTSWQDnZCGccnS6zBfI+YWb3yAxp76XfmkA1dlrOQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DtqtdV4+4cZVayHy7dSUDko9f67zYni1Apy3fVsx1FUoElEfsrlZTRxfy7/ZxStjl
         Y2d2OrXHio6NIpfkngdUYdT7RLLEs/VlvfQIc5cAX2uNm7ff/YmCAoJB7Po7/X5Lyw
         D4eWi1R0n6LkoEjpgP0kpj7OBr3cCXtKF+qEIz1k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jan Beulich <jbeulich@suse.com>,
        Juergen Gross <jgross@suse.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 07/95] xen/x86: prevent PVH type from getting clobbered
Date:   Mon, 25 Oct 2021 21:14:04 +0200
Message-Id: <20211025190957.449773881@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211025190956.374447057@linuxfoundation.org>
References: <20211025190956.374447057@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jan Beulich <jbeulich@suse.com>

[ Upstream commit 9172b5c4a778da1f855b2e3780b1afabb3cfd523 ]

Like xen_start_flags, xen_domain_type gets set before .bss gets cleared.
Hence this variable also needs to be prevented from getting put in .bss,
which is possible because XEN_NATIVE is an enumerator evaluating to
zero. Any use prior to init_hvm_pv_info() setting the variable again
would lead to wrong decisions; one such case is xenboot_console_setup()
when called as a result of "earlyprintk=xen".

Use __ro_after_init as more applicable than either __section(".data") or
__read_mostly.

Signed-off-by: Jan Beulich <jbeulich@suse.com>
Reviewed-by: Juergen Gross <jgross@suse.com>

Link: https://lore.kernel.org/r/d301677b-6f22-5ae6-bd36-458e1f323d0b@suse.com
Signed-off-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/xen/enlighten.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
index aa9f50fccc5d..0f68c6da7382 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -51,9 +51,6 @@ DEFINE_PER_CPU(struct vcpu_info, xen_vcpu_info);
 DEFINE_PER_CPU(uint32_t, xen_vcpu_id);
 EXPORT_PER_CPU_SYMBOL(xen_vcpu_id);
 
-enum xen_domain_type xen_domain_type = XEN_NATIVE;
-EXPORT_SYMBOL_GPL(xen_domain_type);
-
 unsigned long *machine_to_phys_mapping = (void *)MACH2PHYS_VIRT_START;
 EXPORT_SYMBOL(machine_to_phys_mapping);
 unsigned long  machine_to_phys_nr;
@@ -68,9 +65,11 @@ __read_mostly int xen_have_vector_callback;
 EXPORT_SYMBOL_GPL(xen_have_vector_callback);
 
 /*
- * NB: needs to live in .data because it's used by xen_prepare_pvh which runs
- * before clearing the bss.
+ * NB: These need to live in .data or alike because they're used by
+ * xen_prepare_pvh() which runs before clearing the bss.
  */
+enum xen_domain_type __ro_after_init xen_domain_type = XEN_NATIVE;
+EXPORT_SYMBOL_GPL(xen_domain_type);
 uint32_t xen_start_flags __section(".data") = 0;
 EXPORT_SYMBOL(xen_start_flags);
 
-- 
2.33.0



