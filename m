Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 11372B8725
	for <lists+stable@lfdr.de>; Fri, 20 Sep 2019 00:34:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389421AbfISWed (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Sep 2019 18:34:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:47886 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405462AbfISWJi (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Sep 2019 18:09:38 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1D0DC21907;
        Thu, 19 Sep 2019 22:09:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568930977;
        bh=AXPR9OXJuhp5iAZ5tC1XbkvuhWf5TaT1co01bJ2eGsE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CF27y1I214x9qjCtnPqqai8qV6AUeP1YCBQ3sMQjoUdjAAl+I4hoxb2fnwdSkjP18
         2E7ZiBJYjQuJwf4fZqnC/JExkN7G4IFX5bbdTK9CHJGbl1ty6gRPkdEWJhblbTLh4e
         U6nA6LpR1iXybjBWhBr7ts4PoGubZpkh2/8D+5ZU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhaoyang Huang <zhaoyang.huang@unisoc.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 084/124] ARM: 8901/1: add a criteria for pfn_valid of arm
Date:   Fri, 20 Sep 2019 00:02:52 +0200
Message-Id: <20190919214822.077733327@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190919214819.198419517@linuxfoundation.org>
References: <20190919214819.198419517@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: zhaoyang <huangzhaoyang@gmail.com>

[ Upstream commit 5b3efa4f1479c91cb8361acef55f9c6662feba57 ]

pfn_valid can be wrong when parsing a invalid pfn whose phys address
exceeds BITS_PER_LONG as the MSB will be trimed when shifted.

The issue originally arise from bellowing call stack, which corresponding to
an access of the /proc/kpageflags from userspace with a invalid pfn parameter
and leads to kernel panic.

[46886.723249] c7 [<c031ff98>] (stable_page_flags) from [<c03203f8>]
[46886.723264] c7 [<c0320368>] (kpageflags_read) from [<c0312030>]
[46886.723280] c7 [<c0311fb0>] (proc_reg_read) from [<c02a6e6c>]
[46886.723290] c7 [<c02a6e24>] (__vfs_read) from [<c02a7018>]
[46886.723301] c7 [<c02a6f74>] (vfs_read) from [<c02a778c>]
[46886.723315] c7 [<c02a770c>] (SyS_pread64) from [<c0108620>]
(ret_fast_syscall+0x0/0x28)

Signed-off-by: Zhaoyang Huang <zhaoyang.huang@unisoc.com>
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/mm/init.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/arch/arm/mm/init.c b/arch/arm/mm/init.c
index 8e793cddac661..98e17388a563f 100644
--- a/arch/arm/mm/init.c
+++ b/arch/arm/mm/init.c
@@ -174,6 +174,11 @@ static void __init zone_sizes_init(unsigned long min, unsigned long max_low,
 #ifdef CONFIG_HAVE_ARCH_PFN_VALID
 int pfn_valid(unsigned long pfn)
 {
+	phys_addr_t addr = __pfn_to_phys(pfn);
+
+	if (__phys_to_pfn(addr) != pfn)
+		return 0;
+
 	return memblock_is_map_memory(__pfn_to_phys(pfn));
 }
 EXPORT_SYMBOL(pfn_valid);
-- 
2.20.1



