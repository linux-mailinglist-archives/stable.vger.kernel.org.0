Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7BD306AA1F3
	for <lists+stable@lfdr.de>; Fri,  3 Mar 2023 22:45:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232235AbjCCVoc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Mar 2023 16:44:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232135AbjCCVoM (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Mar 2023 16:44:12 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 523B58A68;
        Fri,  3 Mar 2023 13:43:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 32A17B819FA;
        Fri,  3 Mar 2023 21:42:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BBEFC4339B;
        Fri,  3 Mar 2023 21:42:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677879756;
        bh=o2T0u/e0V3LqzENCHAw0Xh5SBmm+usjlUib11r6OMgE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lU+rZzCX4yReQQO4wN83MDka4ak14tlA98osr9RI/1+DZv7JNCT7xspdTUXsl+SFJ
         C9t2aGD4U+NQ/8dWyt0MJ3aSBVXKvnmpGHVRwj7HC6eHqa5IavpK7LtI0QqejwLT87
         cCVGw1viNQrbP/VVZF3vV3jtOMjFW7bstWDzSpT7hJdYU1NJjWQE0ZC+Okkp6Io3YF
         0g0wjRgBNHl2sPZPnN5uHDHmqPBlSKqS+SEzhGWXfq5BeOkvYkqTzTXA4Tx5YfwZ/L
         Yc3xvggmxPPgTY8M51GcEuloXMaJdNGesebuTBhLZkFjsQD+JYrdVQt2TQfzDkPYt2
         Lc+KriwOZ57XQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Daniel Mack <daniel@zonque.org>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Robert Jarzmik <robert.jarzmik@free.fr>,
        Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 6.2 42/64] USB: gadget: pxa27x_udc: fix memory leak with using debugfs_lookup()
Date:   Fri,  3 Mar 2023 16:40:44 -0500
Message-Id: <20230303214106.1446460-42-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230303214106.1446460-1-sashal@kernel.org>
References: <20230303214106.1446460-1-sashal@kernel.org>
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

