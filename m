Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45C414290CC
	for <lists+stable@lfdr.de>; Mon, 11 Oct 2021 16:10:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243050AbhJKOMi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Oct 2021 10:12:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:33474 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239037AbhJKOKh (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Oct 2021 10:10:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 02DE861242;
        Mon, 11 Oct 2021 14:02:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633960956;
        bh=AtWiOHeQ012tHq8/WI5vUoHmXSvGvCmXLjuAH8rua/k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Nh4TKp5syYufvFhn0P0JMDjl54j1f2ty/onY75edVg0U/XcTGCDJTkGL0njsrsN1O
         qCt7/Znmcy+cq7k2rZf9pzta6HmeVly5LBJYWpd9mymGUKJwJQILWezJBOWpRuEYt9
         MvVDL+xa44f4HzQBJ/0OL77uo4YGpiAqLI1SFcdE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tong Tiangen <tongtiangen@huawei.com>,
        Kefeng Wang <wangkefeng.wang@huawei.com>,
        Palmer Dabbelt <palmerdabbelt@google.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 125/151] riscv/vdso: make arch_setup_additional_pages wait for mmap_sem for write killable
Date:   Mon, 11 Oct 2021 15:46:37 +0200
Message-Id: <20211011134521.849236924@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211011134517.833565002@linuxfoundation.org>
References: <20211011134517.833565002@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tong Tiangen <tongtiangen@huawei.com>

[ Upstream commit 8bb0ab3ae7a4dbe6cf32deb830cf2bdbf5736867 ]

riscv architectures relying on mmap_sem for write in their
arch_setup_additional_pages. If the waiting task gets killed by the oom
killer it would block oom_reaper from asynchronous address space reclaim
and reduce the chances of timely OOM resolving.  Wait for the lock in
the killable mode and return with EINTR if the task got killed while
waiting.

Signed-off-by: Tong Tiangen <tongtiangen@huawei.com>
Reviewed-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Fixes: 76d2a0493a17 ("RISC-V: Init and Halt Code")
Signed-off-by: Palmer Dabbelt <palmerdabbelt@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/kernel/vdso.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/riscv/kernel/vdso.c b/arch/riscv/kernel/vdso.c
index e7bd92d8749b..b70956d80408 100644
--- a/arch/riscv/kernel/vdso.c
+++ b/arch/riscv/kernel/vdso.c
@@ -77,7 +77,9 @@ int arch_setup_additional_pages(struct linux_binprm *bprm,
 
 	vdso_len = (vdso_pages + VVAR_NR_PAGES) << PAGE_SHIFT;
 
-	mmap_write_lock(mm);
+	if (mmap_write_lock_killable(mm))
+		return -EINTR;
+
 	vdso_base = get_unmapped_area(NULL, 0, vdso_len, 0, 0);
 	if (IS_ERR_VALUE(vdso_base)) {
 		ret = vdso_base;
-- 
2.33.0



