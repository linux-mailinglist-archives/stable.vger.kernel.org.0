Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 752B31134BC
	for <lists+stable@lfdr.de>; Wed,  4 Dec 2019 19:28:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729026AbfLDR7I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Dec 2019 12:59:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:34798 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729017AbfLDR7E (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Dec 2019 12:59:04 -0500
Received: from localhost (unknown [217.68.49.72])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 15DC42084B;
        Wed,  4 Dec 2019 17:59:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575482343;
        bh=ZhJ+AoQEj/5MiznVVd92YNDSv6J7kOWoIuf5m+J3hN0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zr/sib75x+BLq16m3z2935c4CPKI0tyzXznEIU9+umNcHa/FAXHSJLQacf+RqBwWd
         uSy27Evlk7yXMYTlI3/h3VQLz9LJ70XK4KiPL+cXUGJCSuntv+1F7ShAazdaBDU6aU
         DYPCuSbJwy09SarhKAI2jcNoUp6PXcoZnGFN5hsQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 50/92] powerpc/44x/bamboo: Fix PCI range
Date:   Wed,  4 Dec 2019 18:49:50 +0100
Message-Id: <20191204174333.485365460@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191204174327.215426506@linuxfoundation.org>
References: <20191204174327.215426506@linuxfoundation.org>
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



