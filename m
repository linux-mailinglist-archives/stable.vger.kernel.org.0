Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DA46499C92
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 23:09:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1579690AbiAXWGL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 17:06:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1458043AbiAXVzG (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:55:06 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1759FC07E2A7;
        Mon, 24 Jan 2022 12:36:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AADBC61545;
        Mon, 24 Jan 2022 20:36:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7031EC340E5;
        Mon, 24 Jan 2022 20:36:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643056616;
        bh=AXo2SKIfBrFl+rOiVbbS6B5EIC7YCr/SvPrUDVh/G4E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wqF44NPHuqswW/pCMu1S4BIyuHPDre4NkbRSDRBFmqMWW2Djc9rCjS+z/xLFC1D7a
         VTCBtE/mN7C+ba74Xav7YumCIM5x/BU4YPS/578Q6vqMby+s8N77YhiHr545MryloB
         u21C3ym+Lm6qxtZdJyKGFRBzQcteEvUG3zOj/rRI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Adam Ward <Adam.Ward.opensource@diasemi.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 510/846] regulator: da9121: Prevent current limit change when enabled
Date:   Mon, 24 Jan 2022 19:40:27 +0100
Message-Id: <20220124184118.613591302@linuxfoundation.org>
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



