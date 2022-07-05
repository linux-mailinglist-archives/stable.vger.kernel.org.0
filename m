Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B34F566E23
	for <lists+stable@lfdr.de>; Tue,  5 Jul 2022 14:32:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238294AbiGEMb2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Jul 2022 08:31:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237978AbiGEM0r (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Jul 2022 08:26:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30D9418E14;
        Tue,  5 Jul 2022 05:18:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C45E861984;
        Tue,  5 Jul 2022 12:18:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2196C341C7;
        Tue,  5 Jul 2022 12:18:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657023535;
        bh=O7UsWvCnucR8zz8LyErL09aD5BVJeTIzCK2A9a2eboE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HuPQjK5WjzneNM8YOaQCBBFD6LKoHs4m+dKRw6ALb4QpF0HjcJe+jmcE+E0mX/tB6
         G9tId6xdwhk8RuulFBnupNFNygJLNQeB9Ce/8W6SItGhx1oOG5HuPEQSpCFCPZ2qf7
         P7a0VBJQE6mkJu29IdwLA05uEZVpn4uAXagUaN7A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Yang Yingliang <yangyingliang@huawei.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 096/102] hwmon: (ibmaem) dont call platform_device_del() if platform_device_add() fails
Date:   Tue,  5 Jul 2022 13:59:02 +0200
Message-Id: <20220705115621.144667668@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220705115618.410217782@linuxfoundation.org>
References: <20220705115618.410217782@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit d0e51022a025ca5350fafb8e413a6fe5d4baf833 ]

If platform_device_add() fails, it no need to call platform_device_del(), split
platform_device_unregister() into platform_device_del/put(), so platform_device_put()
can be called separately.

Fixes: 8808a793f052 ("ibmaem: new driver for power/energy/temp meters in IBM System X hardware")
Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Link: https://lore.kernel.org/r/20220701074153.4021556-1-yangyingliang@huawei.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/ibmaem.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/hwmon/ibmaem.c b/drivers/hwmon/ibmaem.c
index de6baf6ca3d1..dab4908b78a8 100644
--- a/drivers/hwmon/ibmaem.c
+++ b/drivers/hwmon/ibmaem.c
@@ -550,7 +550,7 @@ static int aem_init_aem1_inst(struct aem_ipmi_data *probe, u8 module_handle)
 
 	res = platform_device_add(data->pdev);
 	if (res)
-		goto ipmi_err;
+		goto dev_add_err;
 
 	platform_set_drvdata(data->pdev, data);
 
@@ -598,7 +598,9 @@ static int aem_init_aem1_inst(struct aem_ipmi_data *probe, u8 module_handle)
 	ipmi_destroy_user(data->ipmi.user);
 ipmi_err:
 	platform_set_drvdata(data->pdev, NULL);
-	platform_device_unregister(data->pdev);
+	platform_device_del(data->pdev);
+dev_add_err:
+	platform_device_put(data->pdev);
 dev_err:
 	ida_simple_remove(&aem_ida, data->id);
 id_err:
@@ -690,7 +692,7 @@ static int aem_init_aem2_inst(struct aem_ipmi_data *probe,
 
 	res = platform_device_add(data->pdev);
 	if (res)
-		goto ipmi_err;
+		goto dev_add_err;
 
 	platform_set_drvdata(data->pdev, data);
 
@@ -738,7 +740,9 @@ static int aem_init_aem2_inst(struct aem_ipmi_data *probe,
 	ipmi_destroy_user(data->ipmi.user);
 ipmi_err:
 	platform_set_drvdata(data->pdev, NULL);
-	platform_device_unregister(data->pdev);
+	platform_device_del(data->pdev);
+dev_add_err:
+	platform_device_put(data->pdev);
 dev_err:
 	ida_simple_remove(&aem_ida, data->id);
 id_err:
-- 
2.35.1



