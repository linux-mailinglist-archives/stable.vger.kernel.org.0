Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6AE714FD461
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 12:03:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243276AbiDLICP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 04:02:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357294AbiDLHj4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 03:39:56 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70619183B5;
        Tue, 12 Apr 2022 00:14:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EB11CB81B46;
        Tue, 12 Apr 2022 07:14:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C3DDC385A1;
        Tue, 12 Apr 2022 07:14:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649747677;
        bh=BJU3SoYaAQU5PGAAdKA5dXjOco3AbVhPcyDIW5TSjrA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jJ87HZP3qf6vCWKaLP/vFWZJjR8603lPkmhyGbSpMBYyAefuvntGziNPYcnI9wz5n
         0mJJUYfpztjXUiwHR1/gAYMKChEjuDrJVomReYEWNOvvvFhNiUL16Uw8xNRtykNsR9
         IxFa5Xr8LInXm/g2jwjfqwvzl+zJz/Dc/HHySE40=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Xiaoke Wang <xkernel.wang@foxmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 167/343] staging: wfx: fix an error handling in wfx_init_common()
Date:   Tue, 12 Apr 2022 08:29:45 +0200
Message-Id: <20220412062956.191258378@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412062951.095765152@linuxfoundation.org>
References: <20220412062951.095765152@linuxfoundation.org>
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

From: Xiaoke Wang <xkernel.wang@foxmail.com>

[ Upstream commit 60f1d3c92dc1ef1026e5b917a329a7fa947da036 ]

One error handler of wfx_init_common() return without calling
ieee80211_free_hw(hw), which may result in memory leak. And I add
one err label to unify the error handler, which is useful for the
subsequent changes.

Suggested-by: Jérôme Pouiller <jerome.pouiller@silabs.com>
Reviewed-by: Dan Carpenter <dan.carpenter@oracle.com>
Reviewed-by: Jérôme Pouiller <jerome.pouiller@silabs.com>
Signed-off-by: Xiaoke Wang <xkernel.wang@foxmail.com>
Link: https://lore.kernel.org/r/tencent_24A24A3EFF61206ECCC4B94B1C5C1454E108@qq.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/wfx/main.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/staging/wfx/main.c b/drivers/staging/wfx/main.c
index 858d778cc589..e3999e95ce85 100644
--- a/drivers/staging/wfx/main.c
+++ b/drivers/staging/wfx/main.c
@@ -322,7 +322,8 @@ struct wfx_dev *wfx_init_common(struct device *dev,
 	wdev->pdata.gpio_wakeup = devm_gpiod_get_optional(dev, "wakeup",
 							  GPIOD_OUT_LOW);
 	if (IS_ERR(wdev->pdata.gpio_wakeup))
-		return NULL;
+		goto err;
+
 	if (wdev->pdata.gpio_wakeup)
 		gpiod_set_consumer_name(wdev->pdata.gpio_wakeup, "wfx wakeup");
 
@@ -341,6 +342,10 @@ struct wfx_dev *wfx_init_common(struct device *dev,
 		return NULL;
 
 	return wdev;
+
+err:
+	ieee80211_free_hw(hw);
+	return NULL;
 }
 
 int wfx_probe(struct wfx_dev *wdev)
-- 
2.35.1



