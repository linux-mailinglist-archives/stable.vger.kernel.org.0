Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 924636AE9D9
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 18:28:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231628AbjCGR2V (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 12:28:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231644AbjCGR1y (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 12:27:54 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED72834F61
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:23:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 85B2DB819AB
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:23:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2CC8C433EF;
        Tue,  7 Mar 2023 17:23:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678209787;
        bh=wHJfAO5LsXajI8osGTdcr2aeOgtdaGADNY7wZzWn0Uc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=F0M7FVAKzJiSCvRk5ZNyOipTYI9MfGrkhNBN0+J3TYRR1za5bBT/cnojtSS82s9hV
         HT4UA2TEMC1ogVDoVOoFmZ5XC3RChJGEvw2j+tyo0FsI79NRu/6/ur6s3399UndYfs
         5o7IGL9FXEduyVG30+5iAl9s6urokf+NJrAjqATU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Yuan Can <yuancan@huawei.com>,
        Andrzej Hajda <andrzej.hajda@intel.com>,
        Ian Ray <ian.ray@ge.com>, Robert Foss <robert.foss@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0332/1001] drm/bridge: megachips: Fix error handling in i2c_register_driver()
Date:   Tue,  7 Mar 2023 17:51:44 +0100
Message-Id: <20230307170035.904426605@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yuan Can <yuancan@huawei.com>

[ Upstream commit 4ecff954c370b82bce45bdca2846c5c5563e8a8a ]

A problem about insmod megachips-stdpxxxx-ge-b850v3-fw.ko failed is
triggered with the following log given:

[ 4497.981497] Error: Driver 'stdp4028-ge-b850v3-fw' is already registered, aborting...
insmod: ERROR: could not insert module megachips-stdpxxxx-ge-b850v3-fw.ko: Device or resource busy

The reason is that stdpxxxx_ge_b850v3_init() returns i2c_add_driver()
directly without checking its return value, if i2c_add_driver() failed,
it returns without calling i2c_del_driver() on the previous i2c driver,
resulting the megachips-stdpxxxx-ge-b850v3-fw can never be installed
later.
A simple call graph is shown as below:

 stdpxxxx_ge_b850v3_init()
   i2c_add_driver(&stdp4028_ge_b850v3_fw_driver)
   i2c_add_driver(&stdp2690_ge_b850v3_fw_driver)
     i2c_register_driver()
       driver_register()
         bus_add_driver()
           priv = kzalloc(...) # OOM happened
   # return without delete stdp4028_ge_b850v3_fw_driver

Fix by calling i2c_del_driver() on stdp4028_ge_b850v3_fw_driver when
i2c_add_driver() returns error.

Fixes: fcfa0ddc18ed ("drm/bridge: Drivers for megachips-stdpxxxx-ge-b850v3-fw (LVDS-DP++)")
Signed-off-by: Yuan Can <yuancan@huawei.com>
Reviewed-by: Andrzej Hajda <andrzej.hajda@intel.com>
Tested-by: Ian Ray <ian.ray@ge.com>
Signed-off-by: Robert Foss <robert.foss@linaro.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20221108091226.114524-1-yuancan@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/bridge/megachips-stdpxxxx-ge-b850v3-fw.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/bridge/megachips-stdpxxxx-ge-b850v3-fw.c b/drivers/gpu/drm/bridge/megachips-stdpxxxx-ge-b850v3-fw.c
index 97359f807bfc3..cbfa05a6767b5 100644
--- a/drivers/gpu/drm/bridge/megachips-stdpxxxx-ge-b850v3-fw.c
+++ b/drivers/gpu/drm/bridge/megachips-stdpxxxx-ge-b850v3-fw.c
@@ -440,7 +440,11 @@ static int __init stdpxxxx_ge_b850v3_init(void)
 	if (ret)
 		return ret;
 
-	return i2c_add_driver(&stdp2690_ge_b850v3_fw_driver);
+	ret = i2c_add_driver(&stdp2690_ge_b850v3_fw_driver);
+	if (ret)
+		i2c_del_driver(&stdp4028_ge_b850v3_fw_driver);
+
+	return ret;
 }
 module_init(stdpxxxx_ge_b850v3_init);
 
-- 
2.39.2



