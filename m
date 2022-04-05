Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12A9E4F2EB2
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 14:03:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355649AbiDEKVN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 06:21:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347331AbiDEJZ3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:25:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DD7DDD941;
        Tue,  5 Apr 2022 02:15:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6D38C615E5;
        Tue,  5 Apr 2022 09:14:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B262C385A0;
        Tue,  5 Apr 2022 09:14:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649150063;
        bh=yqm4qNRot0W+kBh+mRQCRatH0OJBgYorbLjzeBfhe3Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=x87SFKyKRhpGyNv8lsZ+id/nfoC00tWKDYwcB3LIz2RDtpBvYS9hxHkBnGKbZvMVn
         dQUSwj7PJutpVLrqoUip/RBAzmPwhbGWCWLPi8FYHG6aYhVfFSE9qPNE+dsWINPRCE
         01V+Jht7M4X7E4VME/grv/FIh3fGATPS+pzIDSwY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaoqian Lin <linmq006@gmail.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Wim Van Sebroeck <wim@linux-watchdog.org>
Subject: [PATCH 5.16 0941/1017] watchdog: rti-wdt: Add missing pm_runtime_disable() in probe function
Date:   Tue,  5 Apr 2022 09:30:54 +0200
Message-Id: <20220405070422.147201922@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070354.155796697@linuxfoundation.org>
References: <20220405070354.155796697@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miaoqian Lin <linmq006@gmail.com>

commit d055ef3a2c6919cff504ae3b710c96318d545fd2 upstream.

If the probe fails, we should use pm_runtime_disable() to balance
pm_runtime_enable().

Fixes: 2d63908bdbfb ("watchdog: Add K3 RTI watchdog support")
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Reviewed-by: Guenter Roeck <linux@roeck-us.net>
Link: https://lore.kernel.org/r/20220105092114.23932-1-linmq006@gmail.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Wim Van Sebroeck <wim@linux-watchdog.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/watchdog/rti_wdt.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/watchdog/rti_wdt.c
+++ b/drivers/watchdog/rti_wdt.c
@@ -228,6 +228,7 @@ static int rti_wdt_probe(struct platform
 	ret = pm_runtime_get_sync(dev);
 	if (ret) {
 		pm_runtime_put_noidle(dev);
+		pm_runtime_disable(&pdev->dev);
 		return dev_err_probe(dev, ret, "runtime pm failed\n");
 	}
 


