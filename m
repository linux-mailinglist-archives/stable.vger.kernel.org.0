Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 463B34F24DF
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 09:40:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231849AbiDEHl5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 03:41:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231852AbiDEHlw (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 03:41:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4985F4B859;
        Tue,  5 Apr 2022 00:39:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7B2E06164B;
        Tue,  5 Apr 2022 07:39:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 871B9C340EE;
        Tue,  5 Apr 2022 07:39:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649144386;
        bh=TiyLQ3K6thQvViES3Dvp4/W4jR7z6kpaRENWn8GKzJc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BkgXK/ymQn9M+cnP8ErigFvoS772JP/RJn6/hPLMmgdyM1WWu8F2+gi7I+tuvrV+J
         8pXQ+LUFqTn0+xFMfA3u+yasQmLRwWKSAU7Cb/S6xvtoCXwQAMjHvxdNC1XlfQzFhC
         pFlsfSKb3/6Jn3peWe4q/QlGz/nPEaEGIlq+w7Jk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaoqian Lin <linmq006@gmail.com>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Suzuki K Poulose <suzuki.poulose@arm.com>
Subject: [PATCH 5.17 0027/1126] coresight: syscfg: Fix memleak on registration failure in cscfg_create_device
Date:   Tue,  5 Apr 2022 09:12:54 +0200
Message-Id: <20220405070408.348567576@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070407.513532867@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
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
@@ -1049,7 +1049,7 @@ static int cscfg_create_device(void)
 
 	err = device_register(dev);
 	if (err)
-		cscfg_dev_release(dev);
+		put_device(dev);
 
 create_dev_exit_unlock:
 	mutex_unlock(&cscfg_mutex);


