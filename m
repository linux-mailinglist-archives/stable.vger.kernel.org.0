Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 75C7D328C18
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 19:46:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240298AbhCASpi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 13:45:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:51238 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234540AbhCASjw (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 13:39:52 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8D2A0651CF;
        Mon,  1 Mar 2021 17:17:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614619042;
        bh=lqRKLBvKAYvx4AkNz/AZ9rXkrR0NLQWErrsSkOTtLQM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IKmyjaL869kbfe2gFoDFdI5g5lIjbK4HvtWOPmb5/Psd8c9sHsCnZwEN6Dc6saV7G
         ktjRVUJoNLounCepsx7Jogg+UqfgaJIDEoT63qc8O+/T0aQBGXCXygM7hKo9yiQTkS
         7vYeN9++U3MQGXJcJ/QLLtOd4E2nZ8t8DJ7dRNGo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Krzysztof Kozlowski <krzk@kernel.org>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 311/663] regulator: s5m8767: Drop regulators OF node reference
Date:   Mon,  1 Mar 2021 17:09:19 +0100
Message-Id: <20210301161157.226137926@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161141.760350206@linuxfoundation.org>
References: <20210301161141.760350206@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Krzysztof Kozlowski <krzk@kernel.org>

[ Upstream commit a5872bd3398d0ff2ce4c77794bc7837899c69024 ]

The device node reference obtained with of_get_child_by_name() should be
dropped on error paths.

Fixes: 26aec009f6b6 ("regulator: add device tree support for s5m8767")
Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
Link: https://lore.kernel.org/r/20210121155914.48034-1-krzk@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/s5m8767.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/regulator/s5m8767.c b/drivers/regulator/s5m8767.c
index 48dd95b3ff45a..7c111bbdc2afa 100644
--- a/drivers/regulator/s5m8767.c
+++ b/drivers/regulator/s5m8767.c
@@ -544,14 +544,18 @@ static int s5m8767_pmic_dt_parse_pdata(struct platform_device *pdev,
 	rdata = devm_kcalloc(&pdev->dev,
 			     pdata->num_regulators, sizeof(*rdata),
 			     GFP_KERNEL);
-	if (!rdata)
+	if (!rdata) {
+		of_node_put(regulators_np);
 		return -ENOMEM;
+	}
 
 	rmode = devm_kcalloc(&pdev->dev,
 			     pdata->num_regulators, sizeof(*rmode),
 			     GFP_KERNEL);
-	if (!rmode)
+	if (!rmode) {
+		of_node_put(regulators_np);
 		return -ENOMEM;
+	}
 
 	pdata->regulators = rdata;
 	pdata->opmode = rmode;
-- 
2.27.0



