Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1C0AE10BC96
	for <lists+stable@lfdr.de>; Wed, 27 Nov 2019 22:22:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732406AbfK0VGV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Nov 2019 16:06:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:60372 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732402AbfK0VGU (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 27 Nov 2019 16:06:20 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8A8582178F;
        Wed, 27 Nov 2019 21:06:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574888780;
        bh=lRPt9jymUbXWKctZ9s1aVDzxhXEFT0cUHXoT8XZU/sU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=w31VnYdWFSURIMpc+qVGMqqJw4RK7dX1rHfH0g73ZxTnFtrpkyBsP2xUi6Sg11Sqy
         5tQ5sDsNLaNA4PZs8cv8CdJ3il8YaLZdwq++bM79+P+spRQiVB9jNI+7Xcl5oGAnUT
         XOqicMsmZSbU7p/+crE/xd00nC/c9eAyKLetYEF4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chester Lin <clin@suse.com>,
        Mike Rapoport <rppt@linux.ibm.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 4.19 265/306] ARM: 8904/1: skip nomap memblocks while finding the lowmem/highmem boundary
Date:   Wed, 27 Nov 2019 21:31:55 +0100
Message-Id: <20191127203134.194537142@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191127203114.766709977@linuxfoundation.org>
References: <20191127203114.766709977@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chester Lin <clin@suse.com>

commit 1d31999cf04c21709f72ceb17e65b54a401330da upstream.

adjust_lowmem_bounds() checks every memblocks in order to find the boundary
between lowmem and highmem. However some memblocks could be marked as NOMAP
so they are not used by kernel, which should be skipped while calculating
the boundary.

Signed-off-by: Chester Lin <clin@suse.com>
Reviewed-by: Mike Rapoport <rppt@linux.ibm.com>
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm/mm/mmu.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/arch/arm/mm/mmu.c
+++ b/arch/arm/mm/mmu.c
@@ -1195,6 +1195,9 @@ void __init adjust_lowmem_bounds(void)
 		phys_addr_t block_start = reg->base;
 		phys_addr_t block_end = reg->base + reg->size;
 
+		if (memblock_is_nomap(reg))
+			continue;
+
 		if (reg->base < vmalloc_limit) {
 			if (block_end > lowmem_limit)
 				/*


