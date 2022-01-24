Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC0B6499A93
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:55:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1573537AbiAXVpI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:45:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377544AbiAXVhm (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:37:42 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 719CFC0BD12B;
        Mon, 24 Jan 2022 12:23:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EE8D96090A;
        Mon, 24 Jan 2022 20:23:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7D8CC340E5;
        Mon, 24 Jan 2022 20:23:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643055838;
        bh=l7UtJdL8SBoqJm1jldU5+fDq8XyAWe8H5vJ8rXhBJ5o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=znh9VTSLc/tTsENBSJQJGG0K7MI0ei3pIzurkaSVMsQrEX6w0Defk96eVplwbSGlf
         O+U3mYoGs/JxB7b5T881u5zSe2eP+oL87Qgk5sHrfT5fCqA9vomnXDXyRvPPAzp2W5
         xMmxBaDQAndOPepUA5qFmo4Axq84GDCdlb2gBRtQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Johannes Berg <johannes.berg@intel.com>,
        Richard Weinberger <richard@nod.at>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 282/846] lib/logic_iomem: Fix operation on 32-bit
Date:   Mon, 24 Jan 2022 19:36:39 +0100
Message-Id: <20220124184110.654106787@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 4e8a5edac5010820e7c5303fc96f5a262e096bb6 ]

On 32-bit, the first entry might be at 0/NULL, but that's
strange and leads to issues, e.g. where we check "if (ret)".
Use a IOREMAP_BIAS/IOREMAP_MASK of 0x80000000UL to avoid
this. This then requires reducing the number of areas (via
MAX_AREAS), but we still have 128 areas, which is enough.

Fixes: ca2e334232b6 ("lib: add iomem emulation (logic_iomem)")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/logic_iomem.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/lib/logic_iomem.c b/lib/logic_iomem.c
index 54fa601f3300b..549b22d4bcde1 100644
--- a/lib/logic_iomem.c
+++ b/lib/logic_iomem.c
@@ -21,15 +21,15 @@ struct logic_iomem_area {
 
 #define AREA_SHIFT	24
 #define MAX_AREA_SIZE	(1 << AREA_SHIFT)
-#define MAX_AREAS	((1ULL<<32) / MAX_AREA_SIZE)
+#define MAX_AREAS	((1U << 31) / MAX_AREA_SIZE)
 #define AREA_BITS	((MAX_AREAS - 1) << AREA_SHIFT)
 #define AREA_MASK	(MAX_AREA_SIZE - 1)
 #ifdef CONFIG_64BIT
 #define IOREMAP_BIAS	0xDEAD000000000000UL
 #define IOREMAP_MASK	0xFFFFFFFF00000000UL
 #else
-#define IOREMAP_BIAS	0
-#define IOREMAP_MASK	0
+#define IOREMAP_BIAS	0x80000000UL
+#define IOREMAP_MASK	0x80000000UL
 #endif
 
 static DEFINE_MUTEX(regions_mtx);
-- 
2.34.1



