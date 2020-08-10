Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42AB2240E05
	for <lists+stable@lfdr.de>; Mon, 10 Aug 2020 21:12:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729005AbgHJTKg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Aug 2020 15:10:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:37980 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728993AbgHJTKf (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Aug 2020 15:10:35 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B87EA22B49;
        Mon, 10 Aug 2020 19:10:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597086634;
        bh=AILpoJFYFqqiQwh8J5OFU9tSJgZo+/G+qh3xcX/ibdE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cIj+DsAYXHULWOQNu62g+OQNNT4cqZcjkXhSr2kwD2ZqulMNpWucxBBCPyJfgDfIF
         aSdsPH68TR7PwEYpcOy2Qhy2cf6LgtQUDaY/VCsdMT6iqxynNdM6zNmjWEy4OqHT/j
         U/7r2qq1DjXpG422QXk7oaBXNh/0PKg1luwpv/Z4=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Guillaume Tucker <guillaume.tucker@collabora.com>,
        "kernelci.org bot" <bot@kernelci.org>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org
Subject: [PATCH AUTOSEL 5.7 04/60] ARM: exynos: clear L310_AUX_CTRL_FULL_LINE_ZERO in default l2c_aux_val
Date:   Mon, 10 Aug 2020 15:09:32 -0400
Message-Id: <20200810191028.3793884-4-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200810191028.3793884-1-sashal@kernel.org>
References: <20200810191028.3793884-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Guillaume Tucker <guillaume.tucker@collabora.com>

[ Upstream commit 5b17a04addc29201dc142c8d2c077eb7745d2e35 ]

This "alert" error message can be seen on exynos4412-odroidx2:

    L2C: platform modifies aux control register: 0x02070000 -> 0x3e470001
    L2C: platform provided aux values permit register corruption.

Followed by this plain error message:

    L2C-310: enabling full line of zeros but not enabled in Cortex-A9

To fix it, don't set the L310_AUX_CTRL_FULL_LINE_ZERO flag (bit 0) in
the default value of l2c_aux_val.  It may instead be enabled when
applicable by the logic in l2c310_enable() if the attribute
"arm,full-line-zero-disable" was set in the device tree.

The initial commit that introduced this default value was in v2.6.38
commit 1cf0eb799759 ("ARM: S5PV310: Add L2 cache init function in
cpu.c").

However, the code to set the L310_AUX_CTRL_FULL_LINE_ZERO flag and
manage that feature was added much later and the default value was not
updated then.  So this seems to have been a subtle oversight
especially since enabling it only in the cache and not in the A9 core
doesn't actually prevent the platform from running.  According to the
TRM, the opposite would be a real issue, if the feature was enabled in
the A9 core but not in the cache controller.

Reported-by: "kernelci.org bot" <bot@kernelci.org>
Signed-off-by: Guillaume Tucker <guillaume.tucker@collabora.com>
Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/mach-exynos/exynos.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/mach-exynos/exynos.c b/arch/arm/mach-exynos/exynos.c
index 7a8d1555db404..36c37444485a8 100644
--- a/arch/arm/mach-exynos/exynos.c
+++ b/arch/arm/mach-exynos/exynos.c
@@ -193,7 +193,7 @@ static void __init exynos_dt_fixup(void)
 }
 
 DT_MACHINE_START(EXYNOS_DT, "Samsung Exynos (Flattened Device Tree)")
-	.l2c_aux_val	= 0x3c400001,
+	.l2c_aux_val	= 0x3c400000,
 	.l2c_aux_mask	= 0xc20fffff,
 	.smp		= smp_ops(exynos_smp_ops),
 	.map_io		= exynos_init_io,
-- 
2.25.1

