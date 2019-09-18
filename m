Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6E9A9B5CC5
	for <lists+stable@lfdr.de>; Wed, 18 Sep 2019 08:29:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726960AbfIRG30 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Sep 2019 02:29:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:47440 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727555AbfIRG0K (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 18 Sep 2019 02:26:10 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E16AA21928;
        Wed, 18 Sep 2019 06:26:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568787969;
        bh=SHhpYwH5Sq8HCNZh5enSnSTYSMlnjKMibXCmc7r3qbE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lytXMnY2IcG8cBptbnngXDFcfHnD/K7xhQgdDXt4iOVxRoEgJv093AwvceTe3C/OK
         1CfrgOH2WND80ElGFBau97LDj7kVOPmcAl3hTsZzONPwwkr40Bhw/ujh9sX/00zATz
         1A+UQHfnwDXiIwC6jhitT0RRxv+VorQes0achfh4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Matthew Garrett <mjg59@google.com>,
        Mimi Zohar <zohar@linux.ibm.com>
Subject: [PATCH 5.2 52/85] x86/ima: check EFI SetupMode too
Date:   Wed, 18 Sep 2019 08:19:10 +0200
Message-Id: <20190918061235.765422956@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190918061234.107708857@linuxfoundation.org>
References: <20190918061234.107708857@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mimi Zohar <zohar@linux.ibm.com>

commit 980ef4d22a95a3cd84a9b8ffaa7b81b391d173c6 upstream.

Checking "SecureBoot" mode is not sufficient, also check "SetupMode".

Fixes: 399574c64eaf ("x86/ima: retry detecting secure boot mode")
Reported-by: Matthew Garrett <mjg59@google.com>
Signed-off-by: Mimi Zohar <zohar@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kernel/ima_arch.c |   12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

--- a/arch/x86/kernel/ima_arch.c
+++ b/arch/x86/kernel/ima_arch.c
@@ -11,10 +11,11 @@ extern struct boot_params boot_params;
 static enum efi_secureboot_mode get_sb_mode(void)
 {
 	efi_char16_t efi_SecureBoot_name[] = L"SecureBoot";
+	efi_char16_t efi_SetupMode_name[] = L"SecureBoot";
 	efi_guid_t efi_variable_guid = EFI_GLOBAL_VARIABLE_GUID;
 	efi_status_t status;
 	unsigned long size;
-	u8 secboot;
+	u8 secboot, setupmode;
 
 	size = sizeof(secboot);
 
@@ -36,7 +37,14 @@ static enum efi_secureboot_mode get_sb_m
 		return efi_secureboot_mode_unknown;
 	}
 
-	if (secboot == 0) {
+	size = sizeof(setupmode);
+	status = efi.get_variable(efi_SetupMode_name, &efi_variable_guid,
+				  NULL, &size, &setupmode);
+
+	if (status != EFI_SUCCESS)	/* ignore unknown SetupMode */
+		setupmode = 0;
+
+	if (secboot == 0 || setupmode == 1) {
 		pr_info("ima: secureboot mode disabled\n");
 		return efi_secureboot_mode_disabled;
 	}


