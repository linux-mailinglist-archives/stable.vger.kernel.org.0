Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B9F486AA310
	for <lists+stable@lfdr.de>; Fri,  3 Mar 2023 22:54:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232934AbjCCVyN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Mar 2023 16:54:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232941AbjCCVxm (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Mar 2023 16:53:42 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5795A64244;
        Fri,  3 Mar 2023 13:48:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 29BDF61923;
        Fri,  3 Mar 2023 21:46:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24FEAC4339C;
        Fri,  3 Mar 2023 21:46:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677880005;
        bh=FCr71OfqrNuYpQWh1uNDAto1H/RXTFO0WbB5oEKU0aE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dsAafEmjKAkdrbL8kI3bqAHtZzbxtvRz18E9m1m/zyqOwOyh0sha6VOg4AVOZWCxC
         ihfLW5gASriQN13uY76NnmXYHS/hLIfpL4KfLrIO5X5dUQYJKQPM/04mwA+IEnRqeS
         qKbG/6fvz8xWLWlLGqg6Zv69fMgwGVtfJpmlF2mBS9zDc/8+v3UD4eWqOHlDWsBpMD
         45ywZsImpR2mDSO9Lk0RHgq1cqlEQka6CPC5ltKzJWCVedZ3ZWZa6gq0E3sf9Zl5gk
         PEsAWzAt/heYKub4T8WVtTmJTk6FOhg0IFgmmbnMZJSQIREe7hbGBL8cQy+PFf/lTN
         A7URz0IucLAlQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Daniel Mack <daniel@zonque.org>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Robert Jarzmik <robert.jarzmik@free.fr>,
        Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 32/50] USB: gadget: pxa27x_udc: fix memory leak with using debugfs_lookup()
Date:   Fri,  3 Mar 2023 16:45:13 -0500
Message-Id: <20230303214531.1450154-32-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230303214531.1450154-1-sashal@kernel.org>
References: <20230303214531.1450154-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

[ Upstream commit 7a6952fa0366d4408eb8695af1a0578c39ec718a ]

When calling debugfs_lookup() the result must have dput() called on it,
otherwise the memory will leak over time.  To make things simpler, just
call debugfs_lookup_and_remove() instead which handles all of the logic
at once.

Cc: Daniel Mack <daniel@zonque.org>
Cc: Haojian Zhuang <haojian.zhuang@gmail.com>
Cc: Robert Jarzmik <robert.jarzmik@free.fr>
Link: https://lore.kernel.org/r/20230202153235.2412790-12-gregkh@linuxfoundation.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/gadget/udc/pxa27x_udc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/gadget/udc/pxa27x_udc.c b/drivers/usb/gadget/udc/pxa27x_udc.c
index f4b7a2a3e7114..282b114f382f8 100644
--- a/drivers/usb/gadget/udc/pxa27x_udc.c
+++ b/drivers/usb/gadget/udc/pxa27x_udc.c
@@ -215,7 +215,7 @@ static void pxa_init_debugfs(struct pxa_udc *udc)
 
 static void pxa_cleanup_debugfs(struct pxa_udc *udc)
 {
-	debugfs_remove(debugfs_lookup(udc->gadget.name, usb_debug_root));
+	debugfs_lookup_and_remove(udc->gadget.name, usb_debug_root);
 }
 
 #else
-- 
2.39.2

