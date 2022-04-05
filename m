Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B17A4F3BEF
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 17:23:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382193AbiDEMDc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 08:03:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358061AbiDEK15 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 06:27:57 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8F543526C;
        Tue,  5 Apr 2022 03:14:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 904A5B81C6C;
        Tue,  5 Apr 2022 10:14:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB6F9C385A1;
        Tue,  5 Apr 2022 10:14:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649153643;
        bh=sUs4HZTtGvzpA2DEMLbLc1C6w10Sx6kDMJePfSUfA/M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=e29K7mOs3qijd282PyfY61Om0K2Nmpg0NTuFlulaxhJyjG4f98wa0VL+L9UJs66GS
         75gFTVf8X5DQYfcIpyZ4XDYpkVr+9IEcqcMoNCTDQxuA1lvehluXHMct45WJL82fGf
         rfyev+cr9NdqG3d7/pSy3+1X0g6d79/hJqkPn+Og=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaoqian Lin <linmq006@gmail.com>,
        Sebastian Reichel <sebastian.reichel@collabora.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 296/599] power: supply: ab8500: Fix memory leak in ab8500_fg_sysfs_init
Date:   Tue,  5 Apr 2022 09:29:50 +0200
Message-Id: <20220405070307.642316016@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070258.802373272@linuxfoundation.org>
References: <20220405070258.802373272@linuxfoundation.org>
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
index f1da757c939f..a6b4a94c2766 100644
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



