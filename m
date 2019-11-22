Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C48F71062B4
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 07:06:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727998AbfKVGCY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 01:02:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:40968 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729703AbfKVGCX (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 01:02:23 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E5C582068F;
        Fri, 22 Nov 2019 06:02:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574402542;
        bh=ZhJ+AoQEj/5MiznVVd92YNDSv6J7kOWoIuf5m+J3hN0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UWI1jAbpNly2raH29oPqNAjyXPIutIKhM60O/XzKZjwZMD7vw/qWcqWa4Vo0jG0tb
         GwQ4NFfL/1coTVqGvfx/f5PGFebyF3bkBR79sObp4H/DWiMsMbLjd0WIasZyVGyQJp
         8nY0uIqI0e5l//h9yc7vTaOPHXMBkgdTZh3VUPO8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>, devicetree@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 4.9 49/91] powerpc/44x/bamboo: Fix PCI range
Date:   Fri, 22 Nov 2019 01:00:47 -0500
Message-Id: <20191122060129.4239-48-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191122060129.4239-1-sashal@kernel.org>
References: <20191122060129.4239-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Benjamin Herrenschmidt <benh@kernel.crashing.org>

[ Upstream commit 3cfb9ebe906b51f2942b1e251009bb251efd2ba6 ]

The bamboo dts has a bug: it uses a non-naturally aligned range
for PCI memory space. This isnt' supported by the code, thus
causing PCI to break on this system.

This is due to the fact that while the chip memory map has 1G
reserved for PCI memory, it's only 512M aligned. The code doesn't
know how to split that into 2 different PMMs and fails, so limit
the region to 512M.

Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/boot/dts/bamboo.dts | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/powerpc/boot/dts/bamboo.dts b/arch/powerpc/boot/dts/bamboo.dts
index aa68911f6560a..084b82ba74933 100644
--- a/arch/powerpc/boot/dts/bamboo.dts
+++ b/arch/powerpc/boot/dts/bamboo.dts
@@ -268,8 +268,10 @@
 			/* Outbound ranges, one memory and one IO,
 			 * later cannot be changed. Chip supports a second
 			 * IO range but we don't use it for now
+			 * The chip also supports a larger memory range but
+			 * it's not naturally aligned, so our code will break
 			 */
-			ranges = <0x02000000 0x00000000 0xa0000000 0x00000000 0xa0000000 0x00000000 0x40000000
+			ranges = <0x02000000 0x00000000 0xa0000000 0x00000000 0xa0000000 0x00000000 0x20000000
 				  0x02000000 0x00000000 0x00000000 0x00000000 0xe0000000 0x00000000 0x00100000
 				  0x01000000 0x00000000 0x00000000 0x00000000 0xe8000000 0x00000000 0x00010000>;
 
-- 
2.20.1

