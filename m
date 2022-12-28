Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C35E2658121
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:25:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234603AbiL1QZP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:25:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234793AbiL1QYX (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:24:23 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F8C519C17
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:21:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3988CB816F4
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:21:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3CBCC433F0;
        Wed, 28 Dec 2022 16:21:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672244492;
        bh=g4+UuLA7qg+bFjUCo5VqR0mTf7mvZQemDJgX5e7ZKXc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cthT88XXgoN+Qb2FZaoRAEk7MYx87zg/n85YRtG6YxHEEIbXh/KMH7LJrzoKnctuJ
         C1YF4j1pRoeAWo5uNDneI5/6p7lLLe+TFN4L0vKOPvqcIjCNXjJNYu95OnpSCD+2hW
         A5tAKDWI1qkOg/W5fUwcUhpARY5SK71cpBqM2C08=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Yang Yingliang <yangyingliang@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0721/1073] usb: typec: wusb3801: fix fwnode refcount leak in wusb3801_probe()
Date:   Wed, 28 Dec 2022 15:38:29 +0100
Message-Id: <20221228144347.609836393@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
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
index e63509f8b01e..8e38f5d2ec89 100644
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



