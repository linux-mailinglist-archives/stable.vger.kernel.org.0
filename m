Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3BF06581C1
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:31:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234763AbiL1Qbp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:31:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234765AbiL1QbX (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:31:23 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D5841D332
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:27:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CEC2B61577
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:27:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9EB1C433EF;
        Wed, 28 Dec 2022 16:27:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672244838;
        bh=eL3m/8xfE+bFpjCI8raGs3AKk6Wbbyt5gZi/AQeWkrI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CbFluIn5HgNnT8FiMXtTvJCq/7xP7lSYuycYqOdHgfYOrZ8j0G9hB4e8szc4MQ8Sx
         +yUPHK/jnPKEeS6g0j99BkSyWw23swSUlm7KtCCWeW0WowtTLzf2AEUByiHkzYZCRs
         kUhS6yXU75G8DuokeJkmQQYfqtRP9QiiU5sRkVNE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Yang Yingliang <yangyingliang@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0745/1146] usb: typec: wusb3801: fix fwnode refcount leak in wusb3801_probe()
Date:   Wed, 28 Dec 2022 15:38:04 +0100
Message-Id: <20221228144350.383017033@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit dc18a4c7b3bd447cef2395deeb1f6ac16dfaca0e ]

I got the following report while doing fault injection test:

  OF: ERROR: memory leak, expected refcount 1 instead of 4,
  of_node_get()/of_node_put() unbalanced - destroy cset entry:
  attach overlay node /i2c/tcpc@60/connector

If wusb3801_hw_init() fails, fwnode_handle_put() needs be called to
avoid refcount leak.

Fixes: d016cbe4d7ac ("usb: typec: Support the WUSB3801 port controller")
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Link: https://lore.kernel.org/r/20221203071027.3808308-1-yangyingliang@huawei.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/typec/wusb3801.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/typec/wusb3801.c b/drivers/usb/typec/wusb3801.c
index 3cc7a15ecbd3..a43a18d4b02e 100644
--- a/drivers/usb/typec/wusb3801.c
+++ b/drivers/usb/typec/wusb3801.c
@@ -364,7 +364,7 @@ static int wusb3801_probe(struct i2c_client *client)
 	/* Initialize the hardware with the devicetree settings. */
 	ret = wusb3801_hw_init(wusb3801);
 	if (ret)
-		return ret;
+		goto err_put_connector;
 
 	wusb3801->cap.revision		= USB_TYPEC_REV_1_2;
 	wusb3801->cap.accessory[0]	= TYPEC_ACCESSORY_AUDIO;
-- 
2.35.1



