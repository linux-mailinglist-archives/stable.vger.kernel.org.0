Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91A2D3783BB
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 12:47:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231804AbhEJKrO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 06:47:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:57348 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233077AbhEJKpC (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 06:45:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 16B6A61878;
        Mon, 10 May 2021 10:34:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620642877;
        bh=gsOQbo2ysZ5oy6Px+xkTTDiCAZGBktXiZkezgWpZymY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jk/uD9fwaGBrkiGsKxvWS22MoBPtB9ZHP9+7NfK3Ktw4+nuxE07MsZzMAyJZ7Vf3N
         UKSI+tJ35quv1rB+Du1+vXZnhY6nWIqwKbGJzMsYCqfFRT9VYDPl6FDUHjPh90Ci3q
         28dTxeF2H+m21Gvq1TY6zPtGQIZl+bFQzULA5GKE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Robin Murphy <robin.murphy@arm.com>,
        Will Deacon <will@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 081/299] perf/arm_pmu_platform: Fix error handling
Date:   Mon, 10 May 2021 12:17:58 +0200
Message-Id: <20210510102007.602525136@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510102004.821838356@linuxfoundation.org>
References: <20210510102004.821838356@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Robin Murphy <robin.murphy@arm.com>

[ Upstream commit e338cb6bef254821a8c095018fd27254d74bfd6a ]

If we're aborting after failing to register the PMU device,
we probably don't want to leak the IRQs that we've claimed.

Signed-off-by: Robin Murphy <robin.murphy@arm.com>
Link: https://lore.kernel.org/r/53031a607fc8412a60024bfb3bb8cd7141f998f5.1616774562.git.robin.murphy@arm.com
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/perf/arm_pmu_platform.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/perf/arm_pmu_platform.c b/drivers/perf/arm_pmu_platform.c
index bb6ae955083a..ef9676418c9f 100644
--- a/drivers/perf/arm_pmu_platform.c
+++ b/drivers/perf/arm_pmu_platform.c
@@ -235,7 +235,7 @@ int arm_pmu_device_probe(struct platform_device *pdev,
 
 	ret = armpmu_register(pmu);
 	if (ret)
-		goto out_free;
+		goto out_free_irqs;
 
 	return 0;
 
-- 
2.30.2



