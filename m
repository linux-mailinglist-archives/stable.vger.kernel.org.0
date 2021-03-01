Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC914329041
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 21:08:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242783AbhCAUD5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 15:03:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:58548 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242574AbhCATyF (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 14:54:05 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B544564F5C;
        Mon,  1 Mar 2021 17:54:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614621257;
        bh=fiRzT4/mreJGNx32GLtjjuEpFzfxyAgVZMvgrCSgxgI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=c7/FiUo+Nws3casNJOYFYc/4m9qbF4gLTK7u/Tlyvm5x1DjVL9IX/P+pXlD7iiQKh
         fB0QTu2xNEd9MEPuASFYp/i36dcKaSuasm+XdfgqiV//+QLO6T2C+uDkLbRD5LxeFp
         2Wm5t0ajIO+NkQxvkwWFSCypVxPF7dpPjWfdlvQU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kees Cook <keescook@chromium.org>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Serge Semin <fancer.lancer@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 450/775] spi: dw: Avoid stack content exposure
Date:   Mon,  1 Mar 2021 17:10:18 +0100
Message-Id: <20210301161223.784126587@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kees Cook <keescook@chromium.org>

[ Upstream commit 386f771aad15dd535f2368b4adc9958c0160edd4 ]

Since "data" is u32, &data is a "u32 *" type, which means pointer math
will move in u32-sized steps. This was meant to be a byte offset, so
cast &data to "char *" to aim the copy into the correct location.

Seen with -Warray-bounds (and found by Coverity):

In file included from ./include/linux/string.h:269,
                 from ./arch/powerpc/include/asm/paca.h:15,
                 from ./arch/powerpc/include/asm/current.h:13,
                 from ./include/linux/mutex.h:14,
                 from ./include/linux/notifier.h:14,
                 from ./include/linux/clk.h:14,
                 from drivers/spi/spi-dw-bt1.c:12:
In function 'memcpy',
    inlined from 'dw_spi_bt1_dirmap_copy_from_map' at drivers/spi/spi-dw-bt1.c:87:3:
./include/linux/fortify-string.h:20:29: warning: '__builtin_memcpy' offset 4 is out of the bounds [0, 4] of object 'data' with type 'u32' {aka 'unsigned int'} [-Warray-bounds]
   20 | #define __underlying_memcpy __builtin_memcpy
      |                             ^
./include/linux/fortify-string.h:191:9: note: in expansion of macro '__underlying_memcpy'
  191 |  return __underlying_memcpy(p, q, size);
      |         ^~~~~~~~~~~~~~~~~~~
drivers/spi/spi-dw-bt1.c: In function 'dw_spi_bt1_dirmap_copy_from_map':
drivers/spi/spi-dw-bt1.c:77:6: note: 'data' declared here
   77 |  u32 data;
      |      ^~~~

Addresses-Coverity: CID 1497771 Out-of-bounds access
Fixes: abf00907538e ("spi: dw: Add Baikal-T1 SPI Controller glue driver")
Signed-off-by: Kees Cook <keescook@chromium.org>
Reviewed-by: Gustavo A. R. Silva <gustavoars@kernel.org>
Acked-by: Serge Semin <fancer.lancer@gmail.com>
Link: https://lore.kernel.org/r/20210211203714.1929862-1-keescook@chromium.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-dw-bt1.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/spi/spi-dw-bt1.c b/drivers/spi/spi-dw-bt1.c
index 4aa8596fb1f2b..5be6b7b80c21b 100644
--- a/drivers/spi/spi-dw-bt1.c
+++ b/drivers/spi/spi-dw-bt1.c
@@ -84,7 +84,7 @@ static void dw_spi_bt1_dirmap_copy_from_map(void *to, void __iomem *from, size_t
 	if (shift) {
 		chunk = min_t(size_t, 4 - shift, len);
 		data = readl_relaxed(from - shift);
-		memcpy(to, &data + shift, chunk);
+		memcpy(to, (char *)&data + shift, chunk);
 		from += chunk;
 		to += chunk;
 		len -= chunk;
-- 
2.27.0



