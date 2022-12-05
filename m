Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BDD35643469
	for <lists+stable@lfdr.de>; Mon,  5 Dec 2022 20:46:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235056AbiLETq1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Dec 2022 14:46:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233431AbiLETqM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Dec 2022 14:46:12 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 092B82DAA9
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 11:42:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9A1EA612ED
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 19:42:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9DFEC433D6;
        Mon,  5 Dec 2022 19:42:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670269349;
        bh=b1CbOiWRUw/e80CJapgJt3Jhdul/Ig9uRW3+UhFwcjA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HEBr3y11OzPYKPEDreQ2Z98UcaY6mvzKxaHsng4Ee1ksmNLlQ/iYrfmrru3hA4TEs
         90R6bSObR2fihFtkMhOxmFcESljnsxkMPcZJVYrTgT9LcnK7C2uTXznhI5tpAlhD81
         R8XI5mHY/lgrC4j830Mp3Jx6qzVlK7kM0Avlv3SM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Gaosheng Cui <cuigaosheng1@huawei.com>,
        Guenter Roeck <linux@roeck-us.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 095/153] hwmon: (ibmpex) Fix possible UAF when ibmpex_register_bmc() fails
Date:   Mon,  5 Dec 2022 20:10:19 +0100
Message-Id: <20221205190811.465818039@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221205190808.733996403@linuxfoundation.org>
References: <20221205190808.733996403@linuxfoundation.org>
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
index b2ab83c9fd9a..fe90f0536d76 100644
--- a/drivers/hwmon/ibmpex.c
+++ b/drivers/hwmon/ibmpex.c
@@ -502,6 +502,7 @@ static void ibmpex_register_bmc(int iface, struct device *dev)
 	return;
 
 out_register:
+	list_del(&data->list);
 	hwmon_device_unregister(data->hwmon_dev);
 out_user:
 	ipmi_destroy_user(data->user);
-- 
2.35.1



