Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6925B540662
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 19:35:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245006AbiFGRet (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 13:34:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347464AbiFGRap (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 13:30:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 913231116FD;
        Tue,  7 Jun 2022 10:26:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2D478613F8;
        Tue,  7 Jun 2022 17:26:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BABDC385A5;
        Tue,  7 Jun 2022 17:26:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654622810;
        bh=Ne7KVx6tMWNa+nAq3BGWlIAOefOfu5GOIIKzDMxoiXE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=K97OtODj6fJlS/p0eaNS3+e2LGycDLVhKV60DbulbA2Qb4ej32FEUxyanBSpHzhkT
         2VJzGA6GLhApVwrNSLJhdlqc6K7cxK2XzX/8lTiToW/kP/SFT7paslkbf6jEybsYrA
         D3ngVSN8tIWZVIUqr5HWYniKrdnlwoG1sLBGu6fo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zev Weiss <zev@bewilderbeest.net>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 190/452] regulator: core: Fix enable_count imbalance with EXCLUSIVE_GET
Date:   Tue,  7 Jun 2022 19:00:47 +0200
Message-Id: <20220607164914.224384055@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164908.521895282@linuxfoundation.org>
References: <20220607164908.521895282@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zev Weiss <zev@bewilderbeest.net>

[ Upstream commit c3e3ca05dae37f8f74bb80358efd540911cbc2c8 ]

Since the introduction of regulator->enable_count, a driver that did
an exclusive get on an already-enabled regulator would end up with
enable_count initialized to 0 but rdev->use_count initialized to 1.
With that starting point the regulator is effectively stuck enabled,
because if the driver attempted to disable it it would fail the
enable_count underflow check in _regulator_handle_consumer_disable().

The EXCLUSIVE_GET path in _regulator_get() now initializes
enable_count along with rdev->use_count so that the regulator can be
disabled without underflowing the former.

Signed-off-by: Zev Weiss <zev@bewilderbeest.net>
Fixes: 5451781dadf85 ("regulator: core: Only count load for enabled consumers")
Link: https://lore.kernel.org/r/20220505043152.12933-1-zev@bewilderbeest.net
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/core.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
index 2c48e55c4104..6e3f3511e7dd 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -2027,10 +2027,13 @@ struct regulator *_regulator_get(struct device *dev, const char *id,
 		rdev->exclusive = 1;
 
 		ret = _regulator_is_enabled(rdev);
-		if (ret > 0)
+		if (ret > 0) {
 			rdev->use_count = 1;
-		else
+			regulator->enable_count = 1;
+		} else {
 			rdev->use_count = 0;
+			regulator->enable_count = 0;
+		}
 	}
 
 	link = device_link_add(dev, &rdev->dev, DL_FLAG_STATELESS);
-- 
2.35.1



