Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6E74DC14E2
	for <lists+stable@lfdr.de>; Sun, 29 Sep 2019 16:00:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729597AbfI2N6v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Sep 2019 09:58:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:39736 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729530AbfI2N6u (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Sep 2019 09:58:50 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0F2AF21882;
        Sun, 29 Sep 2019 13:58:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569765529;
        bh=uH1HUWuKukDOrWbWpV9nwDLryxXChBQvaLLNDBn2C/c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f4z+vwNdeIM7z3dXwwUPfOHiHfjSMP2JjciCeVE/vmpRA9eVQeYyobfYdNgQNXxQl
         RFvs+g+F241lil61zr82M9mTG+jU2XfgHSohshGoXJoZLlHP6iOy5t3oh+Mizm4CCa
         7XOnxrE4k0VjddOYO4RzfBBozdXNcbKLfYSwglhA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Steven Price <steven.price@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Mike Rapoport <rppt@linux.ibm.com>,
        Christoph Hellwig <hch@lst.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 47/63] initramfs: dont free a non-existent initrd
Date:   Sun, 29 Sep 2019 15:54:20 +0200
Message-Id: <20190929135039.770549694@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190929135031.382429403@linuxfoundation.org>
References: <20190929135031.382429403@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Steven Price <steven.price@arm.com>

[ Upstream commit 5d59aa8f9ce972b472201aed86e904bb75879ff0 ]

Since commit 54c7a8916a88 ("initramfs: free initrd memory if opening
/initrd.image fails"), the kernel has unconditionally attempted to free
the initrd even if it doesn't exist.

In the non-existent case this causes a boot-time splat if
CONFIG_DEBUG_VIRTUAL is enabled due to a call to virt_to_phys() with a
NULL address.

Instead we should check that the initrd actually exists and only attempt
to free it if it does.

Link: http://lkml.kernel.org/r/20190516143125.48948-1-steven.price@arm.com
Fixes: 54c7a8916a88 ("initramfs: free initrd memory if opening /initrd.image fails")
Signed-off-by: Steven Price <steven.price@arm.com>
Reported-by: Mark Rutland <mark.rutland@arm.com>
Tested-by: Mark Rutland <mark.rutland@arm.com>
Reviewed-by: Mike Rapoport <rppt@linux.ibm.com>
Cc: Christoph Hellwig <hch@lst.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 init/initramfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/init/initramfs.c b/init/initramfs.c
index cd5fb00fcb549..dab8d63459f63 100644
--- a/init/initramfs.c
+++ b/init/initramfs.c
@@ -524,7 +524,7 @@ static void __init free_initrd(void)
 	unsigned long crashk_start = (unsigned long)__va(crashk_res.start);
 	unsigned long crashk_end   = (unsigned long)__va(crashk_res.end);
 #endif
-	if (do_retain_initrd)
+	if (do_retain_initrd || !initrd_start)
 		goto skip;
 
 #ifdef CONFIG_KEXEC_CORE
-- 
2.20.1



