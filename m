Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4FC6B111D58
	for <lists+stable@lfdr.de>; Tue,  3 Dec 2019 23:53:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729844AbfLCWwd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Dec 2019 17:52:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:45260 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729885AbfLCWwa (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Dec 2019 17:52:30 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 60BD220866;
        Tue,  3 Dec 2019 22:52:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575413549;
        bh=izK4Rc8kYWh9KGFX6RBX3GX86iujtmb7+i2OeQju9NI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=x8i7XcC4Aj8MI/4+p0VJLo4iZrPAdnYRBrFG1te7L6zYDSZ/ZwmGjWt1UutSN51ca
         558B4lqq0cv8At8TGixP9/Qmg2b+gt8oD6WzlPefpRsz0+sQSde+dsXp4Ofy+vBCfD
         qm0Qx1kKPJ2xxM1sshuGkgodfdahNfft7EgyADAA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 168/321] powerpc/44x/bamboo: Fix PCI range
Date:   Tue,  3 Dec 2019 23:33:54 +0100
Message-Id: <20191203223435.876001811@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191203223427.103571230@linuxfoundation.org>
References: <20191203223427.103571230@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



