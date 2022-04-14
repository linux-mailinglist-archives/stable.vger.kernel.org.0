Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D75B50106F
	for <lists+stable@lfdr.de>; Thu, 14 Apr 2022 16:45:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344935AbiDNNtv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Apr 2022 09:49:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344295AbiDNNkl (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Apr 2022 09:40:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6A1F1C6;
        Thu, 14 Apr 2022 06:38:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5229F6190F;
        Thu, 14 Apr 2022 13:38:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C137C385A1;
        Thu, 14 Apr 2022 13:38:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649943495;
        bh=6i2pIc4DfBlAvUDdBVgV5ahqFbgGM70bfdwOdV3kkJI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eVhfd/9tOD5faxh1JVw/4rk6EGeqWHgzEfdzB0qxqdB/DeMaaIkas6MxewOIGcuoL
         FdEigILnm5X7usPIDl96+mrUWIgIQz+mdSXemotYwzQ6AAta7mgYAuSEnzbhPEGRrx
         0T4YPYw3CSBbmRDLbfTOT1kElr4FFSnMVS3airb8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaoqian Lin <linmq006@gmail.com>,
        Sebastian Reichel <sebastian.reichel@collabora.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 174/475] power: supply: ab8500: Fix memory leak in ab8500_fg_sysfs_init
Date:   Thu, 14 Apr 2022 15:09:19 +0200
Message-Id: <20220414110900.005260227@linuxfoundation.org>
X-Mailer: git-send-email 2.35.2
In-Reply-To: <20220414110855.141582785@linuxfoundation.org>
References: <20220414110855.141582785@linuxfoundation.org>
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

[ Upstream commit 6a4760463dbc6b603690938c468839985189ce0a ]

kobject_init_and_add() takes reference even when it fails.
According to the doc of kobject_init_and_add()：

   If this function returns an error, kobject_put() must be called to
   properly clean up the memory associated with the object.

Fix memory leak by calling kobject_put().

Fixes: 8c0984e5a753 ("power: move power supply drivers to power/supply")
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/ab8500_fg.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/power/supply/ab8500_fg.c b/drivers/power/supply/ab8500_fg.c
index 69452fc085b9..4c229e6fb750 100644
--- a/drivers/power/supply/ab8500_fg.c
+++ b/drivers/power/supply/ab8500_fg.c
@@ -2541,8 +2541,10 @@ static int ab8500_fg_sysfs_init(struct ab8500_fg *di)
 	ret = kobject_init_and_add(&di->fg_kobject,
 		&ab8500_fg_ktype,
 		NULL, "battery");
-	if (ret < 0)
+	if (ret < 0) {
+		kobject_put(&di->fg_kobject);
 		dev_err(di->dev, "failed to create sysfs entry\n");
+	}
 
 	return ret;
 }
-- 
2.34.1



