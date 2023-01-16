Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9C6866CAF0
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 18:09:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234187AbjAPRJQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 12:09:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234319AbjAPRIu (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 12:08:50 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10DC42E0E7
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:48:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C4318B81071
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:48:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 290D1C433EF;
        Mon, 16 Jan 2023 16:48:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673887736;
        bh=5p9BKXAPPxjt7yjuJmohSVC6uSy3ssFZcJxZO9Q+h04=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kve2wnwEOspi4GDoml3e2gde16saNA7kq64Q5St3jaXUB5HLRkHjaaVVH0E5SUrJb
         6g6w5bk3ZjHC6W+dZgI58xPcVjhkT/JmtkEcqtVt5CmLLppR02DctSoPKL5zwbZeku
         BXuHju0f6uSKjHwa51OoIsPY7HUegPH6YEWpOrIY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, ruanjinjie <ruanjinjie@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 233/521] misc: tifm: fix possible memory leak in tifm_7xx1_switch_media()
Date:   Mon, 16 Jan 2023 16:48:15 +0100
Message-Id: <20230116154857.554993782@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154847.246743274@linuxfoundation.org>
References: <20230116154847.246743274@linuxfoundation.org>
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

From: ruanjinjie <ruanjinjie@huawei.com>

[ Upstream commit fd2c930cf6a5b9176382c15f9acb1996e76e25ad ]

If device_register() returns error in tifm_7xx1_switch_media(),
name of kobject which is allocated in dev_set_name() called in device_add()
is leaked.

Never directly free @dev after calling device_register(), even
if it returned an error! Always use put_device() to give up the
reference initialized.

Fixes: 2428a8fe2261 ("tifm: move common device management tasks from tifm_7xx1 to tifm_core")
Signed-off-by: ruanjinjie <ruanjinjie@huawei.com>
Link: https://lore.kernel.org/r/20221117064725.3478402-1-ruanjinjie@huawei.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/tifm_7xx1.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/misc/tifm_7xx1.c b/drivers/misc/tifm_7xx1.c
index 9ac95b48ef92..1d33c4facd44 100644
--- a/drivers/misc/tifm_7xx1.c
+++ b/drivers/misc/tifm_7xx1.c
@@ -194,7 +194,7 @@ static void tifm_7xx1_switch_media(struct work_struct *work)
 				spin_unlock_irqrestore(&fm->lock, flags);
 			}
 			if (sock)
-				tifm_free_device(&sock->dev);
+				put_device(&sock->dev);
 		}
 		spin_lock_irqsave(&fm->lock, flags);
 	}
-- 
2.35.1



