Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21EF06B434F
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 15:13:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231778AbjCJONE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 09:13:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231775AbjCJOMo (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 09:12:44 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D732B11A2F6
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 06:11:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B769C61959
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 14:11:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 826B8C4339B;
        Fri, 10 Mar 2023 14:11:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678457488;
        bh=qlL51E0/NZbjTW3c4TmV6aYGz5OpdvOQVh9xBbC5vGk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kChF6Z0cfjK60JA9nDjx+LSbORdFLGzIyPxMccTdBC3ReKeYaeAAnGudMHEnKjzrF
         SlVd6L1PrSxA8JRJlFgva5pSwFPFH9JK/itJycp/sUtjKD0u0Tk7m5mv/4+PvAT73q
         RA5r/xuCKQqgcVm7+2so/wki1yZt7FBvFU0nnbhU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Daniel Mack <daniel@zonque.org>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Robert Jarzmik <robert.jarzmik@free.fr>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 154/200] USB: gadget: pxa25x_udc: fix memory leak with using debugfs_lookup()
Date:   Fri, 10 Mar 2023 14:39:21 +0100
Message-Id: <20230310133721.858799707@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133717.050159289@linuxfoundation.org>
References: <20230310133717.050159289@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
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



