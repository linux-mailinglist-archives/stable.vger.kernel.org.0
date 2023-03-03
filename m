Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF3DE6AA4EF
	for <lists+stable@lfdr.de>; Fri,  3 Mar 2023 23:59:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232557AbjCCW7P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Mar 2023 17:59:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231339AbjCCW6y (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Mar 2023 17:58:54 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE35337F3D;
        Fri,  3 Mar 2023 14:58:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EC54DB81A02;
        Fri,  3 Mar 2023 21:44:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4DE5C433A0;
        Fri,  3 Mar 2023 21:44:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677879879;
        bh=o2T0u/e0V3LqzENCHAw0Xh5SBmm+usjlUib11r6OMgE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WmnWv4si3uMaEKNrvGVyy9O3sq4MD1s1gWZpF+2epf6q8jkRQCmHmDxdgRuwjt+FU
         Z/OHmInUwxKC7tReZScoYhvsmu0XBlWcNkTTnzCNS6LvnzVWBMthWeYzI7GD8dhOmD
         UvQGWCHbMwzeKcniER+bAQhm8Ep++9pERfsd6PZ1BMoabNfnG1TYPmTox056BMvwjy
         9kK1SUJSLYZe7SQohbPWAezCjJTbmbomPDWXufpV4UUJv0bCXYkpEk9wsL1bZn8q57
         jDa+8WEhZZ0CPtzQbrx5r3ftqKD0pITJH1XSixG8/THhKmsYRgNs2uE39mS51jmtQE
         feutqnL1luTNw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Daniel Mack <daniel@zonque.org>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Robert Jarzmik <robert.jarzmik@free.fr>,
        Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 6.1 38/60] USB: gadget: pxa27x_udc: fix memory leak with using debugfs_lookup()
Date:   Fri,  3 Mar 2023 16:42:52 -0500
Message-Id: <20230303214315.1447666-38-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230303214315.1447666-1-sashal@kernel.org>
References: <20230303214315.1447666-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
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
index ac980d6a47406..0ecdfd2ba9e9b 100644
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

