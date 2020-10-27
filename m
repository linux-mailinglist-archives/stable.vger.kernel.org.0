Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B2D329AE7B
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 15:01:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2441884AbgJ0OAy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 10:00:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:48432 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753590AbgJ0OAx (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:00:53 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2B11921D7B;
        Tue, 27 Oct 2020 14:00:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603807252;
        bh=71RSy4/ywzh9HOc4pC4rijPq9qiNxmStj1VnLhKexwA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fWTa3mpVbWiR/atM7QWbUIDiudphWG86v+Sk6iR087E8gEMAvCUxC/ZfKjX124KlV
         WyHKpyxmLPyzCAvT2L83F0005jRZyARiFvacOehm3wC29nqBvxYzSnyxwUU97HuqdL
         LYLuofLvyPfPb5JcT0LrkSfXv0ysdQVc9skaI6yk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Guillaume Tucker <guillaume.tucker@collabora.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 058/112] ARM: 9007/1: l2c: fix prefetch bits init in L2X0_AUX_CTRL using DT values
Date:   Tue, 27 Oct 2020 14:49:28 +0100
Message-Id: <20201027134903.313912675@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027134900.532249571@linuxfoundation.org>
References: <20201027134900.532249571@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Guillaume Tucker <guillaume.tucker@collabora.com>

[ Upstream commit 8e007b367a59bcdf484c81f6df9bd5a4cc179ca6 ]

The L310_PREFETCH_CTRL register bits 28 and 29 to enable data and
instruction prefetch respectively can also be accessed via the
L2X0_AUX_CTRL register.  They appear to be actually wired together in
hardware between the registers.  Changing them in the prefetch
register only will get undone when restoring the aux control register
later on.  For this reason, set these bits in both registers during
initialisation according to the devicetree property values.

Link: https://lore.kernel.org/lkml/76f2f3ad5e77e356e0a5b99ceee1e774a2842c25.1597061474.git.guillaume.tucker@collabora.com/

Fixes: ec3bd0e68a67 ("ARM: 8391/1: l2c: add options to overwrite prefetching behavior")
Signed-off-by: Guillaume Tucker <guillaume.tucker@collabora.com>
Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/mm/cache-l2x0.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/arch/arm/mm/cache-l2x0.c b/arch/arm/mm/cache-l2x0.c
index 493692d838c67..0b6f8a93d8c60 100644
--- a/arch/arm/mm/cache-l2x0.c
+++ b/arch/arm/mm/cache-l2x0.c
@@ -1228,20 +1228,28 @@ static void __init l2c310_of_parse(const struct device_node *np,
 
 	ret = of_property_read_u32(np, "prefetch-data", &val);
 	if (ret == 0) {
-		if (val)
+		if (val) {
 			prefetch |= L310_PREFETCH_CTRL_DATA_PREFETCH;
-		else
+			*aux_val |= L310_PREFETCH_CTRL_DATA_PREFETCH;
+		} else {
 			prefetch &= ~L310_PREFETCH_CTRL_DATA_PREFETCH;
+			*aux_val &= ~L310_PREFETCH_CTRL_DATA_PREFETCH;
+		}
+		*aux_mask &= ~L310_PREFETCH_CTRL_DATA_PREFETCH;
 	} else if (ret != -EINVAL) {
 		pr_err("L2C-310 OF prefetch-data property value is missing\n");
 	}
 
 	ret = of_property_read_u32(np, "prefetch-instr", &val);
 	if (ret == 0) {
-		if (val)
+		if (val) {
 			prefetch |= L310_PREFETCH_CTRL_INSTR_PREFETCH;
-		else
+			*aux_val |= L310_PREFETCH_CTRL_INSTR_PREFETCH;
+		} else {
 			prefetch &= ~L310_PREFETCH_CTRL_INSTR_PREFETCH;
+			*aux_val &= ~L310_PREFETCH_CTRL_INSTR_PREFETCH;
+		}
+		*aux_mask &= ~L310_PREFETCH_CTRL_INSTR_PREFETCH;
 	} else if (ret != -EINVAL) {
 		pr_err("L2C-310 OF prefetch-instr property value is missing\n");
 	}
-- 
2.25.1



