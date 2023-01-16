Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F1BB66C7B9
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 17:34:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233324AbjAPQeC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 11:34:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233337AbjAPQdT (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 11:33:19 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D92B23C7D
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 08:21:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 28F72B8107A
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 16:21:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83C27C433EF;
        Mon, 16 Jan 2023 16:21:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673886077;
        bh=bvRAEPOWJN7Hrun5jqeCf1cGk9AMSrnRXK1eL3GB554=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=v/z4qnMAt7y1V0o00XguxcctIW+ewWSoV9YRssLONMgQxQpBem4ki3wAPHgIuYxVV
         +x6O5IwXk7MsrfR+X9W6jAUxXd//Y7lUFNrJEmoYjP33eo3yV6WCKx+xqQQ7R/fCxm
         WIDWZ5/k5x4BGqX7kvCt1AaQIg/HggkXkC7gt9VM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, ruanjinjie <ruanjinjie@huawei.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 294/658] misc: tifm: fix possible memory leak in tifm_7xx1_switch_media()
Date:   Mon, 16 Jan 2023 16:46:22 +0100
Message-Id: <20230116154923.047481662@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154909.645460653@linuxfoundation.org>
References: <20230116154909.645460653@linuxfoundation.org>
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
index e6b40aa8fb42..8f0ffb46bf15 100644
--- a/drivers/misc/tifm_7xx1.c
+++ b/drivers/misc/tifm_7xx1.c
@@ -190,7 +190,7 @@ static void tifm_7xx1_switch_media(struct work_struct *work)
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



