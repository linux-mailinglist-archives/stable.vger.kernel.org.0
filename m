Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8F693BB039
	for <lists+stable@lfdr.de>; Mon,  5 Jul 2021 01:08:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230477AbhGDXH6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 4 Jul 2021 19:07:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:45944 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230367AbhGDXHq (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 4 Jul 2021 19:07:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1C1ED61364;
        Sun,  4 Jul 2021 23:05:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625439910;
        bh=MrO+vFigx9HE56U9auGXEFyBlzQMs0GCkanEowv2yT4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QoJNtDmFcX7rj8quHEkKmdwXpvt+qUhTFuSVIvVaJ+L1yNf14EvpLOAGEC1t7YIa/
         AuPrYwYrWrUqsFEHyhAc7N8N4O+Pa6XmiCYWjAqBrwbxce73Rq2zIugHlLR5iet+LW
         JVERVAoX01DuIlFJ5gEP7UZY8aNa6AxTuYX3wFSG3mRIO17DFc+mE9SMIx8Ynr01DO
         eMabi/xUtFhSa3thYyUzAK/phJe6dBpi1D/ySEdOsM+Nb+J8d6aXtXZRHhxAuG9dWT
         wJKKhz6l9POXHmzZOk3bwCX4m/oKB+hcDVsraZrxhM/wromE4cI/kkAq2wLSfPvrkK
         f9PA3yayGk5UA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tian Tao <tiantao6@hisilicon.com>, Will Deacon <will@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-perf-users@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.13 36/85] arm64: perf: Convert snprintf to sysfs_emit
Date:   Sun,  4 Jul 2021 19:03:31 -0400
Message-Id: <20210704230420.1488358-36-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210704230420.1488358-1-sashal@kernel.org>
References: <20210704230420.1488358-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index f594957e29bd..44b6eda69a81 100644
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

