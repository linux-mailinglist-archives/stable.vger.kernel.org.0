Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3FF871CAB74
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 14:43:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728701AbgEHMno (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 08:43:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:41652 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727780AbgEHMnn (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 May 2020 08:43:43 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 72689206B8;
        Fri,  8 May 2020 12:43:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588941822;
        bh=+UonLUvEdtr8PPFBMuNNXS6iHtfJOuN0sTXFoIUiah0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bGhoY9wuxyf55UVA2h2db515X9wEOBHwS4kjt4PAeItuOjYk6eMxAJcVvbLHNf/8W
         nOC4AWyQ/0s6xHEVW4ZZDdNuhCOwI3e/B4fiZBmGHB4v0IO3urvLYAX4W5o6qFV+v9
         CIwmpQud3o8hhVJNSWO4XKGXQLkAOO9IDNo4hAH4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vince Hsu <vince.h@nvidia.com>,
        Tomasz Figa <tfiga@chromium.org>,
        Thierry Reding <treding@nvidia.com>
Subject: [PATCH 4.4 184/312] memory/tegra: Add number of TLB lines for Tegra124
Date:   Fri,  8 May 2020 14:32:55 +0200
Message-Id: <20200508123137.421884718@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200508123124.574959822@linuxfoundation.org>
References: <20200508123124.574959822@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vince Hsu <vince.h@nvidia.com>

commit e2127ae7a5e80eb53ad431c39145767391da40cd upstream.

Tegra124 was accidentally left out when the number of TLB lines was
parameterized in commit 11cec15bf3fb ("iommu/tegra-smmu: Parameterize
number of TLB lines"). Fortunately this doesn't cause any noticeable
regressions upstream, presumably because there aren't any use-cases
that exercise enough pressure on the SMMU. But it is a regression
nonetheless, so let's fix it.

Fixes: 11cec15bf3fb ("iommu/tegra-smmu: Parameterize number of TLB lines")
Signed-off-by: Vince Hsu <vince.h@nvidia.com>
Signed-off-by: Tomasz Figa <tfiga@chromium.org>
[treding@nvidia.com: extract from unrelated patch]
Signed-off-by: Thierry Reding <treding@nvidia.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/memory/tegra/tegra124.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/memory/tegra/tegra124.c
+++ b/drivers/memory/tegra/tegra124.c
@@ -1007,6 +1007,7 @@ static const struct tegra_smmu_soc tegra
 	.num_swgroups = ARRAY_SIZE(tegra124_swgroups),
 	.supports_round_robin_arbitration = true,
 	.supports_request_limit = true,
+	.num_tlb_lines = 32,
 	.num_asids = 128,
 };
 


