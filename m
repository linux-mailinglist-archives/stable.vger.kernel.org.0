Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D84A215B25
	for <lists+stable@lfdr.de>; Tue,  7 May 2019 07:52:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727646AbfEGFvr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 May 2019 01:51:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:59304 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728929AbfEGFjr (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 May 2019 01:39:47 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4E98A20578;
        Tue,  7 May 2019 05:39:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557207586;
        bh=/PXPE8j4QrWpIB45+kYwvSBrtZU8uMuCh26U6b8XGiU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tGIqxbIAOZIzJKAvileGS0Ytyr6dFlSaA8AWqJ7ZLn8BlyAWp5GwfjE6GAV2rprcN
         Gg4Rl4TN/cN5i6Rd42sqbzPb43+XWV8+c39tCkfPHu6hsPA6Z1awKC4BVhFfhPCEx9
         slFjGDbzAP9dmu9sBN6CBOlIxjcxDyA91WjmyPjc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Huacai Chen <chenhc@lemote.com>,
        Paul Burton <paul.burton@mips.com>,
        Ralf Baechle <ralf@linux-mips.org>,
        James Hogan <jhogan@kernel.org>, linux-mips@linux-mips.org,
        Fuxin Zhang <zhangfx@lemote.com>,
        Zhangjin Wu <wuzhangjin@gmail.com>,
        Huacai Chen <chenhuacai@gmail.com>,
        Sasha Levin <alexander.levin@microsoft.com>,
        linux-mips@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 37/95] MIPS: VDSO: Reduce VDSO_RANDOMIZE_SIZE to 64MB for 64bit
Date:   Tue,  7 May 2019 01:37:26 -0400
Message-Id: <20190507053826.31622-37-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190507053826.31622-1-sashal@kernel.org>
References: <20190507053826.31622-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Huacai Chen <chenhc@lemote.com>

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
index 8bbbab611a3f..0b86a01de956 100644
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

