Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D2086431E3
	for <lists+stable@lfdr.de>; Mon,  5 Dec 2022 20:21:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233300AbiLETVs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Dec 2022 14:21:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233550AbiLETVY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Dec 2022 14:21:24 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEFC12A71E
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 11:17:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CB4E961342
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 19:16:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB8B0C433D6;
        Mon,  5 Dec 2022 19:16:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670267813;
        bh=SXl83Tl+ZfQb49rJvCWP/bddbC7DFcfN+Sdd1MRNw4U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CQ5W8hf2LwV6Fsr5527qtEB4QtN7aJ1J1hm1ImNAf5/zS4616EYdVABqBIcDPLFG8
         0L3fQWt/Vn1SbXMy/mA2MYAeu5CmOIM19piWcq/BMRa3+CHfV+hSWr+7zi4o2hIeh2
         m1gJcWqdo6FkDnZFxtFc+A0rICkJBCQIk6FqxwT0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Gaosheng Cui <cuigaosheng1@huawei.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 43/77] hwmon: (ibmpex) Fix possible UAF when ibmpex_register_bmc() fails
Date:   Mon,  5 Dec 2022 20:09:34 +0100
Message-Id: <20221205190802.405383441@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221205190800.868551051@linuxfoundation.org>
References: <20221205190800.868551051@linuxfoundation.org>
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

From: Gaosheng Cui <cuigaosheng1@huawei.com>

[ Upstream commit e2a87785aab0dac190ac89be6a9ba955e2c634f2 ]

Smatch report warning as follows:

drivers/hwmon/ibmpex.c:509 ibmpex_register_bmc() warn:
  '&data->list' not removed from list

If ibmpex_find_sensors() fails in ibmpex_register_bmc(), data will
be freed, but data->list will not be removed from driver_data.bmc_data,
then list traversal may cause UAF.

Fix by removeing it from driver_data.bmc_data before free().

Fixes: 57c7c3a0fdea ("hwmon: IBM power meter driver")
Signed-off-by: Gaosheng Cui <cuigaosheng1@huawei.com>
Link: https://lore.kernel.org/r/20221117034423.2935739-1-cuigaosheng1@huawei.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/ibmpex.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/hwmon/ibmpex.c b/drivers/hwmon/ibmpex.c
index 21b9c72f16bd..26a898781371 100644
--- a/drivers/hwmon/ibmpex.c
+++ b/drivers/hwmon/ibmpex.c
@@ -517,6 +517,7 @@ static void ibmpex_register_bmc(int iface, struct device *dev)
 	return;
 
 out_register:
+	list_del(&data->list);
 	hwmon_device_unregister(data->hwmon_dev);
 out_user:
 	ipmi_destroy_user(data->user);
-- 
2.35.1



