Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 739F81D847D
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 20:13:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732217AbgERSD7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 14:03:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:49724 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732707AbgERSDz (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 May 2020 14:03:55 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EDCC720826;
        Mon, 18 May 2020 18:03:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589825035;
        bh=lnTYBwmGRW6zLfxTDwTanKR3Xyf16ZPytlVLC9crZzU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cpb1+lF3c9Dpe82WfR/12czlyETwuE81RiluzBWyvXZ2gN2UxZ54i6V/3hjDdmlrI
         8dDbLZaqZTQNiJ5tDEApwJc6fosuAUNBXVkGnVax/tr5Stlin06h97JBxvtF3+i6y5
         WO17pOfOxmg/ULfo6GmXh2B9Bpu3enW1yF+1QDvg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.6 103/194] arm64: fix the flush_icache_range arguments in machine_kexec
Date:   Mon, 18 May 2020 19:36:33 +0200
Message-Id: <20200518173540.492399985@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200518173531.455604187@linuxfoundation.org>
References: <20200518173531.455604187@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit d51c214541c5154dda3037289ee895ea3ded5ebd ]

The second argument is the end "pointer", not the length.

Fixes: d28f6df1305a ("arm64/kexec: Add core kexec support")
Cc: <stable@vger.kernel.org> # 4.8.x-
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kernel/machine_kexec.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/kernel/machine_kexec.c b/arch/arm64/kernel/machine_kexec.c
index 8e9c924423b4e..a0b144cfaea71 100644
--- a/arch/arm64/kernel/machine_kexec.c
+++ b/arch/arm64/kernel/machine_kexec.c
@@ -177,6 +177,7 @@ void machine_kexec(struct kimage *kimage)
 	 * the offline CPUs. Therefore, we must use the __* variant here.
 	 */
 	__flush_icache_range((uintptr_t)reboot_code_buffer,
+			     (uintptr_t)reboot_code_buffer +
 			     arm64_relocate_new_kernel_size);
 
 	/* Flush the kimage list and its buffers. */
-- 
2.20.1



