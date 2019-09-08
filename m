Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 21CD6ACDD5
	for <lists+stable@lfdr.de>; Sun,  8 Sep 2019 14:54:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733296AbfIHMxA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 8 Sep 2019 08:53:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:45638 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733282AbfIHMw6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 8 Sep 2019 08:52:58 -0400
Received: from localhost (unknown [62.28.240.114])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8C27B21920;
        Sun,  8 Sep 2019 12:52:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567947178;
        bh=27jcVKK/qpC0ilYCPfzWwVPw9oGhG5I+khgjFLMDj+A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hNtcPsXDjIPsWKUE/zN2qEAvOMfqSLR6Yuxpu0/TTnCVbExkHqjQwpTu/kqSmbb2f
         lMLormT56/p+YsbW58sBSg95p0ia87Y9/9y1i+w4hvAxIoq00i71lSJB7gArrEEgUd
         /9+EWEBIs0wnWLPHlTbwxv+j40WYg8VowwJv3uw8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Gustavo A. R. Silva" <gustavo@embeddedor.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 90/94] x86/boot/compressed/64: Fix missing initialization in find_trampoline_placement()
Date:   Sun,  8 Sep 2019 13:42:26 +0100
Message-Id: <20190908121153.005775685@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190908121150.420989666@linuxfoundation.org>
References: <20190908121150.420989666@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit c96e8483cb2da6695c8b8d0896fe7ae272a07b54 ]

Gustavo noticed that 'new' can be left uninitialized if 'bios_start'
happens to be less or equal to 'entry->addr + entry->size'.

Initialize the variable at the begin of the iteration to the current value
of 'bios_start'.

Fixes: 0a46fff2f910 ("x86/boot/compressed/64: Fix boot on machines with broken E820 table")
Reported-by: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Link: https://lkml.kernel.org/r/20190826133326.7cxb4vbmiawffv2r@box
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/boot/compressed/pgtable_64.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/boot/compressed/pgtable_64.c b/arch/x86/boot/compressed/pgtable_64.c
index f0537a1f7fc25..76e1edf5bf12a 100644
--- a/arch/x86/boot/compressed/pgtable_64.c
+++ b/arch/x86/boot/compressed/pgtable_64.c
@@ -73,7 +73,7 @@ static unsigned long find_trampoline_placement(void)
 
 	/* Find the first usable memory region under bios_start. */
 	for (i = boot_params->e820_entries - 1; i >= 0; i--) {
-		unsigned long new;
+		unsigned long new = bios_start;
 
 		entry = &boot_params->e820_table[i];
 
-- 
2.20.1



