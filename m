Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D1D03C526B
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:50:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346138AbhGLHp7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:45:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:51582 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344170AbhGLHnq (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:43:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 539D0611AF;
        Mon, 12 Jul 2021 07:40:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626075647;
        bh=cbgs1SGUcedEgEdkW/yzwtzqbt3aTxMQlZTcNFUyT6g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=I7Phqz95fJHOE6wuhLy4agADBXKVb1glQbe+7FPFnN7weYHKFDs5gR0KasKw/dvPC
         FpWyfBtq3Mfrdh/40Bl12Zzbju4Mg5AqGiJYjki+CyW/b4QacXKoP2a16jibtFYr6k
         uix4tdXM7YWbXQY5kEfDM1TnPtsp/AF0u6MK/a1A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Will Deacon <will@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Shaokun Zhang <zhangshaokun@hisilicon.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 305/800] drivers/perf: hisi: Fix data source control
Date:   Mon, 12 Jul 2021 08:05:28 +0200
Message-Id: <20210712060957.856300353@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
References: <20210712060912.995381202@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shaokun Zhang <zhangshaokun@hisilicon.com>

[ Upstream commit 814be609baae62aaa6c02fa6f3ad66cff32a6d15 ]

'Data source' is a new function for HHA PMU and config / clear
interface was wrong by mistake. 'HHA_DATSRC_CTRL' register is
mainly used for data source configuration, if we enable bit0
as driver, it will go on count the event and we didn't check
it carefully. So fix the issue and do as the initial purpose.

Fixes: 932f6a99f9b0 ("drivers/perf: hisi: Add new functions for HHA PMU")
Reported-by: kernel test robot <lkp@intel.com>
Cc: Will Deacon <will@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Shaokun Zhang <zhangshaokun@hisilicon.com>
Link: https://lore.kernel.org/r/1622709291-37996-1-git-send-email-zhangshaokun@hisilicon.com
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/perf/hisilicon/hisi_uncore_hha_pmu.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/perf/hisilicon/hisi_uncore_hha_pmu.c b/drivers/perf/hisilicon/hisi_uncore_hha_pmu.c
index 0316fabe32f1..acc864bded2b 100644
--- a/drivers/perf/hisilicon/hisi_uncore_hha_pmu.c
+++ b/drivers/perf/hisilicon/hisi_uncore_hha_pmu.c
@@ -90,7 +90,7 @@ static void hisi_hha_pmu_config_ds(struct perf_event *event)
 
 		val = readl(hha_pmu->base + HHA_DATSRC_CTRL);
 		val |= HHA_DATSRC_SKT_EN;
-		writel(ds_skt, hha_pmu->base + HHA_DATSRC_CTRL);
+		writel(val, hha_pmu->base + HHA_DATSRC_CTRL);
 	}
 }
 
@@ -104,7 +104,7 @@ static void hisi_hha_pmu_clear_ds(struct perf_event *event)
 
 		val = readl(hha_pmu->base + HHA_DATSRC_CTRL);
 		val &= ~HHA_DATSRC_SKT_EN;
-		writel(ds_skt, hha_pmu->base + HHA_DATSRC_CTRL);
+		writel(val, hha_pmu->base + HHA_DATSRC_CTRL);
 	}
 }
 
-- 
2.30.2



