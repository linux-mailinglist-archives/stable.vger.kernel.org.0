Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 271D02E1670
	for <lists+stable@lfdr.de>; Wed, 23 Dec 2020 04:10:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728601AbgLWCTV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Dec 2020 21:19:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:46354 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728597AbgLWCTV (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 22 Dec 2020 21:19:21 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1A3B322955;
        Wed, 23 Dec 2020 02:18:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608689918;
        bh=/miiF3NYHv/ngXlvYwmcgZu50Pq/GYCPZDKS7OIoEeo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZAb+U/xBclSpDDgBqwSNZFUF3qMWYEkrpmGhbnjiXbmOmrCZWMdHtVg78Tw3BleAC
         8Tg0c12zu9Ei3iXboSPLcjTJLxNsa4SQ374e1N2bb2Rg+nxbNE207/2LEMP6EZ1BZp
         eM47rjEGhtemDtLBPdlAP0Jh1sWK1ehHjlUjO+kUyydgGsxOIdG0x4JEIAvIiQItWW
         WT9GwTPjg84RDRAKTG0Ai/LOJZQl1Qzvd2HLTw/ignZ86rsU6UFJaRCs+EUZnvSKCt
         CiJgRmkbHKhg/HkC04uIu8efibLN8fBBGNv30PeHDYlq7XnxuDbr+Nnbi4j2KLeqBt
         2LHTFir/dHQ5w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Qinglang Miao <miaoqinglang@huawei.com>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Sasha Levin <sashal@kernel.org>, linux-mips@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 019/130] mips: cm: add missing iounmap() on error in mips_cm_probe()
Date:   Tue, 22 Dec 2020 21:16:22 -0500
Message-Id: <20201223021813.2791612-19-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201223021813.2791612-1-sashal@kernel.org>
References: <20201223021813.2791612-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qinglang Miao <miaoqinglang@huawei.com>

[ Upstream commit 2673ecf9586551c5bcee499c1cc1949f6f7cc9a1 ]

Add the missing iounmap() of iounmap(mips_gcr_base) before
return from mips_cm_probe() in the error handling case.

Signed-off-by: Qinglang Miao <miaoqinglang@huawei.com>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/kernel/mips-cm.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/mips/kernel/mips-cm.c b/arch/mips/kernel/mips-cm.c
index a9eab83d9148d..f6a82ad010603 100644
--- a/arch/mips/kernel/mips-cm.c
+++ b/arch/mips/kernel/mips-cm.c
@@ -224,6 +224,7 @@ int mips_cm_probe(void)
 	if ((base_reg & CM_GCR_BASE_GCRBASE) != addr) {
 		pr_err("GCRs appear to have been moved (expected them at 0x%08lx)!\n",
 		       (unsigned long)addr);
+		iounmap(mips_gcr_base);
 		mips_gcr_base = NULL;
 		return -ENODEV;
 	}
-- 
2.27.0

