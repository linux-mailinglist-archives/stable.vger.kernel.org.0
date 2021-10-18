Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E2BD431AFD
	for <lists+stable@lfdr.de>; Mon, 18 Oct 2021 15:28:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232390AbhJRNaG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Oct 2021 09:30:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:42144 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232080AbhJRN32 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Oct 2021 09:29:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 816506103D;
        Mon, 18 Oct 2021 13:27:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634563637;
        bh=Xj/vs6k2tHEXMwpnBSl0Xpc3tvuJ7egNp8+d17y/x3c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RxA0LTLd3oZkO5TpqcwmH+/1b5/tuTQ7VVM63VlZi7vuj1D/v/ufa0X1c3JQszhbn
         uxuiil8sTZGaQtG1TAakrbfcCuCaI8yEVxSWVvCkW7MyclpkwEZvbaPj6Xhpa83aQX
         GINSDFKVNhsB2t77C7IdFY7wSF0pNY6Uxx3W/lWU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jackie Liu <liuyun01@kylinos.cn>,
        Hanjun Guo <guohanjun@huawei.com>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH 4.14 37/39] acpi/arm64: fix next_platform_timer() section mismatch error
Date:   Mon, 18 Oct 2021 15:24:46 +0200
Message-Id: <20211018132326.624210726@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211018132325.426739023@linuxfoundation.org>
References: <20211018132325.426739023@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jackie Liu <liuyun01@kylinos.cn>

commit 596143e3aec35c93508d6b7a05ddc999ee209b61 upstream.

Fix modpost Section mismatch error in next_platform_timer().

  [...]
  WARNING: modpost: vmlinux.o(.text.unlikely+0x26e60): Section mismatch in reference from the function next_platform_timer() to the variable .init.data:acpi_gtdt_desc
  The function next_platform_timer() references
  the variable __initdata acpi_gtdt_desc.
  This is often because next_platform_timer lacks a __initdata
  annotation or the annotation of acpi_gtdt_desc is wrong.

  WARNING: modpost: vmlinux.o(.text.unlikely+0x26e64): Section mismatch in reference from the function next_platform_timer() to the variable .init.data:acpi_gtdt_desc
  The function next_platform_timer() references
  the variable __initdata acpi_gtdt_desc.
  This is often because next_platform_timer lacks a __initdata
  annotation or the annotation of acpi_gtdt_desc is wrong.

  ERROR: modpost: Section mismatches detected.
  Set CONFIG_SECTION_MISMATCH_WARN_ONLY=y to allow them.
  make[1]: *** [scripts/Makefile.modpost:59: vmlinux.symvers] Error 1
  make[1]: *** Deleting file 'vmlinux.symvers'
  make: *** [Makefile:1176: vmlinux] Error 2
  [...]

Fixes: a712c3ed9b8a ("acpi/arm64: Add memory-mapped timer support in GTDT driver")
Signed-off-by: Jackie Liu <liuyun01@kylinos.cn>
Acked-by: Hanjun Guo <guohanjun@huawei.com>
Link: https://lore.kernel.org/r/20210823092526.2407526-1-liu.yun@linux.dev
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/acpi/arm64/gtdt.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/acpi/arm64/gtdt.c
+++ b/drivers/acpi/arm64/gtdt.c
@@ -39,7 +39,7 @@ struct acpi_gtdt_descriptor {
 
 static struct acpi_gtdt_descriptor acpi_gtdt_desc __initdata;
 
-static inline void *next_platform_timer(void *platform_timer)
+static inline __init void *next_platform_timer(void *platform_timer)
 {
 	struct acpi_gtdt_header *gh = platform_timer;
 


