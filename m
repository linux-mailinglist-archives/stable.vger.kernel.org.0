Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CB713ED595
	for <lists+stable@lfdr.de>; Mon, 16 Aug 2021 15:12:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239211AbhHPNMW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Aug 2021 09:12:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:35822 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236987AbhHPNKY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Aug 2021 09:10:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6B207610A1;
        Mon, 16 Aug 2021 13:09:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1629119393;
        bh=fMLDZqkSRsTJQwD0+4uaaLXl3q2PGp5Z5JfQBMvf6G0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sB7XZMmRrIytOHo/IReq6oDmPX4B1QLonqFM4ajE6Pe351FouCVk78SSFYlNzxBTu
         U0lclZt1YgypyruBFd9TKhRleThk2Od/V8FhQ20IGd4Hj3QkDEqYoAk5OSHXrctG8m
         GK1ME3g3R3S3dHH0zCTRkR77mmTTIpwGx6KcUfjM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Liang Wang <wangliang101@huawei.com>,
        Luis Chamberlain <mcgrof@kernel.org>,
        Palmer Dabbelt <palmerdabbelt@google.com>,
        Russell King <linux@armlinux.org.uk>,
        Xiaoming Ni <nixiaoming@huawei.com>,
        Kefeng Wang <wangkefeng.wang@huawei.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.13 001/151] lib: use PFN_PHYS() in devmem_is_allowed()
Date:   Mon, 16 Aug 2021 15:00:31 +0200
Message-Id: <20210816125444.130146840@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210816125444.082226187@linuxfoundation.org>
References: <20210816125444.082226187@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Liang Wang <wangliang101@huawei.com>

commit 854f32648b8a5e424d682953b1a9f3b7c3322701 upstream.

The physical address may exceed 32 bits on 32-bit systems with more than
32 bits of physcial address.  Use PFN_PHYS() in devmem_is_allowed(), or
the physical address may overflow and be truncated.

We found this bug when mapping a high addresses through devmem tool,
when CONFIG_STRICT_DEVMEM is enabled on the ARM with ARM_LPAE and devmem
is used to map a high address that is not in the iomem address range, an
unexpected error indicating no permission is returned.

This bug was initially introduced from v2.6.37, and the function was
moved to lib in v5.11.

Link: https://lkml.kernel.org/r/20210731025057.78825-1-wangliang101@huawei.com
Fixes: 087aaffcdf9c ("ARM: implement CONFIG_STRICT_DEVMEM by disabling access to RAM via /dev/mem")
Fixes: 527701eda5f1 ("lib: Add a generic version of devmem_is_allowed()")
Signed-off-by: Liang Wang <wangliang101@huawei.com>
Reviewed-by: Luis Chamberlain <mcgrof@kernel.org>
Cc: Palmer Dabbelt <palmerdabbelt@google.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Russell King <linux@armlinux.org.uk>
Cc: Liang Wang <wangliang101@huawei.com>
Cc: Xiaoming Ni <nixiaoming@huawei.com>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: <stable@vger.kernel.org>	[2.6.37+]
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 lib/devmem_is_allowed.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/lib/devmem_is_allowed.c
+++ b/lib/devmem_is_allowed.c
@@ -19,7 +19,7 @@
  */
 int devmem_is_allowed(unsigned long pfn)
 {
-	if (iomem_is_exclusive(pfn << PAGE_SHIFT))
+	if (iomem_is_exclusive(PFN_PHYS(pfn)))
 		return 0;
 	if (!page_is_ram(pfn))
 		return 1;


