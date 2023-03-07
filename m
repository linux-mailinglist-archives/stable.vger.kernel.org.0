Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E99DE6AF129
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 19:40:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231942AbjCGSkP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 13:40:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232750AbjCGSjz (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 13:39:55 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE6129927C
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:31:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8B22F6152E
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:31:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A763C4339B;
        Tue,  7 Mar 2023 18:31:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678213869;
        bh=leG7MCIIAbev1lTwxRZF+eGlahOCONjHWig2PgpAwz8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZRwSYKiKhmLwtJ02AX9k8j5HmQB/vn1JjMC0RYiUyrWmJjAHqN33mQiPL/iUco/D1
         RjR1m6Nt0EcTKWlOCrxMJiutx77VUWngyJKyeBoKmff30yaiLWm4CwJX3ZAtTa6kTK
         u6tJ7AtNJcuKA4Rf0YsZ00v20RYgh3lvGSygoHt4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Vladimir Oltean <vladimir.oltean@nxp.com>,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Saravana Kannan <saravanak@google.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 646/885] driver core: fw_devlink: Avoid spurious error message
Date:   Tue,  7 Mar 2023 17:59:40 +0100
Message-Id: <20230307170030.220083865@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
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

From: Saravana Kannan <saravanak@google.com>

[ Upstream commit 6309872413f14f3d58c13ae4dc85b1a7004b4193 ]

fw_devlink can sometimes try to create a device link with the consumer
and supplier as the same device. These attempts will fail (correctly),
but are harmless. So, avoid printing an error for these cases. Also, add
more detail to the error message.

Fixes: 3fb16866b51d ("driver core: fw_devlink: Make cycle detection more robust")
Reported-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reported-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Saravana Kannan <saravanak@google.com>
Link: https://lore.kernel.org/r/20230225064148.274376-1-saravanak@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/core.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/base/core.c b/drivers/base/core.c
index ac08d475e2828..e30223c2672fc 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -2087,9 +2087,9 @@ static int fw_devlink_create_devlink(struct device *con,
 			goto out;
 		}
 
-		if (!device_link_add(con, sup_dev, flags)) {
-			dev_err(con, "Failed to create device link with %s\n",
-				dev_name(sup_dev));
+		if (con != sup_dev && !device_link_add(con, sup_dev, flags)) {
+			dev_err(con, "Failed to create device link (0x%x) with %s\n",
+				flags, dev_name(sup_dev));
 			ret = -EINVAL;
 		}
 
-- 
2.39.2



