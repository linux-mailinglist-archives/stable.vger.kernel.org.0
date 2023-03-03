Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4F696AA453
	for <lists+stable@lfdr.de>; Fri,  3 Mar 2023 23:30:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231510AbjCCWaO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Mar 2023 17:30:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232025AbjCCW3d (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Mar 2023 17:29:33 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C0F16A9E4;
        Fri,  3 Mar 2023 14:23:44 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E08E0618CB;
        Fri,  3 Mar 2023 21:46:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBA6DC433A0;
        Fri,  3 Mar 2023 21:46:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677880003;
        bh=Jagds/6lQ7/HQgX4stxgiiZoEl48T9QG1XVSQgt4wCk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YgRdf4yq8paKtVYwalLAtWRCMcnlFH/7ksZK3ET5ab6WOJk7aevgnmz2iMqrM6hca
         prj+X0Xg53q9yx2WtFCb2mvx1cW0f8MGkKxoenEKa9bbF/JSJ3N679tvR3tqgVRyBj
         bXDXh2OazA9lwCAA9Y3DMleXOebF90wryllemrklSjJyDB9Ifh6SxheTYNgHCJ/x+p
         nF1H7iXziCAf0pcDMBq32LrCftd7yrbBARlZ+DXebi9nYlY9SeHOXXwywkhuVvhhEa
         YBZJoObCvTXz4gMg0Y8y/lPxGWt/wrDTRGzwkPeIwjikpd9siDIfiHLK7NwCQ68e/C
         yUsbbC6qvjyQw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Daniel Mack <daniel@zonque.org>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Robert Jarzmik <robert.jarzmik@free.fr>,
        Sasha Levin <sashal@kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 31/50] USB: gadget: pxa25x_udc: fix memory leak with using debugfs_lookup()
Date:   Fri,  3 Mar 2023 16:45:12 -0500
Message-Id: <20230303214531.1450154-31-sashal@kernel.org>
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
index a09ec1d826b21..e4d2ab5768ba2 100644
--- a/drivers/usb/gadget/udc/pxa25x_udc.c
+++ b/drivers/usb/gadget/udc/pxa25x_udc.c
@@ -1341,7 +1341,7 @@ DEFINE_SHOW_ATTRIBUTE(udc_debug);
 		debugfs_create_file(dev->gadget.name, \
 			S_IRUGO, NULL, dev, &udc_debug_fops); \
 	} while (0)
-#define remove_debug_files(dev) debugfs_remove(debugfs_lookup(dev->gadget.name, NULL))
+#define remove_debug_files(dev) debugfs_lookup_and_remove(dev->gadget.name, NULL)
 
 #else	/* !CONFIG_USB_GADGET_DEBUG_FILES */
 
-- 
2.39.2

