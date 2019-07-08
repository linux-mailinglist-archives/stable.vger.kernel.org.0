Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A13C562370
	for <lists+stable@lfdr.de>; Mon,  8 Jul 2019 17:35:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390671AbfGHPf1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jul 2019 11:35:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:38020 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390650AbfGHPf0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jul 2019 11:35:26 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3D58620665;
        Mon,  8 Jul 2019 15:35:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562600125;
        bh=oqJOOPIzXqtL84WhyP7K9dTw3vqk5/8dazpQ8iRpGL4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iG7ODRBQTcYqhtc5Erjlc93taDmC0Cl0BN0o+9ti1BVMRcUOEqIF4/TZN37/j3cCK
         To9ZR8209fRyDIITQJvubRb5xy44JMCXF02nq44eKlezajyd8PA/MsxxtMnKBRzNZW
         KFQ3F2yOlwuM0ahuO9ztNzq37v9jezQuuz3rsDkM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paul Burton <paul.burton@mips.com>,
        Hauke Mehrtens <hauke@hauke-m.de>, ralf@linux-mips.org,
        jhogan@kernel.org, f4bug@amsat.org, linux-mips@vger.kernel.org,
        ysu@wavecomp.com, jcristau@debian.org
Subject: [PATCH 5.1 89/96] MIPS: Fix bounds check virt_addr_valid
Date:   Mon,  8 Jul 2019 17:14:01 +0200
Message-Id: <20190708150531.247785719@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190708150526.234572443@linuxfoundation.org>
References: <20190708150526.234572443@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hauke Mehrtens <hauke@hauke-m.de>

commit d6ed083f5cc621e15c15b56c3b585fd524dbcb0f upstream.

The bounds check used the uninitialized variable vaddr, it should use
the given parameter kaddr instead. When using the uninitialized value
the compiler assumed it to be 0 and optimized this function to just
return 0 in all cases.

This should make the function check the range of the given address and
only do the page map check in case it is in the expected range of
virtual addresses.

Fixes: 074a1e1167af ("MIPS: Bounds check virt_addr_valid")
Cc: stable@vger.kernel.org # v4.12+
Cc: Paul Burton <paul.burton@mips.com>
Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
Signed-off-by: Paul Burton <paul.burton@mips.com>
Cc: ralf@linux-mips.org
Cc: jhogan@kernel.org
Cc: f4bug@amsat.org
Cc: linux-mips@vger.kernel.org
Cc: ysu@wavecomp.com
Cc: jcristau@debian.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/mips/mm/mmap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/mips/mm/mmap.c
+++ b/arch/mips/mm/mmap.c
@@ -203,7 +203,7 @@ unsigned long arch_randomize_brk(struct
 
 int __virt_addr_valid(const volatile void *kaddr)
 {
-	unsigned long vaddr = (unsigned long)vaddr;
+	unsigned long vaddr = (unsigned long)kaddr;
 
 	if ((vaddr < PAGE_OFFSET) || (vaddr >= MAP_BASE))
 		return 0;


