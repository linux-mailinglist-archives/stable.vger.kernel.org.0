Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB8B26B486C
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 16:02:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233852AbjCJPCW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 10:02:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233684AbjCJPCC (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 10:02:02 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6C6B125DBB
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 06:55:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 32C81B822E4
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 14:55:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 647F5C433D2;
        Fri, 10 Mar 2023 14:55:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678460102;
        bh=2YANKMYbByIzXzo2ZLoJjDiFPk2iWqDx2CA27JI5vUQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Nx0IXcSR0qPrQRqrHlRlXRT2PWW3bj7LyN/dBCSb0142wWF4uapSsx/3FAmPeS8rL
         7DXaKvVa5lVdHfyGo+kUV0h/+p6utLYwgc8UhhzcIZjt7aC53oixu1jocR+S75kHGu
         XnxCeOLrgUC3Uky51Wu8mRO9UcnRwLlGZvdz6ejs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Miaoqian Lin <linmq006@gmail.com>,
        Lee Jones <lee@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 224/529] leds: led-core: Fix refcount leak in of_led_get()
Date:   Fri, 10 Mar 2023 14:36:07 +0100
Message-Id: <20230310133815.385500279@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133804.978589368@linuxfoundation.org>
References: <20230310133804.978589368@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miaoqian Lin <linmq006@gmail.com>

[ Upstream commit da1afe8e6099980fe1e2fd7436dca284af9d3f29 ]

class_find_device_by_of_node() calls class_find_device(), it will take
the reference, use the put_device() to drop the reference when not need
anymore.

Fixes: 699a8c7c4bd3 ("leds: Add of_led_get() and led_put()")
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Signed-off-by: Lee Jones <lee@kernel.org>
Link: https://lore.kernel.org/r/20221220121807.1543790-1-linmq006@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/leds/led-class.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/leds/led-class.c b/drivers/leds/led-class.c
index e28a4bb716032..fcb9eee3b6097 100644
--- a/drivers/leds/led-class.c
+++ b/drivers/leds/led-class.c
@@ -236,6 +236,7 @@ struct led_classdev *of_led_get(struct device_node *np, int index)
 
 	led_dev = class_find_device_by_of_node(leds_class, led_node);
 	of_node_put(led_node);
+	put_device(led_dev);
 
 	if (!led_dev)
 		return ERR_PTR(-EPROBE_DEFER);
-- 
2.39.2



