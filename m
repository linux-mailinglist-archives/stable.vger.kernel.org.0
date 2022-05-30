Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13DD0537C4B
	for <lists+stable@lfdr.de>; Mon, 30 May 2022 15:32:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237083AbiE3NbZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 May 2022 09:31:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237115AbiE3NaG (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 May 2022 09:30:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70EFDBC86;
        Mon, 30 May 2022 06:26:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3CE6060E2D;
        Mon, 30 May 2022 13:26:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1F57C3411C;
        Mon, 30 May 2022 13:26:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653917190;
        bh=cnzevXgz+waa72ojOU4KwgyU+p6nulyrqLCnlw984fs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ng+ResfkkVGLko3kl/PtGZZJnpfidk2LUwDcTry9/UDJjg+XMMB4fdgqSTVk677Tu
         cvaDeinZWgmQTY1ZAzy2j+umP59ifcaILkM6LcD/UbKkOxgKPCRIu0BbivgIQ+H+k5
         /GG+Vxh/+e1ezq0z3VckZMu7XToOW/2cGXsig2glvc6d1m0wURMfI0R0ZqrY8TeG3B
         gVx3hP9yo/sT9+X2mWLE/OIs7KHHzPUDVaz0RtkxezM65DjE/QWXemZcYw9dz4ITWy
         kFEVVcgTCBzauSZetGpHid/t4H1zQByM6Q/U2DvNzJMa9q1LZtOuSYnt/NvQCJ+Ato
         2fo8PO2L523qQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Zheyu Ma <zheyuma97@gmail.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 5.18 049/159] media: i2c: dw9714: Disable the regulator when the driver fails to probe
Date:   Mon, 30 May 2022 09:22:34 -0400
Message-Id: <20220530132425.1929512-49-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220530132425.1929512-1-sashal@kernel.org>
References: <20220530132425.1929512-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zheyu Ma <zheyuma97@gmail.com>

[ Upstream commit 02276e18defa2fccf16413b44440277d98c2b1ea ]

When the driver fails to probe, we will get the following splat:

[   59.305988] ------------[ cut here ]------------
[   59.306417] WARNING: CPU: 2 PID: 395 at drivers/regulator/core.c:2257 _regulator_put+0x3ec/0x4e0
[   59.310345] RIP: 0010:_regulator_put+0x3ec/0x4e0
[   59.318362] Call Trace:
[   59.318582]  <TASK>
[   59.318765]  regulator_put+0x1f/0x30
[   59.319058]  devres_release_group+0x319/0x3d0
[   59.319420]  i2c_device_probe+0x766/0x940

Fix this by disabling the regulator in error handling.

Signed-off-by: Zheyu Ma <zheyuma97@gmail.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/dw9714.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/i2c/dw9714.c b/drivers/media/i2c/dw9714.c
index cd7008ad8f2f..8c5797ba57d4 100644
--- a/drivers/media/i2c/dw9714.c
+++ b/drivers/media/i2c/dw9714.c
@@ -183,6 +183,7 @@ static int dw9714_probe(struct i2c_client *client)
 	return 0;
 
 err_cleanup:
+	regulator_disable(dw9714_dev->vcc);
 	v4l2_ctrl_handler_free(&dw9714_dev->ctrls_vcm);
 	media_entity_cleanup(&dw9714_dev->sd.entity);
 
-- 
2.35.1

