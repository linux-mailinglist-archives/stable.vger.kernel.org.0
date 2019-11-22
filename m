Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4F5B6106563
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 07:24:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728164AbfKVFvb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 00:51:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:56620 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728144AbfKVFv3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 00:51:29 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 248592071F;
        Fri, 22 Nov 2019 05:51:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574401888;
        bh=izK4Rc8kYWh9KGFX6RBX3GX86iujtmb7+i2OeQju9NI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Hnu5P6jdeZFHFo5YBH3CRMeeOc+JFq7caTRUVnZqrpficTxI5LU6PGLt8+KuBR2zk
         Iwx31eTwC7iDXSPOlx5//qrAJdlKZYnfZQXuvt80hVbgg5Tt9HwcPYQMuZoLE6kn5z
         TIBc8ezWJLb1MJOwJAjm8uKEQX3bgfCYX2BK5uks=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>, devicetree@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 4.19 122/219] powerpc/44x/bamboo: Fix PCI range
Date:   Fri, 22 Nov 2019 00:47:34 -0500
Message-Id: <20191122054911.1750-115-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191122054911.1750-1-sashal@kernel.org>
References: <20191122054911.1750-1-sashal@kernel.org>
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
index 538e42b1120d8..b5861fa3836c1 100644
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

