Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 762FA45C52B
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 14:52:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352327AbhKXNzS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 08:55:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:41092 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1354434AbhKXNur (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 08:50:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 054886138D;
        Wed, 24 Nov 2021 13:03:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637759027;
        bh=cscOIDw0U6YNMei0MsnO1G295KgXjmXa8uXwkoryhn8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BgizpuqMcZtO2Ilpu5msI7NmtUqR/BOlHcL/1J7Z99iW28TV2k1zwgdRcMh8XxP7q
         ja7v4jGwZC83LmcTJKZdsd1yZ1w7zwr1PWiW7dDf0+30D+1VTbnxI0R6wpEKFWp5Ri
         41pCdkj78YC/J68jNkM8CgY87alAhpzYR/1tnCv0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@somainline.org>,
        Marijn Suijten <marijn.suijten@somainline.org>,
        Konrad Dybcio <konrad.dybcio@somainline.org>,
        Alex Elder <elder@linaro.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 109/279] net/ipa: ipa_resource: Fix wrong for loop range
Date:   Wed, 24 Nov 2021 12:56:36 +0100
Message-Id: <20211124115722.547047488@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115718.776172708@linuxfoundation.org>
References: <20211124115718.776172708@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Konrad Dybcio <konrad.dybcio@somainline.org>

[ Upstream commit 27df68d579c67ef6c39a5047559b6a7c08c96219 ]

The source group count was mistakenly assigned to both dst and src loops.
Fix it to make IPA probe and work again.

Fixes: 4fd704b3608a ("net: ipa: record number of groups in data")
Acked-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@somainline.org>
Reviewed-by: Marijn Suijten <marijn.suijten@somainline.org>
Signed-off-by: Konrad Dybcio <konrad.dybcio@somainline.org>
Reviewed-by: Alex Elder <elder@linaro.org>
Link: https://lore.kernel.org/r/20211111183724.593478-1-konrad.dybcio@somainline.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ipa/ipa_resource.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ipa/ipa_resource.c b/drivers/net/ipa/ipa_resource.c
index e3da95d694099..06cec71993823 100644
--- a/drivers/net/ipa/ipa_resource.c
+++ b/drivers/net/ipa/ipa_resource.c
@@ -52,7 +52,7 @@ static bool ipa_resource_limits_valid(struct ipa *ipa,
 				return false;
 	}
 
-	group_count = data->rsrc_group_src_count;
+	group_count = data->rsrc_group_dst_count;
 	if (!group_count || group_count > IPA_RESOURCE_GROUP_MAX)
 		return false;
 
-- 
2.33.0



