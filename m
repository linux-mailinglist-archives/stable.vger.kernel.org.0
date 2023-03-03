Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A1586AA58A
	for <lists+stable@lfdr.de>; Sat,  4 Mar 2023 00:23:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229551AbjCCXX2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Mar 2023 18:23:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229487AbjCCXX1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Mar 2023 18:23:27 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FBE78A62;
        Fri,  3 Mar 2023 15:23:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 2955ACE2296;
        Fri,  3 Mar 2023 21:44:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84F54C4339B;
        Fri,  3 Mar 2023 21:44:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677879878;
        bh=qlL51E0/NZbjTW3c4TmV6aYGz5OpdvOQVh9xBbC5vGk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ISW1071Rn74aUF87uX7J+2xonSQ0Kcm/0MgtLCEigvWvnU83VfAwDQ6KpGbJcDSdc
         G+PRno36i/Z7cfbDXpz4MDkKNXQ95fiujiTDi9djS8UGvNhgp7lQV7s9yvLG5nq8NS
         +3eY9HvASvIa0fe6w9XbSoFcu8JQ4kY0YccjXpVV7Az63dKlaFZabSyG24KPCnG+8S
         UGlqt3SU6FYMsSFGwtWFctMx066a1BFHDIVjzXb80FKhoJmms1CpTXVbzTzNblK8xJ
         sIAAXfdsD25X0tXIjJPi1Cq45EMnfrhh7C31VuZfDDhq2vGC38OG0ALxKz/OQ5uj8l
         AkwtLSAlBQQZg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Daniel Mack <daniel@zonque.org>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Robert Jarzmik <robert.jarzmik@free.fr>,
        Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 6.1 37/60] USB: gadget: pxa25x_udc: fix memory leak with using debugfs_lookup()
Date:   Fri,  3 Mar 2023 16:42:51 -0500
Message-Id: <20230303214315.1447666-37-sashal@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230303214315.1447666-1-sashal@kernel.org>
References: <20230303214315.1447666-1-sashal@kernel.org>
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

[ Upstream commit 7a038a681b7df78362d9fc7013e5395a694a9d3a ]

When calling debugfs_lookup() the result must have dput() called on it,
otherwise the memory will leak over time.  To make things simpler, just
call debugfs_lookup_and_remove() instead which handles all of the logic
at once.

Cc: Daniel Mack <daniel@zonque.org>
Cc: Haojian Zhuang <haojian.zhuang@gmail.com>
Cc: Robert Jarzmik <robert.jarzmik@free.fr>
Link: https://lore.kernel.org/r/20230202153235.2412790-11-gregkh@linuxfoundation.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/gadget/udc/pxa25x_udc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/gadget/udc/pxa25x_udc.c b/drivers/usb/gadget/udc/pxa25x_udc.c
index c593fc383481e..9e01ddf2b4170 100644
--- a/drivers/usb/gadget/udc/pxa25x_udc.c
+++ b/drivers/usb/gadget/udc/pxa25x_udc.c
@@ -1340,7 +1340,7 @@ DEFINE_SHOW_ATTRIBUTE(udc_debug);
 		debugfs_create_file(dev->gadget.name, \
 			S_IRUGO, NULL, dev, &udc_debug_fops); \
 	} while (0)
-#define remove_debug_files(dev) debugfs_remove(debugfs_lookup(dev->gadget.name, NULL))
+#define remove_debug_files(dev) debugfs_lookup_and_remove(dev->gadget.name, NULL)
 
 #else	/* !CONFIG_USB_GADGET_DEBUG_FILES */
 
-- 
2.39.2

