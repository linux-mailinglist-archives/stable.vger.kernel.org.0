Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1BD751F1B4
	for <lists+stable@lfdr.de>; Wed, 15 May 2019 13:59:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730631AbfEOLRS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 May 2019 07:17:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:54496 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728459AbfEOLRS (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 May 2019 07:17:18 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 160EE20644;
        Wed, 15 May 2019 11:17:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557919037;
        bh=gL9fh4TwALpqLAAxA7aWBb2Vf8cfztxpiqmNPtMFfm0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=z2wj7GfZf/B09Ftw4gZRomfFGOaZgt8oUad8dN/45VyF1tzElPgO+GIlRWL+qQp/D
         o2L+l4Xjdqg+ePiK/IWNJ71yz52fn0HJGZvH4Q/4O0qE4y6UrYy1SWtM7mo4+sxTlB
         7GQ/eDBNlaEWwV5CiAoiS3MlbagDiZNfh1xP44yc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Huacai Chen <chenhc@lemote.com>,
        Paul Burton <paul.burton@mips.com>,
        Ralf Baechle <ralf@linux-mips.org>,
        James Hogan <jhogan@kernel.org>, linux-mips@linux-mips.org,
        Fuxin Zhang <zhangfx@lemote.com>,
        Zhangjin Wu <wuzhangjin@gmail.com>,
        Huacai Chen <chenhuacai@gmail.com>,
        Sasha Levin <alexander.levin@microsoft.com>
Subject: [PATCH 4.14 042/115] MIPS: VDSO: Reduce VDSO_RANDOMIZE_SIZE to 64MB for 64bit
Date:   Wed, 15 May 2019 12:55:22 +0200
Message-Id: <20190515090702.550889538@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190515090659.123121100@linuxfoundation.org>
References: <20190515090659.123121100@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit c61c7def1fa0a722610d89790e0255b74f3c07dd ]

Commit ea7e0480a4b6 ("MIPS: VDSO: Always map near top of user memory")
set VDSO_RANDOMIZE_SIZE to 256MB for 64bit kernel. But take a look at
arch/mips/mm/mmap.c we can see that MIN_GAP is 128MB, which means the
mmap_base may be at (user_address_top - 128MB). This make the stack be
surrounded by mmaped areas, then stack expanding fails and causes a
segmentation fault. Therefore, VDSO_RANDOMIZE_SIZE should be less than
MIN_GAP and this patch reduce it to 64MB.

Signed-off-by: Huacai Chen <chenhc@lemote.com>
Signed-off-by: Paul Burton <paul.burton@mips.com>
Fixes: ea7e0480a4b6 ("MIPS: VDSO: Always map near top of user memory")
Patchwork: https://patchwork.linux-mips.org/patch/20910/
Cc: Ralf Baechle <ralf@linux-mips.org>
Cc: James Hogan <jhogan@kernel.org>
Cc: linux-mips@linux-mips.org
Cc: Fuxin Zhang <zhangfx@lemote.com>
Cc: Zhangjin Wu <wuzhangjin@gmail.com>
Cc: Huacai Chen <chenhuacai@gmail.com>
Signed-off-by: Sasha Levin <alexander.levin@microsoft.com>
---
 arch/mips/include/asm/processor.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/mips/include/asm/processor.h b/arch/mips/include/asm/processor.h
index 8bbbab611a3f1..0b86a01de9562 100644
--- a/arch/mips/include/asm/processor.h
+++ b/arch/mips/include/asm/processor.h
@@ -81,7 +81,7 @@ extern unsigned int vced_count, vcei_count;
 
 #endif
 
-#define VDSO_RANDOMIZE_SIZE	(TASK_IS_32BIT_ADDR ? SZ_1M : SZ_256M)
+#define VDSO_RANDOMIZE_SIZE	(TASK_IS_32BIT_ADDR ? SZ_1M : SZ_64M)
 
 extern unsigned long mips_stack_top(void);
 #define STACK_TOP		mips_stack_top()
-- 
2.20.1



