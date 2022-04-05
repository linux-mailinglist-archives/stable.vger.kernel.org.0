Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CEF134F311A
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 14:39:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234137AbiDEI57 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 04:57:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234119AbiDEIjT (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 04:39:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 558101EAFF;
        Tue,  5 Apr 2022 01:32:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E4E9BB81A32;
        Tue,  5 Apr 2022 08:32:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C9C7C385A1;
        Tue,  5 Apr 2022 08:32:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649147572;
        bh=g4fyN2qoHyGpxXNxZZ707m4eEwBL7Q2b400w2aH4EFg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kAV2iUaYkedzOrwRNN5/fD0F6BkCMJTIPWMnMheQSmhenUoA7jz8oG3ndlHUMgBAH
         9JDd/xzYpCzzC1rHlBcdjiIRqkORLuU4NPPSf1TIXLaQtoJdKVVeLOWrFKFiXbUilI
         fz5HlzN1RYF83I6mcbX91In2XMkr6qSKvXgsFQus=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaoqian Lin <linmq006@gmail.com>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [PATCH 5.16 0045/1017] coresight: syscfg: Fix memleak on registration failure in cscfg_create_device
Date:   Tue,  5 Apr 2022 09:15:58 +0200
Message-Id: <20220405070355.520237785@linuxfoundation.org>
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

commit cfa5dbcdd7aece76f3415284569f2f384aff0253 upstream.

device_register() calls device_initialize(),
according to doc of device_initialize:

    Use put_device() to give up your reference instead of freeing
    * @dev directly once you have called this function.

To prevent potential memleak, use put_device() for error handling.

Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Fixes: 85e2414c518a ("coresight: syscfg: Initial coresight system configuration")
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20220124124121.8888-1-linmq006@gmail.com
Signed-off-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Signed-off-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hwtracing/coresight/coresight-syscfg.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/hwtracing/coresight/coresight-syscfg.c
+++ b/drivers/hwtracing/coresight/coresight-syscfg.c
@@ -791,7 +791,7 @@ static int cscfg_create_device(void)
 
 	err = device_register(dev);
 	if (err)
-		cscfg_dev_release(dev);
+		put_device(dev);
 
 create_dev_exit_unlock:
 	mutex_unlock(&cscfg_mutex);


