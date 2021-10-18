Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C266431EC5
	for <lists+stable@lfdr.de>; Mon, 18 Oct 2021 16:04:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233602AbhJROFO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Oct 2021 10:05:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:40650 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232454AbhJROBn (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Oct 2021 10:01:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2580061A6D;
        Mon, 18 Oct 2021 13:42:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634564565;
        bh=VIdxFtqdmZjsJnavCV+3i8M+BDIPD+wDhXUWr5cD+xA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Yttf0lBn01ADQFOOZCXmMR4OGTL+0qhqgQZ3WtcrVJEah1HAc85BYvK9LXuHKG5Ud
         VSbVF4IVdwR7DXp3ocpKMF9W3Gc9RlKhbKNo8wMMAeViZWDB13C9MP8xXfHWTtMVnl
         KccUdvU//W5jA8aytromIhlaP10MVx8VcjXAcZnk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jackie Liu <liuyun01@kylinos.cn>,
        Hanjun Guo <guohanjun@huawei.com>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH 5.14 136/151] acpi/arm64: fix next_platform_timer() section mismatch error
Date:   Mon, 18 Oct 2021 15:25:15 +0200
Message-Id: <20211018132345.083788053@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211018132340.682786018@linuxfoundation.org>
References: <20211018132340.682786018@linuxfoundation.org>
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
@@ -36,7 +36,7 @@ struct acpi_gtdt_descriptor {
 
 static struct acpi_gtdt_descriptor acpi_gtdt_desc __initdata;
 
-static inline void *next_platform_timer(void *platform_timer)
+static inline __init void *next_platform_timer(void *platform_timer)
 {
 	struct acpi_gtdt_header *gh = platform_timer;
 


