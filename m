Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A74E0491521
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 03:26:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244913AbiARC0R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 21:26:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244638AbiARCYS (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 21:24:18 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07E28C0617BF;
        Mon, 17 Jan 2022 18:23:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id ACC6CB81250;
        Tue, 18 Jan 2022 02:23:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB413C36AF2;
        Tue, 18 Jan 2022 02:23:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642472630;
        bh=AXo2SKIfBrFl+rOiVbbS6B5EIC7YCr/SvPrUDVh/G4E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o2wMVLFUeDteY3zngSVAwfw7/KOk/4SbouEIE5nj6XkRauG3DoARf6u+E0HdNpGQS
         oOz5LBVYjAxjcpuIm/ZIV50Wrcw7i24xB8XwksxvbN44/7NJSDutbZz3IhEVCPWCzx
         HPaB9URKZcOrseraDMkt/p+ekGHV7sEIsOIWkUbgRTVE7tEspMH2lYyQ6FxfePGhf/
         Jqm2U5CF4IwudkGw28WATdAaJ/bdtMYyReymZLqXZfdCMV0bPu7pIpXNNGLZwqq2+g
         M6/FVnLToxxdSR4QmrhXEubOTu9CMMJhbWVBmmn01lb4viM5uULrcacKWIxc0MC304
         KBqAD7nlmYWSw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Adam Ward <Adam.Ward.opensource@diasemi.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        support.opensource@diasemi.com, lgirdwood@gmail.com
Subject: [PATCH AUTOSEL 5.16 081/217] regulator: da9121: Prevent current limit change when enabled
Date:   Mon, 17 Jan 2022 21:17:24 -0500
Message-Id: <20220118021940.1942199-81-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118021940.1942199-1-sashal@kernel.org>
References: <20220118021940.1942199-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Adam Ward <Adam.Ward.opensource@diasemi.com>

[ Upstream commit 24f0853228f3b98f1ef08d5824376c69bb8124d2 ]

Prevent changing current limit when enabled as a precaution against
possibile instability due to tight integration with switching cycle

Signed-off-by: Adam Ward <Adam.Ward.opensource@diasemi.com>
Link: https://lore.kernel.org/r/52ee682476004a1736c1e0293358987319c1c415.1638223185.git.Adam.Ward.opensource@diasemi.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/da9121-regulator.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/regulator/da9121-regulator.c b/drivers/regulator/da9121-regulator.c
index e669250902580..0a4fd449c27d1 100644
--- a/drivers/regulator/da9121-regulator.c
+++ b/drivers/regulator/da9121-regulator.c
@@ -253,6 +253,11 @@ static int da9121_set_current_limit(struct regulator_dev *rdev,
 		goto error;
 	}
 
+	if (rdev->desc->ops->is_enabled(rdev)) {
+		ret = -EBUSY;
+		goto error;
+	}
+
 	ret = da9121_ceiling_selector(rdev, min_ua, max_ua, &sel);
 	if (ret < 0)
 		goto error;
-- 
2.34.1

