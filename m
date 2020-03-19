Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E1EED18B66F
	for <lists+stable@lfdr.de>; Thu, 19 Mar 2020 14:27:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730835AbgCSN05 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Mar 2020 09:26:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:55034 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730832AbgCSN05 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Mar 2020 09:26:57 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 32278207FC;
        Thu, 19 Mar 2020 13:26:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584624416;
        bh=qWd20iwAOFru1dkdrmNhZZetuO5TaElp0urtUJVUjOk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lAPax4ipGwTOSq5JUgOARFk7v/rziTxBFAYZsk1XaBem0yBerNpdOeEPGhnkYS2Cm
         CVC2vbyRkNC/rKlfl8xPRs56DZPw85HtPwfbRyKdKXPGOrp5wC+7iQTFxDVzMO3Xem
         h1rsez5XQ2C68IVpJAxcvf/OfeBW/shuwU/uQ9NA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Monk Liu <Monk.Liu@amd.com>,
        Hawking Zhang <Hawking.Zhang@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.5 35/65] drm/amdgpu: fix memory leak during TDR test(v2)
Date:   Thu, 19 Mar 2020 14:04:17 +0100
Message-Id: <20200319123937.637687088@linuxfoundation.org>
X-Mailer: git-send-email 2.25.2
In-Reply-To: <20200319123926.466988514@linuxfoundation.org>
References: <20200319123926.466988514@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Monk Liu <Monk.Liu@amd.com>

[ Upstream commit 4829f89855f1d3a3d8014e74cceab51b421503db ]

fix system memory leak

v2:
fix coding style

Signed-off-by: Monk Liu <Monk.Liu@amd.com>
Reviewed-by: Hawking Zhang <Hawking.Zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/powerplay/smu_v11_0.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/powerplay/smu_v11_0.c b/drivers/gpu/drm/amd/powerplay/smu_v11_0.c
index 8b13d18c6414c..e4149e6b68b39 100644
--- a/drivers/gpu/drm/amd/powerplay/smu_v11_0.c
+++ b/drivers/gpu/drm/amd/powerplay/smu_v11_0.c
@@ -948,8 +948,12 @@ int smu_v11_0_init_max_sustainable_clocks(struct smu_context *smu)
 	struct smu_11_0_max_sustainable_clocks *max_sustainable_clocks;
 	int ret = 0;
 
-	max_sustainable_clocks = kzalloc(sizeof(struct smu_11_0_max_sustainable_clocks),
+	if (!smu->smu_table.max_sustainable_clocks)
+		max_sustainable_clocks = kzalloc(sizeof(struct smu_11_0_max_sustainable_clocks),
 					 GFP_KERNEL);
+	else
+		max_sustainable_clocks = smu->smu_table.max_sustainable_clocks;
+
 	smu->smu_table.max_sustainable_clocks = (void *)max_sustainable_clocks;
 
 	max_sustainable_clocks->uclock = smu->smu_table.boot_values.uclk / 100;
-- 
2.20.1



