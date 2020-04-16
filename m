Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E84541AC948
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 17:22:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2898568AbgDPNqT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Apr 2020 09:46:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:60184 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392296AbgDPNqR (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Apr 2020 09:46:17 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C89512076D;
        Thu, 16 Apr 2020 13:46:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587044777;
        bh=1jzhNCiKswhoIJTfB2OLMsRckfeRXXkCNaRRwVljCGw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1XwVQIwwDgT6qZooVs194NawgPWKaz/Z7xbhWz0YUt2OZjpgxrNKIapnicc9XL2ST
         B4Ooln7hPRXk7tPHvEHGprNcaADlF8m4XvRePkRpe5v372pqKUPDnjkrLpQKlKecmF
         pJCtwRmY7xb2Sj4aG5PsvjqjifIwixyLC/uSOOnM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tom Lendacky <thomas.lendacky@amd.com>,
        Ard Biesheuvel <ardb@kernel.org>,
        Ingo Molnar <mingo@kernel.org>, linux-efi@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        David Hildenbrand <david@redhat.com>,
        Heinrich Schuchardt <xypron.glpk@gmx.de>
Subject: [PATCH 5.4 098/232] efi/x86: Add TPM related EFI tables to unencrypted mapping checks
Date:   Thu, 16 Apr 2020 15:23:12 +0200
Message-Id: <20200416131327.275420952@linuxfoundation.org>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200416131316.640996080@linuxfoundation.org>
References: <20200416131316.640996080@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tom Lendacky <thomas.lendacky@amd.com>

commit f10e80a19b07b58fc2adad7945f8313b01503bae upstream.

When booting with SME active, EFI tables must be mapped unencrypted since
they were built by UEFI in unencrypted memory. Update the list of tables
to be checked during early_memremap() processing to account for the EFI
TPM tables.

This fixes a bug where an EFI TPM log table has been created by UEFI, but
it lives in memory that has been marked as usable rather than reserved.

Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Cc: linux-efi@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: David Hildenbrand <david@redhat.com>
Cc: Heinrich Schuchardt <xypron.glpk@gmx.de>
Cc: <stable@vger.kernel.org> # v5.4+
Link: https://lore.kernel.org/r/4144cd813f113c20cdfa511cf59500a64e6015be.1582662842.git.thomas.lendacky@amd.com
Link: https://lore.kernel.org/r/20200228121408.9075-2-ardb@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/platform/efi/efi.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -85,6 +85,8 @@ static const unsigned long * const efi_t
 #ifdef CONFIG_EFI_RCI2_TABLE
 	&rci2_table_phys,
 #endif
+	&efi.tpm_log,
+	&efi.tpm_final_log,
 };
 
 u64 efi_setup;		/* efi setup_data physical address */


