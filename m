Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0290C304B24
	for <lists+stable@lfdr.de>; Tue, 26 Jan 2021 22:17:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728516AbhAZEum (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Jan 2021 23:50:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:33826 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726633AbhAYSqc (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Jan 2021 13:46:32 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C23042067B;
        Mon, 25 Jan 2021 18:46:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611600370;
        bh=BAAw2el7VSWzS5NnVOyyghdQ4oO7R+bR8fqn+CNmSew=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=icRjoLSar/LBBYWwMfBpJnhWhc1rZGZF/Wno/icVTk7aSCFZrYDAGlasAPRCf7nQm
         MAObiq7PEuGIG4HbZpIdgpVYb4L2bFNLp6w5JgxZq3KWYOKaUWSZmCvp4KSPYBW1I7
         OAEohwi5aNwL548pzgZAlR+GfVYErs+BTj0GA5V0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Ariel Marcovitch <ariel.marcovitch@gmail.com>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 45/86] powerpc: Fix alignment bug within the init sections
Date:   Mon, 25 Jan 2021 19:39:27 +0100
Message-Id: <20210125183202.970095454@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210125183201.024962206@linuxfoundation.org>
References: <20210125183201.024962206@linuxfoundation.org>
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
index f9081724d6910..a4e576019d79c 100644
--- a/arch/powerpc/kernel/vmlinux.lds.S
+++ b/arch/powerpc/kernel/vmlinux.lds.S
@@ -210,6 +210,12 @@ SECTIONS
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
@@ -223,6 +229,8 @@ SECTIONS
 		EXIT_TEXT
 	}
 
+	. = ALIGN(PAGE_SIZE);
+
 	INIT_DATA_SECTION(16)
 
 	. = ALIGN(8);
-- 
2.27.0



