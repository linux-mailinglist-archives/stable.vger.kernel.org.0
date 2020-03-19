Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0DE8118B0C6
	for <lists+stable@lfdr.de>; Thu, 19 Mar 2020 11:02:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726979AbgCSKB5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Mar 2020 06:01:57 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:60207 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726783AbgCSKB5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 19 Mar 2020 06:01:57 -0400
Received: from [5.158.153.53] (helo=tip-bot2.lab.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tip-bot2@linutronix.de>)
        id 1jErzp-0004ya-QK; Thu, 19 Mar 2020 11:01:49 +0100
Received: from [127.0.1.1] (localhost [IPv6:::1])
        by tip-bot2.lab.linutronix.de (Postfix) with ESMTP id 552141C229F;
        Thu, 19 Mar 2020 11:01:49 +0100 (CET)
Date:   Thu, 19 Mar 2020 10:01:49 -0000
From:   "tip-bot2 for Borislav Petkov" <tip-bot2@linutronix.de>
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: x86/urgent] x86/ioremap: Fix CONFIG_EFI=n build
Cc:     Randy Dunlap <rdunlap@infradead.org>, Borislav Petkov <bp@suse.de>,
        Tom Lendacky <thomas.lendacky@amd.com>,
        <stable@vger.kernel.org>, x86 <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <7561e981-0d9b-d62c-0ef2-ce6007aff1ab@infradead.org>
References: <7561e981-0d9b-d62c-0ef2-ce6007aff1ab@infradead.org>
MIME-Version: 1.0
Message-ID: <158461210901.28353.10235841690300952771.tip-bot2@tip-bot2>
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot2.linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the x86/urgent branch of tip:

Commit-ID:     870b4333a62e45b0b2000d14b301b7b8b8cad9da
Gitweb:        https://git.kernel.org/tip/870b4333a62e45b0b2000d14b301b7b8b8cad9da
Author:        Borislav Petkov <bp@suse.de>
AuthorDate:    Wed, 18 Mar 2020 19:27:48 +01:00
Committer:     Borislav Petkov <bp@suse.de>
CommitterDate: Thu, 19 Mar 2020 10:55:56 +01:00

x86/ioremap: Fix CONFIG_EFI=n build

In order to use efi_mem_type(), one needs CONFIG_EFI enabled. Otherwise
that function is undefined. Use IS_ENABLED() to check and avoid the
ifdeffery as the compiler optimizes away the following unreachable code
then.

Fixes: 985e537a4082 ("x86/ioremap: Map EFI runtime services data as encrypted for SEV")
Reported-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Borislav Petkov <bp@suse.de>
Tested-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Cc: <stable@vger.kernel.org>
Link: https://lkml.kernel.org/r/7561e981-0d9b-d62c-0ef2-ce6007aff1ab@infradead.org
---
 arch/x86/mm/ioremap.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/arch/x86/mm/ioremap.c b/arch/x86/mm/ioremap.c
index 935a91e..18c637c 100644
--- a/arch/x86/mm/ioremap.c
+++ b/arch/x86/mm/ioremap.c
@@ -115,6 +115,9 @@ static void __ioremap_check_other(resource_size_t addr, struct ioremap_desc *des
 	if (!sev_active())
 		return;
 
+	if (!IS_ENABLED(CONFIG_EFI))
+		return;
+
 	if (efi_mem_type(addr) == EFI_RUNTIME_SERVICES_DATA)
 		desc->flags |= IORES_MAP_ENCRYPTED;
 }
