Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3B203C483D
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:29:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236202AbhGLGhM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:37:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:58304 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236088AbhGLGfy (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:35:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D3955610A7;
        Mon, 12 Jul 2021 06:32:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626071579;
        bh=kUZsgb8dfS/8kleJfRU5m1xSp/sKoanlCexjaXBYWZo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R6ks/sYiV3LtQ55qxpndu6L5xyjO9QnvGBDyhL0QqxoLeUSPAZd3wnvw2dBNGVe2g
         9sbtfrXFB3EeVtUfKllsAloiAXNRr0fRXPrTuKby7HebHUxdbfEm4wwWUTP5c9s4yI
         2JSnVONJeAAT2EzCx7azYLrwD+oFWYlIKeTU1zjc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tian Tao <tiantao6@hisilicon.com>,
        Will Deacon <will@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 130/593] arm64: perf: Convert snprintf to sysfs_emit
Date:   Mon, 12 Jul 2021 08:04:50 +0200
Message-Id: <20210712060857.436400368@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060843.180606720@linuxfoundation.org>
References: <20210712060843.180606720@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tian Tao <tiantao6@hisilicon.com>

[ Upstream commit a5740e955540181f4ab8f076cc9795c6bbe4d730 ]

Use sysfs_emit instead of snprintf to avoid buf overrun,because in
sysfs_emit it strictly checks whether buf is null or buf whether
pagesize aligned, otherwise it returns an error.

Signed-off-by: Tian Tao <tiantao6@hisilicon.com>
Link: https://lore.kernel.org/r/1621497585-30887-1-git-send-email-tiantao6@hisilicon.com
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/kernel/perf_event.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm64/kernel/perf_event.c b/arch/arm64/kernel/perf_event.c
index 11852e05ee32..cdb3d4549b3a 100644
--- a/arch/arm64/kernel/perf_event.c
+++ b/arch/arm64/kernel/perf_event.c
@@ -312,7 +312,7 @@ static ssize_t slots_show(struct device *dev, struct device_attribute *attr,
 	struct arm_pmu *cpu_pmu = container_of(pmu, struct arm_pmu, pmu);
 	u32 slots = cpu_pmu->reg_pmmir & ARMV8_PMU_SLOTS_MASK;
 
-	return snprintf(page, PAGE_SIZE, "0x%08x\n", slots);
+	return sysfs_emit(page, "0x%08x\n", slots);
 }
 
 static DEVICE_ATTR_RO(slots);
-- 
2.30.2



