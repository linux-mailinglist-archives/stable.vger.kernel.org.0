Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCE041F2DFE
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 02:38:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730051AbgFIAh7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jun 2020 20:37:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:33358 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729524AbgFHXNg (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jun 2020 19:13:36 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7F288208C3;
        Mon,  8 Jun 2020 23:13:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591658016;
        bh=onZzfpPcuwRTXdEaoOhP1R+4XpAuWxWKhY9z4Kw7/F8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=n9Yf7+ps2huDjUaxQ7IspvY4n+e55ZX/OJcHcMT2WYcw8Xw6mICzAzl91OmEv1gFP
         rhNSILi0zZ1vhAbIIvBHbn5Na2pkef38t71xEL8hEGNEND/AU36RoStmU1RQaoWKxM
         AHQbg8ZjL29FhA0bbUgMM72njxMC3oxvNjrLUIoE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Nayna Jain <nayna@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Mimi Zohar <zohar@linux.ibm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 5.6 070/606] powerpc/ima: Fix secure boot rules in ima arch policy
Date:   Mon,  8 Jun 2020 19:03:15 -0400
Message-Id: <20200608231211.3363633-70-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608231211.3363633-1-sashal@kernel.org>
References: <20200608231211.3363633-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nayna Jain <nayna@linux.ibm.com>

commit fa4f3f56ccd28ac031ab275e673ed4098855fed4 upstream.

To prevent verifying the kernel module appended signature
twice (finit_module), once by the module_sig_check() and again by IMA,
powerpc secure boot rules define an IMA architecture specific policy
rule only if CONFIG_MODULE_SIG_FORCE is not enabled. This,
unfortunately, does not take into account the ability of enabling
"sig_enforce" on the boot command line (module.sig_enforce=1).

Including the IMA module appraise rule results in failing the
finit_module syscall, unless the module signing public key is loaded
onto the IMA keyring.

This patch fixes secure boot policy rules to be based on
CONFIG_MODULE_SIG instead.

Fixes: 4238fad366a6 ("powerpc/ima: Add support to initialize ima policy rules")
Signed-off-by: Nayna Jain <nayna@linux.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Mimi Zohar <zohar@linux.ibm.com>
Link: https://lore.kernel.org/r/1588342612-14532-1-git-send-email-nayna@linux.ibm.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/kernel/ima_arch.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/powerpc/kernel/ima_arch.c b/arch/powerpc/kernel/ima_arch.c
index e34116255ced..957abd592075 100644
--- a/arch/powerpc/kernel/ima_arch.c
+++ b/arch/powerpc/kernel/ima_arch.c
@@ -19,12 +19,12 @@ bool arch_ima_get_secureboot(void)
  * to be stored as an xattr or as an appended signature.
  *
  * To avoid duplicate signature verification as much as possible, the IMA
- * policy rule for module appraisal is added only if CONFIG_MODULE_SIG_FORCE
+ * policy rule for module appraisal is added only if CONFIG_MODULE_SIG
  * is not enabled.
  */
 static const char *const secure_rules[] = {
 	"appraise func=KEXEC_KERNEL_CHECK appraise_flag=check_blacklist appraise_type=imasig|modsig",
-#ifndef CONFIG_MODULE_SIG_FORCE
+#ifndef CONFIG_MODULE_SIG
 	"appraise func=MODULE_CHECK appraise_flag=check_blacklist appraise_type=imasig|modsig",
 #endif
 	NULL
@@ -50,7 +50,7 @@ static const char *const secure_and_trusted_rules[] = {
 	"measure func=KEXEC_KERNEL_CHECK template=ima-modsig",
 	"measure func=MODULE_CHECK template=ima-modsig",
 	"appraise func=KEXEC_KERNEL_CHECK appraise_flag=check_blacklist appraise_type=imasig|modsig",
-#ifndef CONFIG_MODULE_SIG_FORCE
+#ifndef CONFIG_MODULE_SIG
 	"appraise func=MODULE_CHECK appraise_flag=check_blacklist appraise_type=imasig|modsig",
 #endif
 	NULL
-- 
2.25.1

