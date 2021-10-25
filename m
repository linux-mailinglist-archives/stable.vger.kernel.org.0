Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66F4443A206
	for <lists+stable@lfdr.de>; Mon, 25 Oct 2021 21:43:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234981AbhJYTo3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Oct 2021 15:44:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:59360 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235650AbhJYTlh (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Oct 2021 15:41:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3E86961179;
        Mon, 25 Oct 2021 19:36:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1635190595;
        bh=rhCEe1YAL5L+0Vhv2XSfVCZXHV0jEo7p42ZhTme8rzA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kEw8K3/dzTzsNC0mv+Y+miVY291PyzJNnFIoCRghz/ps4mSOPs7XxfRgeern7DWYE
         MFNsbSKtpfHfwEskD/3FrAMa4Zrq41Q0kePZPrxPEnBb/L+u811qSJ07CcspnTQ0oF
         BzrMWHiJTbWnJcnd30WrBHM0hvRUBjOKzXKafHbA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jan Beulich <jbeulich@suse.com>,
        Juergen Gross <jgross@suse.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 007/169] xen/x86: prevent PVH type from getting clobbered
Date:   Mon, 25 Oct 2021 21:13:08 +0200
Message-Id: <20211025191018.679562994@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211025191017.756020307@linuxfoundation.org>
References: <20211025191017.756020307@linuxfoundation.org>
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
index c79bd0af2e8c..f252faf5028f 100644
--- a/arch/x86/xen/enlighten.c
+++ b/arch/x86/xen/enlighten.c
@@ -52,9 +52,6 @@ DEFINE_PER_CPU(struct vcpu_info, xen_vcpu_info);
 DEFINE_PER_CPU(uint32_t, xen_vcpu_id);
 EXPORT_PER_CPU_SYMBOL(xen_vcpu_id);
 
-enum xen_domain_type xen_domain_type = XEN_NATIVE;
-EXPORT_SYMBOL_GPL(xen_domain_type);
-
 unsigned long *machine_to_phys_mapping = (void *)MACH2PHYS_VIRT_START;
 EXPORT_SYMBOL(machine_to_phys_mapping);
 unsigned long  machine_to_phys_nr;
@@ -69,9 +66,11 @@ __read_mostly int xen_have_vector_callback;
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



