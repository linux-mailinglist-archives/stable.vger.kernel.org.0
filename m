Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E8AF29BC38
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 17:40:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1801785AbgJ0Pn7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 11:43:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:56344 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1801040AbgJ0PhV (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 11:37:21 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5836E22264;
        Tue, 27 Oct 2020 15:37:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603813041;
        bh=oCslFUlESiEpVn7iFFjf5E+c/u+6AHCQp4TdHxfD4dQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EFejY1PrHZq0b/Yz2yBS6gWT/Kag0bHENTFxlbS/a7wKnpLIIIyeIGvOqkmrOd3hI
         IgWQOoX/b/dPhWWZJCiz7S5qFzvdMp920e7RglNtMRRyKF3Y+aAiJEAtv4v9dtOwhj
         HVBdQT8kBH7od26MoSFU/iwMTduUeTZiL9GMWh2c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Guillaume Tucker <guillaume.tucker@collabora.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 418/757] ARM: 9007/1: l2c: fix prefetch bits init in L2X0_AUX_CTRL using DT values
Date:   Tue, 27 Oct 2020 14:51:08 +0100
Message-Id: <20201027135510.186614286@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135450.497324313@linuxfoundation.org>
References: <20201027135450.497324313@linuxfoundation.org>
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
index 12c26eb88afbc..43d91bfd23600 100644
--- a/arch/arm/mm/cache-l2x0.c
+++ b/arch/arm/mm/cache-l2x0.c
@@ -1249,20 +1249,28 @@ static void __init l2c310_of_parse(const struct device_node *np,
 
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



