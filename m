Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C776D45C179
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 14:16:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244244AbhKXNTL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 08:19:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:35226 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347148AbhKXNPP (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 08:15:15 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B1F0E61A8E;
        Wed, 24 Nov 2021 12:43:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637757833;
        bh=/Or6VV6h/c/sT9ZMedJR4vcm/4fKsoKnR17pm6XPkaU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dlYisiF4OET2XK5nBtOul8sRa3UzY8+aKc/gLcNkGi1d5r72cSQftfXTpZVFJgXY+
         icd3ADaxqOl63nSghP38KZ7/Rtf99PqPm9DJfv79siM2+OGUDJF7C+mLVLQM3U+lk9
         30qkZ9mGj1dewjcBrSQXxw0LXFY/xGzQ3YY9vT9o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Colin Ian King <colin.i.king@gmail.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 290/323] MIPS: generic/yamon-dt: fix uninitialized variable error
Date:   Wed, 24 Nov 2021 12:58:00 +0100
Message-Id: <20211124115728.693202643@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115718.822024889@linuxfoundation.org>
References: <20211124115718.822024889@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Colin Ian King <colin.i.king@googlemail.com>

[ Upstream commit 255e51da15baed47531beefd02f222e4dc01f1c1 ]

In the case where fw_getenv returns an error when fetching values
for ememsizea and memsize then variable phys_memsize is not assigned
a variable and will be uninitialized on a zero check of phys_memsize.
Fix this by initializing phys_memsize to zero.

Cleans up cppcheck error:
arch/mips/generic/yamon-dt.c:100:7: error: Uninitialized variable: phys_memsize [uninitvar]

Fixes: f41d2430bbd6 ("MIPS: generic/yamon-dt: Support > 256MB of RAM")
Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/generic/yamon-dt.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/mips/generic/yamon-dt.c b/arch/mips/generic/yamon-dt.c
index 7ba4ad5cc1d66..7b7ba0f76c60e 100644
--- a/arch/mips/generic/yamon-dt.c
+++ b/arch/mips/generic/yamon-dt.c
@@ -79,7 +79,7 @@ static unsigned int __init gen_fdt_mem_array(
 __init int yamon_dt_append_memory(void *fdt,
 				  const struct yamon_mem_region *regions)
 {
-	unsigned long phys_memsize, memsize;
+	unsigned long phys_memsize = 0, memsize;
 	__be32 mem_array[2 * MAX_MEM_ARRAY_ENTRIES];
 	unsigned int mem_entries;
 	int i, err, mem_off;
-- 
2.33.0



