Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B546445F3B9
	for <lists+stable@lfdr.de>; Fri, 26 Nov 2021 19:22:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239393AbhKZSZR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Nov 2021 13:25:17 -0500
Received: from mailgate.ics.forth.gr ([139.91.1.2]:45648 "EHLO
        mailgate.ics.forth.gr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234587AbhKZSXQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 26 Nov 2021 13:23:16 -0500
X-Greylist: delayed 924 seconds by postgrey-1.27 at vger.kernel.org; Fri, 26 Nov 2021 13:23:15 EST
Received: from av3.ics.forth.gr (av3in.ics.forth.gr [139.91.1.77])
        by mailgate.ics.forth.gr (8.15.2/ICS-FORTH/V10-1.8-GATE) with ESMTP id 1AQI4acn005327
        for <stable@vger.kernel.org>; Fri, 26 Nov 2021 20:04:36 +0200 (EET)
DKIM-Signature: v=1; a=rsa-sha256; d=ics.forth.gr; s=av; c=relaxed/simple;
        q=dns/txt; i=@ics.forth.gr; t=1637949871; x=1640541871;
        h=From:Sender:Reply-To:Subject:Date:Message-Id:To:Cc:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=G7hqs6XkmVh0r9F43+KthFWHpCGCPs2cR9auzvLaORA=;
        b=H3h33uTpd/IsJk+daVt9SOGxKcwSc3JQvvUO4P/bsRTpmRh0ABxdeN5TNHhfKpJy
        ODtc7hnx/7GBDrtLhaCMuURv2Fl5FNjFkimyiSTY+ZYF8MUzbkSJKRnPK+I/VbC0
        uuPJajveHuJK4pCI6Kzlr0ZwxzcynHaR1Lep8nJV9vvg3zOUrJzfCriDbzbY2l0o
        UYg0/OPBylkTs/snrHI7efIOTyvdi8nodJTexDl5ejt1UUc5Ld5rGFN23J1eGX6o
        JiqHmgQt3+P04UOJIg2mfAluUSkMcn32yWG/8PBSilsQzmHGVetmXNlKGRnuNQg5
        Eq7wG6xauTMeLxco+H2CiA==;
X-AuditID: 8b5b014d-9ba4a7000000460a-aa-61a121af4fbd
Received: from enigma.ics.forth.gr (enigma-2.ics.forth.gr [139.91.151.35])
        by av3.ics.forth.gr (Symantec Messaging Gateway) with SMTP id A9.14.17930.FA121A16; Fri, 26 Nov 2021 20:04:31 +0200 (EET)
X-ICS-AUTH-INFO: Authenticated user: mick@ics.forth.gr at ics.forth.gr
From:   Nick Kossifidis <mick@ics.forth.gr>
To:     palmer@dabbelt.com, paul.walmsley@sifive.com, aou@eecs.berkeley.edu
Cc:     linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org,
        Nick Kossifidis <mick@ics.forth.gr>, stable@vger.kernel.org
Subject: [PATCH 2/3] riscv: use hart id instead of cpu id on machine_kexec
Date:   Fri, 26 Nov 2021 20:04:10 +0200
Message-Id: <20211126180411.187597-2-mick@ics.forth.gr>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20211126180411.187597-1-mick@ics.forth.gr>
References: <20211126180411.187597-1-mick@ics.forth.gr>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrBLMWRmVeSWpSXmKPExsXSHT1dWXe94sJEgxub2Sy2/p7FbnF51xw2
        i22fW9gsmt+dY7d4ebmH2aJtFr/Fgo2PGB3YPd68fMnicbjjC7vHw02XmDw2L6n3uNR8nd3j
        8ya5ALYoLpuU1JzMstQifbsEroy1O96zFezjqlh79wVLA+N/ji5GTg4JAROJi98vs3QxcnEI
        CRxjlOj7dp8FIuEmcfv+TlYQm01AU2L+pYNgcREBd4nVk/8wgTQwC7QzSsy89QcsISzgJTH/
        +lRGEJtFQFViydEGJhCbV8BcovXXQWaIofISp5YdBIpzcHAKWEjs+B0JEhYCKnm/aSUrRLmg
        xMmZT8BGMgOVN2+dzTyBkW8WktQsJKkFjEyrGAUSy4z1MpOL9dLyi0oy9NKLNjGCA5PRdwfj
        7c1v9Q4xMnEwHmKU4GBWEuF1DpyfKMSbklhZlVqUH19UmpNafIhRmoNFSZyXV29CvJBAemJJ
        anZqakFqEUyWiYNTqoFJZJ6q4QOtFWucG7Rbd5l6F5p8Eb+v+yEtdT7rwX+ruZ/OVHQ63DWr
        lE/9/MXq8u9a9VW/xdfMD79ok7jkrLn9d4Mldy5tfZ/qtELratfM7Pchxvd+Xt7PZ/ftGcvO
        V9eddSZfjTFlaLqhb3JKQKMoIG/ellj/hua4KV/enZ2718dngZa5vIhAU8i+gPxZLttjHrOp
        qz53UY1leDuvp69RvubDpu8vX5Ztfv147s/Q/ZeeHX4acUXRuHNTgsgM/ZMSz7aYtV37VMt0
        y1Qpvte6ypWD4f2BeEaH7QkHZdc6T7+4yPbOd9bGnxftO9ofPj/Cs95WoUtXSGm6wp3dj1Yp
        mdzPbbtr4ptfvLicv5lDiaU4I9FQi7moOBEAHofzrrsCAAA=
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

raw_smp_processor_id() doesn't return the hart id as stated in
arch/riscv/include/asm/smp.h, use smp_processor_id() instead
to get the cpu id, and cpuid_to_hartid_map() to pass the hart id
to the next kernel. This fixes kexec on HiFive Unleashed/Unmatched
where cpu ids and hart ids don't match (on qemu-virt they match).

Fixes: fba8a8674f68 ("RISC-V: Add kexec support")

Signed-off-by: Nick Kossifidis <mick@ics.forth.gr>
Cc: stable@vger.kernel.org
---
 arch/riscv/kernel/machine_kexec.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/riscv/kernel/machine_kexec.c b/arch/riscv/kernel/machine_kexec.c
index e6eca271a..cbef0fc73 100644
--- a/arch/riscv/kernel/machine_kexec.c
+++ b/arch/riscv/kernel/machine_kexec.c
@@ -169,7 +169,8 @@ machine_kexec(struct kimage *image)
 	struct kimage_arch *internal = &image->arch;
 	unsigned long jump_addr = (unsigned long) image->start;
 	unsigned long first_ind_entry = (unsigned long) &image->head;
-	unsigned long this_hart_id = raw_smp_processor_id();
+	unsigned long this_cpu_id = smp_processor_id();
+	unsigned long this_hart_id = cpuid_to_hartid_map(this_cpu_id);
 	unsigned long fdt_addr = internal->fdt_addr;
 	void *control_code_buffer = page_address(image->control_code_page);
 	riscv_kexec_method kexec_method = NULL;
-- 
2.32.0

