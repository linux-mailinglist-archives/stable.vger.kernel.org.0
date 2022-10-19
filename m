Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7DD4C60451B
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 14:21:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233118AbiJSMVK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 08:21:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231925AbiJSMTy (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 08:19:54 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFCEE18C427;
        Wed, 19 Oct 2022 04:55:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CD978B8246E;
        Wed, 19 Oct 2022 09:02:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B9A1C433D6;
        Wed, 19 Oct 2022 09:02:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666170177;
        bh=DmgTEDOjY1ekANe0B6+eltI6M8iO58ZnFGi/+ktAkkk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HToKCqE5MoniIQ1KWcQZtHC2Hni4vj2TIzaYuTUUhboellTy+FCHTmZjpTXfMWxAE
         AC9qS33+ZE04zfYGqZGD1FsqctEzkG2G6sHGka7Dpe5+qQKSHrJ4qJ/YwPmMN5sGiM
         YS6WUWFCV1yYd6pkrtol18VLNHidYDwH7A0cCzKk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Liang He <windhl@126.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 555/862] usb: typec: anx7411: Use of_get_child_by_name() instead of of_find_node_by_name()
Date:   Wed, 19 Oct 2022 10:30:42 +0200
Message-Id: <20221019083314.503826672@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Liang He <windhl@126.com>

[ Upstream commit e45d7337dc0e4f7f1c2876e1b22c71a544ad12fd ]

In anx7411_typec_switch_probe(), we should call of_get_child_by_name()
instead of of_find_node_by_name() as of_find_xxx API will decrease the
refcount of the 'from' argument.

Fixes: fe6d8a9c8e64 ("usb: typec: anx7411: Add Analogix PD ANX7411 support")
Acked-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Signed-off-by: Liang He <windhl@126.com>
Link: https://lore.kernel.org/r/20220915092209.4009273-1-windhl@126.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/typec/anx7411.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/typec/anx7411.c b/drivers/usb/typec/anx7411.c
index c0f0842d443c..f178d0eb47b1 100644
--- a/drivers/usb/typec/anx7411.c
+++ b/drivers/usb/typec/anx7411.c
@@ -1105,7 +1105,7 @@ static int anx7411_typec_switch_probe(struct anx7411_data *ctx,
 	int ret;
 	struct device_node *node;
 
-	node = of_find_node_by_name(dev->of_node, "orientation_switch");
+	node = of_get_child_by_name(dev->of_node, "orientation_switch");
 	if (!node)
 		return 0;
 
@@ -1115,7 +1115,7 @@ static int anx7411_typec_switch_probe(struct anx7411_data *ctx,
 		return ret;
 	}
 
-	node = of_find_node_by_name(dev->of_node, "mode_switch");
+	node = of_get_child_by_name(dev->of_node, "mode_switch");
 	if (!node) {
 		dev_err(dev, "no typec mux exist");
 		ret = -ENODEV;
-- 
2.35.1



