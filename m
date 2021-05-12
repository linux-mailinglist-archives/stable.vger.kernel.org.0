Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C22F37C8CD
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 18:43:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234746AbhELQNB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:13:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:34634 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239110AbhELQHW (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:07:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id ACEC961C3A;
        Wed, 12 May 2021 15:36:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620833779;
        bh=ME+o8qVmDRw6Mq9SpL5ndvS2yjgea2XcS6Yz5PbfQF0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZrWH0NCW0UUyx8XXaEDkQJUpENwROHiBUEZ/zYUQEk63QgczguPcT4CN6GKFE4GcD
         iSKcZ9lcwNlZgYLsEgojG2eCP2qi6rObxeoH/7pvAAhvsgKeU8rEV2Md/0NUJzYMhQ
         GePIYUyIqEXh6MjiHMsgCTCDOSX9bycculvdhDVY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Liam R. Howlett" <Liam.Howlett@Oracle.com>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 284/601] m68k: Add missing mmap_read_lock() to sys_cacheflush()
Date:   Wed, 12 May 2021 16:46:01 +0200
Message-Id: <20210512144837.165035545@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144827.811958675@linuxfoundation.org>
References: <20210512144827.811958675@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Liam Howlett <liam.howlett@oracle.com>

[ Upstream commit f829b4b212a315b912cb23fd10aaf30534bb5ce9 ]

When the superuser flushes the entire cache, the mmap_read_lock() is not
taken, but mmap_read_unlock() is called.  Add the missing
mmap_read_lock() call.

Fixes: cd2567b6850b1648 ("m68k: call find_vma with the mmap_sem held in sys_cacheflush()")
Signed-off-by: Liam R. Howlett <Liam.Howlett@Oracle.com>
Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Link: https://lore.kernel.org/r/20210407200032.764445-1-Liam.Howlett@Oracle.com
Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/m68k/kernel/sys_m68k.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/m68k/kernel/sys_m68k.c b/arch/m68k/kernel/sys_m68k.c
index 1c235d8f53f3..f55bdcb8e4f1 100644
--- a/arch/m68k/kernel/sys_m68k.c
+++ b/arch/m68k/kernel/sys_m68k.c
@@ -388,6 +388,8 @@ sys_cacheflush (unsigned long addr, int scope, int cache, unsigned long len)
 		ret = -EPERM;
 		if (!capable(CAP_SYS_ADMIN))
 			goto out;
+
+		mmap_read_lock(current->mm);
 	} else {
 		struct vm_area_struct *vma;
 
-- 
2.30.2



