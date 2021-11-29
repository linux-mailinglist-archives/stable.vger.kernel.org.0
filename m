Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17550462779
	for <lists+stable@lfdr.de>; Tue, 30 Nov 2021 00:03:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237012AbhK2XGM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 18:06:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237257AbhK2XFd (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 18:05:33 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10005C1E0FD7;
        Mon, 29 Nov 2021 10:42:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 5B885CE13AA;
        Mon, 29 Nov 2021 18:42:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 068DFC53FCD;
        Mon, 29 Nov 2021 18:42:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638211327;
        bh=eavAY0EobuW/38b4OyVeEQV5SLGhQ5UHT84W+MIoi5o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WKFxosmN5pHA5FbVqB8KwDWU7viaAHi++ZHMaG3LW0uCY2mn1fwZGM7IVjsguEPa6
         cYwUsSjRfoMzFfzMMPlRjyKTMmIOKsY1set1mYpEMJXxYkcgX5VS4uyHivtjVGaNrk
         4XtglDDyR27ThXZeSQ4oznNSesPnVSXVgmsIoiw0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alex Bee <knaerzche@gmail.com>,
        Peter Geis <pgwipeout@gmail.com>,
        Heiko Stuebner <heiko@sntech.de>,
        Dan Johansen <strit@manjaro.org>,
        Benjamin Gaignard <benjamin.gaignard@collabora.com>,
        Joerg Roedel <jroedel@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 158/179] iommu/rockchip: Fix PAGE_DESC_HI_MASKs for RK3568
Date:   Mon, 29 Nov 2021 19:19:12 +0100
Message-Id: <20211129181724.144640534@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211129181718.913038547@linuxfoundation.org>
References: <20211129181718.913038547@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alex Bee <knaerzche@gmail.com>

[ Upstream commit f7ff3cff3527ff1e70cad8d2fe7c0c7b6f83120a ]

With the submission of iommu driver for RK3568 a subtle bug was
introduced: PAGE_DESC_HI_MASK1 and PAGE_DESC_HI_MASK2 have to be
the other way arround - that leads to random errors, especially when
addresses beyond 32 bit are used.

Fix it.

Fixes: c55356c534aa ("iommu: rockchip: Add support for iommu v2")
Signed-off-by: Alex Bee <knaerzche@gmail.com>
Tested-by: Peter Geis <pgwipeout@gmail.com>
Reviewed-by: Heiko Stuebner <heiko@sntech.de>
Tested-by: Dan Johansen <strit@manjaro.org>
Reviewed-by: Benjamin Gaignard <benjamin.gaignard@collabora.com>
Link: https://lore.kernel.org/r/20211124021325.858139-1-knaerzche@gmail.com
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/rockchip-iommu.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/iommu/rockchip-iommu.c b/drivers/iommu/rockchip-iommu.c
index 5cb260820eda6..7f23ad61c094f 100644
--- a/drivers/iommu/rockchip-iommu.c
+++ b/drivers/iommu/rockchip-iommu.c
@@ -200,8 +200,8 @@ static inline phys_addr_t rk_dte_pt_address(u32 dte)
 #define DTE_HI_MASK2	GENMASK(7, 4)
 #define DTE_HI_SHIFT1	24 /* shift bit 8 to bit 32 */
 #define DTE_HI_SHIFT2	32 /* shift bit 4 to bit 36 */
-#define PAGE_DESC_HI_MASK1	GENMASK_ULL(39, 36)
-#define PAGE_DESC_HI_MASK2	GENMASK_ULL(35, 32)
+#define PAGE_DESC_HI_MASK1	GENMASK_ULL(35, 32)
+#define PAGE_DESC_HI_MASK2	GENMASK_ULL(39, 36)
 
 static inline phys_addr_t rk_dte_pt_address_v2(u32 dte)
 {
-- 
2.33.0



