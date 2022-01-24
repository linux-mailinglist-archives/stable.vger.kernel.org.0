Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EEC70499289
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 21:21:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347401AbiAXUVc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 15:21:32 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:57616 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355840AbiAXUSY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:18:24 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0C7F8B810BD;
        Mon, 24 Jan 2022 20:18:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B6CFC340E5;
        Mon, 24 Jan 2022 20:18:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643055496;
        bh=LbaWiAw0bZL8X+W8SlhBM2W2+1zuaaar/nyfCzhiPg8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zEqO1unH9PAFqUt/m/Z06zDzfLOo3PqqPMBH8LEkWh1EfZHjwm44Orp8L2YS8WGUT
         lXk4QRXFatOqVLfpYjBJt2sJ4IMND7TG43LF7P3v6UyDf4RBKGK/D44UV5zHWFEgwh
         L0nXutEEsKX3Cvsf/ufp6FDjj6PrH8HP1kKgqBTA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Stanimir Varbanov <stanimir.varbanov@linaro.org>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 170/846] media: venus: core: Fix a potential NULL pointer dereference in an error handling path
Date:   Mon, 24 Jan 2022 19:34:47 +0100
Message-Id: <20220124184106.847044683@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit e4debea9be7d5db52bc6a565a4c02c3c6560d093 ]

The normal path of the function makes the assumption that
'pm_ops->core_power' may be NULL.
We should make the same assumption in the error handling path or a NULL
pointer dereference may occur.

Add the missing test before calling 'pm_ops->core_power'

Fixes: 9e8efdb57879 ("media: venus: core: vote for video-mem path")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Signed-off-by: Stanimir Varbanov <stanimir.varbanov@linaro.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/qcom/venus/core.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/qcom/venus/core.c b/drivers/media/platform/qcom/venus/core.c
index 91b15842c5558..84cd92628cfdc 100644
--- a/drivers/media/platform/qcom/venus/core.c
+++ b/drivers/media/platform/qcom/venus/core.c
@@ -472,7 +472,8 @@ static __maybe_unused int venus_runtime_suspend(struct device *dev)
 err_video_path:
 	icc_set_bw(core->cpucfg_path, kbps_to_icc(1000), 0);
 err_cpucfg_path:
-	pm_ops->core_power(core, POWER_ON);
+	if (pm_ops->core_power)
+		pm_ops->core_power(core, POWER_ON);
 
 	return ret;
 }
-- 
2.34.1



