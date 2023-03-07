Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 280786AEBE6
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 18:50:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232084AbjCGRuH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 12:50:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232095AbjCGRtf (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 12:49:35 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72B5FA224D
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:44:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0F2DD614E8
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:44:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 253E2C433EF;
        Tue,  7 Mar 2023 17:44:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678211070;
        bh=dMfLHGXqCV58j67NNjONufX/DRzADM+jNNP7F/CLS34=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sUlPLKK6w3hRlqqYe/Pq1y8jQMD6+PmvhXY3IMM1v3xPof/nsyR/QKTAYVDh32o/e
         UejzFXzy7RI/GNPuOCO2Y7sFJLpEflWFqTG1W/jcs015FXwVqccHD3KnUl784ZF9bh
         B9xuLNHGV+mrCKIRFzY+MnOyYWpp2weRYOUCO6D8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Vladimir Oltean <vladimir.oltean@nxp.com>,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Saravana Kannan <saravanak@google.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0743/1001] driver core: fw_devlink: Avoid spurious error message
Date:   Tue,  7 Mar 2023 17:58:35 +0100
Message-Id: <20230307170053.976963097@linuxfoundation.org>
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
index 126b10c8e0ce9..6ed21587be287 100644
--- a/drivers/base/core.c
+++ b/drivers/base/core.c
@@ -2088,9 +2088,9 @@ static int fw_devlink_create_devlink(struct device *con,
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



