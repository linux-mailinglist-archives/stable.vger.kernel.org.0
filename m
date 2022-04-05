Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 010AE4F2C04
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 13:22:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235498AbiDEKcX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 06:32:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239054AbiDEJdX (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:33:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CE2B275EF;
        Tue,  5 Apr 2022 02:21:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EB7E1B81B14;
        Tue,  5 Apr 2022 09:21:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42B99C385A3;
        Tue,  5 Apr 2022 09:21:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649150509;
        bh=g4fyN2qoHyGpxXNxZZ707m4eEwBL7Q2b400w2aH4EFg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dURWKHzZlzLC19DAJQz/F+fk19qQF3BLgOek6D1HfbmELcikUsKUXT8Df09EqPN/+
         Cs9iWIQ3XQAKjPYQVQMZ4SiOV9GF83tNwofUMSof7yDSShu49Ehjc3ouXwamiZa7tz
         OEXd8qPW/MdExSOoj3qvHF+FzM0zsNtVaJU96JAo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaoqian Lin <linmq006@gmail.com>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [PATCH 5.15 044/913] coresight: syscfg: Fix memleak on registration failure in cscfg_create_device
Date:   Tue,  5 Apr 2022 09:18:26 +0200
Message-Id: <20220405070341.139176454@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070339.801210740@linuxfoundation.org>
References: <20220405070339.801210740@linuxfoundation.org>
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


