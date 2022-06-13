Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8EA62548C0E
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:11:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352279AbiFMLRT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 07:17:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352781AbiFMLOV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 07:14:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC0B536B7F;
        Mon, 13 Jun 2022 03:36:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5542E60F9A;
        Mon, 13 Jun 2022 10:36:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62670C34114;
        Mon, 13 Jun 2022 10:36:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655116615;
        bh=d8eam/u8TJsIPVLctjeBRpQRVqTMZyKu5ccKRJ1qFQc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gEl/5tILDfLNE6tpHl9Q9gMH4vnsuutP28yIt3E1f2BrMWhYJ7mzarC1tmcopMF3d
         f2X6PoLv0QQo5tf3/7faXO/XOVtje5UROyJIjxkJ+FmkdoxuMfzaRIx6SIhIlL9rel
         luu/jAUg293D7cfXWn2+4frO9gYjB+HZ6QUp8LAk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zev Weiss <zev@bewilderbeest.net>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 123/411] regulator: core: Fix enable_count imbalance with EXCLUSIVE_GET
Date:   Mon, 13 Jun 2022 12:06:36 +0200
Message-Id: <20220613094932.362497137@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094928.482772422@linuxfoundation.org>
References: <20220613094928.482772422@linuxfoundation.org>
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
index 7fd793d8536c..ae2addadb36f 100644
--- a/drivers/regulator/core.c
+++ b/drivers/regulator/core.c
@@ -1988,10 +1988,13 @@ struct regulator *_regulator_get(struct device *dev, const char *id,
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
 
 	device_link_add(dev, &rdev->dev, DL_FLAG_STATELESS);
-- 
2.35.1



