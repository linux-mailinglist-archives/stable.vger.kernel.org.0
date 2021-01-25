Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E40C304A9C
	for <lists+stable@lfdr.de>; Tue, 26 Jan 2021 21:52:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728029AbhAZFBH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 Jan 2021 00:01:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:36206 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731008AbhAYSvJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Jan 2021 13:51:09 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2B4C2230FE;
        Mon, 25 Jan 2021 18:50:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611600647;
        bh=ofOobhAYAlhx7z0vjQRQRqTy0ct47jqIcLvfC6rMWZs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GthisWVxgH4o2x+2Boe4XDNDlcq+wCuj78Sr0AoNxFoXxSF4N/1cJkKARlASb/RCm
         KA0rR0vj0JRz3kblPrtdC+yvwI2IrpeYf9SPRi5JDpQS0009S3bFWIxBSo+ndC3FpD
         GJd/yilksGjXFAI6nDVHkeY98g+WMfog/VnhHVwE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Ariel Marcovitch <ariel.marcovitch@gmail.com>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 089/199] powerpc: Fix alignment bug within the init sections
Date:   Mon, 25 Jan 2021 19:38:31 +0100
Message-Id: <20210125183220.028257959@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210125183216.245315437@linuxfoundation.org>
References: <20210125183216.245315437@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ariel Marcovitch <arielmarcovitch@gmail.com>

[ Upstream commit 2225a8dda263edc35a0e8b858fe2945cf6240fde ]

This is a bug that causes early crashes in builds with an .exit.text
section smaller than a page and an .init.text section that ends in the
beginning of a physical page (this is kinda random, which might
explain why this wasn't really encountered before).

The init sections are ordered like this:
  .init.text
  .exit.text
  .init.data

Currently, these sections aren't page aligned.

Because the init code might become read-only at runtime and because
the .init.text section can potentially reside on the same physical
page as .init.data, the beginning of .init.data might be mapped
read-only along with .init.text.

Then when the kernel tries to modify a variable in .init.data (like
kthreadd_done, used in kernel_init()) the kernel panics.

To avoid this, make _einittext page aligned and also align .exit.text
to make sure .init.data is always seperated from the text segments.

Fixes: 060ef9d89d18 ("powerpc32: PAGE_EXEC required for inittext")
Signed-off-by: Ariel Marcovitch <ariel.marcovitch@gmail.com>
Reviewed-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20210102201156.10805-1-ariel.marcovitch@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/kernel/vmlinux.lds.S | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/powerpc/kernel/vmlinux.lds.S b/arch/powerpc/kernel/vmlinux.lds.S
index 50507dac118ae..83281aee14d2f 100644
--- a/arch/powerpc/kernel/vmlinux.lds.S
+++ b/arch/powerpc/kernel/vmlinux.lds.S
@@ -187,6 +187,12 @@ SECTIONS
 	.init.text : AT(ADDR(.init.text) - LOAD_OFFSET) {
 		_sinittext = .;
 		INIT_TEXT
+
+		/*
+		 *.init.text might be RO so we must ensure this section ends on
+		 * a page boundary.
+		 */
+		. = ALIGN(PAGE_SIZE);
 		_einittext = .;
 #ifdef CONFIG_PPC64
 		*(.tramp.ftrace.init);
@@ -200,6 +206,8 @@ SECTIONS
 		EXIT_TEXT
 	}
 
+	. = ALIGN(PAGE_SIZE);
+
 	INIT_DATA_SECTION(16)
 
 	. = ALIGN(8);
-- 
2.27.0



