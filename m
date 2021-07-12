Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7CB933C5092
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:46:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344457AbhGLHdk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:33:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:36898 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344552AbhGLH3f (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:29:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4BB9361627;
        Mon, 12 Jul 2021 07:25:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626074734;
        bh=/s/Wi3g9RFrPpOho4vGcaAawlTYvpho1ws/v91kSbRA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AXSkxh/WQW7+H4a/r+u0Q+66Dy2/gxrndFMwICF9rn+De6r2TdLH+9uQDAUdKy7nq
         ppTkTf1ju92SxnYvaCS3xaZyVrVT/A7AyrsiFwEXKLVMzRVvy9rS2l9bBVTxWrXwf/
         aG3w3rOjxsv+7lq1hosuf4b+//9o+6Bv5s9oIlFc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>,
        Guo Ren <guoren@linux.alibaba.com>,
        Arnd Bergmann <arnd@arndb.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 680/700] csky: syscache: Fixup duplicate cache flush
Date:   Mon, 12 Jul 2021 08:12:43 +0200
Message-Id: <20210712061048.245674502@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060924.797321836@linuxfoundation.org>
References: <20210712060924.797321836@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Guo Ren <guoren@linux.alibaba.com>

[ Upstream commit 6ea42c84f33368eb3fe1ec1bff8d7cb1a5c7b07a ]

The current csky logic of sys_cacheflush is wrong, it'll cause
icache flush call dcache flush again. Now fixup it with a
conditional "break & fallthrough".

Fixes: 997153b9a75c ("csky: Add flush_icache_mm to defer flush icache all")
Fixes: 0679d29d3e23 ("csky: fix syscache.c fallthrough warning")
Acked-by: Randy Dunlap <rdunlap@infradead.org>
Co-Developed-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Guo Ren <guoren@linux.alibaba.com>
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/csky/mm/syscache.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/arch/csky/mm/syscache.c b/arch/csky/mm/syscache.c
index 4e51d63850c4..cd847ad62c7e 100644
--- a/arch/csky/mm/syscache.c
+++ b/arch/csky/mm/syscache.c
@@ -12,15 +12,17 @@ SYSCALL_DEFINE3(cacheflush,
 		int, cache)
 {
 	switch (cache) {
-	case ICACHE:
 	case BCACHE:
-		flush_icache_mm_range(current->mm,
-				(unsigned long)addr,
-				(unsigned long)addr + bytes);
-		fallthrough;
 	case DCACHE:
 		dcache_wb_range((unsigned long)addr,
 				(unsigned long)addr + bytes);
+		if (cache != BCACHE)
+			break;
+		fallthrough;
+	case ICACHE:
+		flush_icache_mm_range(current->mm,
+				(unsigned long)addr,
+				(unsigned long)addr + bytes);
 		break;
 	default:
 		return -EINVAL;
-- 
2.30.2



