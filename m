Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7E908126CFA
	for <lists+stable@lfdr.de>; Thu, 19 Dec 2019 20:07:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728740AbfLSTHp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Dec 2019 14:07:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:34124 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728742AbfLSSmp (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Dec 2019 13:42:45 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CBF54206D7;
        Thu, 19 Dec 2019 18:42:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576780965;
        bh=HHMyBuTa596p6Sb1eikGdY4XlfLLThk8M3XdKWyRGqU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CRMy9piPj/FKB7LYmOHBNaSebmndxiW3WoliJmW0KaUttsWIeHGgrj1lCsiIy/ti0
         6BETBIBfQCQgaQgVYUzadvjPTwtJIWTfbOlOWxwZdg14Zil6JppW43bHef3MEk3xNc
         9X0HE057H1vHgslnRcLYuljzF8Jlq93TF/JfRdGM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Maciej W. Rozycki" <macro@linux-mips.org>,
        Paul Burton <paul.burton@mips.com>,
        Christoph Hellwig <hch@lst.de>,
        Ralf Baechle <ralf@linux-mips.org>, linux-mips@linux-mips.org,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 027/199] MIPS: SiByte: Enable ZONE_DMA32 for LittleSur
Date:   Thu, 19 Dec 2019 19:31:49 +0100
Message-Id: <20191219183216.351424583@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191219183214.629503389@linuxfoundation.org>
References: <20191219183214.629503389@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maciej W. Rozycki <macro@linux-mips.org>

[ Upstream commit 756d6d836dbfb04a5a486bc2ec89397aa4533737 ]

The LittleSur board is marked for high memory support and therefore
clearly must provide a way to have enough memory installed for some to
be present outside the low 4GiB physical address range.  With the memory
map of the BCM1250 SOC it has been built around it means over 1GiB of
actual DRAM, as only the first 1GiB is mapped in the low 4GiB physical
address range[1].

Complement commit cce335ae47e2 ("[MIPS] 64-bit Sibyte kernels need
DMA32.") then and also enable ZONE_DMA32 for LittleSur.


[1] "BCM1250/BCM1125/BCM1125H User Manual", Revision 1250_1125-UM100-R,
    Broadcom Corporation, 21 Oct 2002, Section 3: "System Overview",
    "Memory Map", pp. 34-38

Signed-off-by: Maciej W. Rozycki <macro@linux-mips.org>
Signed-off-by: Paul Burton <paul.burton@mips.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Patchwork: https://patchwork.linux-mips.org/patch/21107/
Fixes: cce335ae47e2 ("[MIPS] 64-bit Sibyte kernels need DMA32.")
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: linux-mips@linux-mips.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/mips/Kconfig b/arch/mips/Kconfig
index 92bcde046b6b4..f8a529c852795 100644
--- a/arch/mips/Kconfig
+++ b/arch/mips/Kconfig
@@ -804,6 +804,7 @@ config SIBYTE_LITTLESUR
 	select SYS_SUPPORTS_BIG_ENDIAN
 	select SYS_SUPPORTS_HIGHMEM
 	select SYS_SUPPORTS_LITTLE_ENDIAN
+	select ZONE_DMA32 if 64BIT
 
 config SIBYTE_SENTOSA
 	bool "Sibyte BCM91250E-Sentosa"
-- 
2.20.1



