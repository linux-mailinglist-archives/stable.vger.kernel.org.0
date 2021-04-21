Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B46AA366C42
	for <lists+stable@lfdr.de>; Wed, 21 Apr 2021 15:12:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239667AbhDUNNW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Apr 2021 09:13:22 -0400
Received: from smtp-fw-4101.amazon.com ([72.21.198.25]:45879 "EHLO
        smtp-fw-4101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241867AbhDUNLX (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Apr 2021 09:11:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazon201209;
  t=1619010651; x=1650546651;
  h=subject:from:to:cc:references:message-id:date:
   mime-version:in-reply-to:content-transfer-encoding;
  bh=X1Guu4g3y6XQ31GyM/6aVlFFsY0PGtWjyVIc1+SURnU=;
  b=hU+NOvNoGG1Mcp+2Q6heZXYDNlTVwPGzdH0aZSZMATIzf7ntORKkz67K
   rkqhye/Q49BuDj+ZcaQctgtZNqjFAuvjcaCA72T9lJIQfY/oD7FaBKYfc
   R7MCCMqatjtIaRQ3PgVaMEwJbO2D5nMT1fhsSKJtCXvSvAF+D1eh3O4ru
   Y=;
X-IronPort-AV: E=Sophos;i="5.82,240,1613433600"; 
   d="scan'208";a="103137117"
Received: from iad12-co-svc-p1-lb1-vlan2.amazon.com (HELO email-inbound-relay-2b-a7fdc47a.us-west-2.amazon.com) ([10.43.8.2])
  by smtp-border-fw-out-4101.iad4.amazon.com with ESMTP; 21 Apr 2021 13:10:44 +0000
Received: from EX13D01EUA001.ant.amazon.com (pdx1-ws-svc-p6-lb9-vlan2.pdx.amazon.com [10.236.137.194])
        by email-inbound-relay-2b-a7fdc47a.us-west-2.amazon.com (Postfix) with ESMTPS id B9476C059F;
        Wed, 21 Apr 2021 13:10:42 +0000 (UTC)
Received: from 8c859063385e.ant.amazon.com (10.43.161.253) by
 EX13D01EUA001.ant.amazon.com (10.43.165.121) with Microsoft SMTP Server (TLS)
 id 15.0.1497.2; Wed, 21 Apr 2021 13:10:39 +0000
Subject: [PATCH 4/8] powerpc/bpf: Enable bpf_probe_read{, str}() on powerpc,
 again
From:   "Zidenberg, Tsahi" <tsahee@amazon.com>
To:     <stable@vger.kernel.org>
CC:     Greg KH <greg@kroah.com>
References: <dda18ffd-0406-ec54-1014-b7d89a1bcd56@amazon.com>
Message-ID: <39c705ad-d4d2-6ba7-dcf1-6e1ef9db4639@amazon.com>
Date:   Wed, 21 Apr 2021 16:10:34 +0300
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:78.0)
 Gecko/20100101 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <dda18ffd-0406-ec54-1014-b7d89a1bcd56@amazon.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Originating-IP: [10.43.161.253]
X-ClientProxiedBy: EX13D22UWB004.ant.amazon.com (10.43.161.165) To
 EX13D01EUA001.ant.amazon.com (10.43.165.121)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


commit d195b1d1d1196681ac4775e0361e9cca70f740c2 upstream

The commit 0ebeea8ca8a4d1d453a ("bpf: Restrict bpf_probe_read{, str}() only
to archs where they work") caused that bpf_probe_read{, str}() functions
were not longer available on architectures where the same logical address
might have different content in kernel and user memory mapping. These
architectures should use probe_read_{user,kernel}_str helpers.

For backward compatibility, the problematic functions are still available
on architectures where the user and kernel address spaces are not
overlapping. This is defined CONFIG_ARCH_HAS_NON_OVERLAPPING_ADDRESS_SPACE.

At the moment, these backward compatible functions are enabled only on x86_64,
arm, and arm64. Let's do it also on powerpc that has the non overlapping
address space as well.

Fixes: 0ebeea8ca8a4 ("bpf: Restrict bpf_probe_read{, str}() only to archs where they work")
Signed-off-by: Petr Mladek <pmladek@suse.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/lkml/20200527122844.19524-1-pmladek@suse.com
Cc: <stable@vger.kernel.org> # 5.4
Signed-off-by: Tsahi Zidenberg <tsahee@amazon.com>
---
 arch/powerpc/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
index c4cbb65e742f..c50bfab7930b 100644
--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -129,6 +129,7 @@ config PPC
     select ARCH_HAS_MMIOWB            if PPC64
     select ARCH_HAS_PHYS_TO_DMA
     select ARCH_HAS_PMEM_API
+    select ARCH_HAS_NON_OVERLAPPING_ADDRESS_SPACE
     select ARCH_HAS_PTE_DEVMAP        if PPC_BOOK3S_64
     select ARCH_HAS_PTE_SPECIAL
     select ARCH_HAS_MEMBARRIER_CALLBACKS
-- 
2.25.1


