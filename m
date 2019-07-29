Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4AF52796FE
	for <lists+stable@lfdr.de>; Mon, 29 Jul 2019 21:57:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404175AbfG2TzT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jul 2019 15:55:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:48028 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391043AbfG2TzO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jul 2019 15:55:14 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A07DC21655;
        Mon, 29 Jul 2019 19:55:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564430114;
        bh=QAMSlZC3QvZcmchYT8++WC1cQFFSEhvbbk3zcKKF7vk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qwUpvV7dYal9irOzLloJC/ywQuAUUm1ET0xReirBYfguR7ZF50lYWKHUggdlESjzl
         FNkEo2j6ZMkQCnEuGacVkUQoCGI04EpmWJKJYr32N1Qi+Uxf3cCOVsfQPmYiQJuPwB
         2LP+oeAOC058o0HtMgxcuJb5P16/DDe218Y4S8z4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 161/215] cxgb4: reduce kernel stack usage in cudbg_collect_mem_region()
Date:   Mon, 29 Jul 2019 21:22:37 +0200
Message-Id: <20190729190807.733553701@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190729190739.971253303@linuxfoundation.org>
References: <20190729190739.971253303@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 752c2ea2d8e7c23b0f64e2e7d4337f3604d44c9f ]

The cudbg_collect_mem_region() and cudbg_read_fw_mem() both use several
hundred kilobytes of kernel stack space. One gets inlined into the other,
which causes the stack usage to be combined beyond the warning limit
when building with clang:

drivers/net/ethernet/chelsio/cxgb4/cudbg_lib.c:1057:12: error: stack frame size of 1244 bytes in function 'cudbg_collect_mem_region' [-Werror,-Wframe-larger-than=]

Restructuring cudbg_collect_mem_region() lets clang do the same
optimization that gcc does and reuse the stack slots as it can
see that the large variables are never used together.

A better fix might be to avoid using cudbg_meminfo on the stack
altogether, but that requires a larger rewrite.

Fixes: a1c69520f785 ("cxgb4: collect MC memory dump")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/chelsio/cxgb4/cudbg_lib.c    | 19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/cxgb4/cudbg_lib.c b/drivers/net/ethernet/chelsio/cxgb4/cudbg_lib.c
index a76529a7662d..c2e92786608b 100644
--- a/drivers/net/ethernet/chelsio/cxgb4/cudbg_lib.c
+++ b/drivers/net/ethernet/chelsio/cxgb4/cudbg_lib.c
@@ -1054,14 +1054,12 @@ static void cudbg_t4_fwcache(struct cudbg_init *pdbg_init,
 	}
 }
 
-static int cudbg_collect_mem_region(struct cudbg_init *pdbg_init,
-				    struct cudbg_buffer *dbg_buff,
-				    struct cudbg_error *cudbg_err,
-				    u8 mem_type)
+static unsigned long cudbg_mem_region_size(struct cudbg_init *pdbg_init,
+					   struct cudbg_error *cudbg_err,
+					   u8 mem_type)
 {
 	struct adapter *padap = pdbg_init->adap;
 	struct cudbg_meminfo mem_info;
-	unsigned long size;
 	u8 mc_idx;
 	int rc;
 
@@ -1075,7 +1073,16 @@ static int cudbg_collect_mem_region(struct cudbg_init *pdbg_init,
 	if (rc)
 		return rc;
 
-	size = mem_info.avail[mc_idx].limit - mem_info.avail[mc_idx].base;
+	return mem_info.avail[mc_idx].limit - mem_info.avail[mc_idx].base;
+}
+
+static int cudbg_collect_mem_region(struct cudbg_init *pdbg_init,
+				    struct cudbg_buffer *dbg_buff,
+				    struct cudbg_error *cudbg_err,
+				    u8 mem_type)
+{
+	unsigned long size = cudbg_mem_region_size(pdbg_init, cudbg_err, mem_type);
+
 	return cudbg_read_fw_mem(pdbg_init, dbg_buff, mem_type, size,
 				 cudbg_err);
 }
-- 
2.20.1



