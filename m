Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 613675417F1
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 23:07:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378641AbiFGVHH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 17:07:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379863AbiFGVGb (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 17:06:31 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33F2621228F;
        Tue,  7 Jun 2022 11:50:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B3485B8239B;
        Tue,  7 Jun 2022 18:50:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 205AAC385A2;
        Tue,  7 Jun 2022 18:50:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654627813;
        bh=cnzevXgz+waa72ojOU4KwgyU+p6nulyrqLCnlw984fs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HgJDhKOwT8mjef0djt+BaLNz76ovYO6By4Lovbwl6aDEXalx0BQqt/hfY1laBQvYf
         UEcXRYBCctPyYEQIqD0lzgpjS02gjJibGV8ZitoanBjyWkQejgd8mPJiAyC1V3jDVm
         WykEInfDWT6GkXm3sMdtSuCzQq4TP2XmSLJNqgw8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zheyu Ma <zheyuma97@gmail.com>,
        Sakari Ailus <sakari.ailus@linux.intel.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 101/879] media: i2c: dw9714: Disable the regulator when the driver fails to probe
Date:   Tue,  7 Jun 2022 18:53:39 +0200
Message-Id: <20220607165005.628589270@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607165002.659942637@linuxfoundation.org>
References: <20220607165002.659942637@linuxfoundation.org>
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



