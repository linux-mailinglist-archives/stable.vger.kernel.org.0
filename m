Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5931A6ECE8D
	for <lists+stable@lfdr.de>; Mon, 24 Apr 2023 15:33:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232311AbjDXNdd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Apr 2023 09:33:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232496AbjDXNdT (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Apr 2023 09:33:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BA087AA4
        for <stable@vger.kernel.org>; Mon, 24 Apr 2023 06:32:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DC2DE6236F
        for <stable@vger.kernel.org>; Mon, 24 Apr 2023 13:32:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED6BCC433EF;
        Mon, 24 Apr 2023 13:32:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1682343172;
        bh=PPwxJBYzorSjWbwgdGjfpnxbSvSYCmt3OflGBLHn93g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ODu4LAUpKARmkyrldcdWqZnzxZcT6t82Dk3VZStvb+ilNuH8YjF/LRo/P4zpoUqzP
         J+3lOrAySHaFxalZmxguRuuJRdv2X+LpKoTyGBfdEpMz4RYs6W4WKOP6kpR9aE7to9
         FbDa5GUS+98ZtdC0Wh2nWhALmOCGPRU7H53bfDgs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        =?UTF-8?q?Alexis=20Lothor=C3=A9?= <alexis.lothore@bootlin.com>,
        Xu Yilun <yilun.xu@intel.com>
Subject: [PATCH 6.2 105/110] fpga: bridge: properly initialize bridge device before populating children
Date:   Mon, 24 Apr 2023 15:18:07 +0200
Message-Id: <20230424131140.524234903@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230424131136.142490414@linuxfoundation.org>
References: <20230424131136.142490414@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexis Lothoré <alexis.lothore@bootlin.com>

commit dc70eb868b9cd2ca01313e5a394e6ea001d513e9 upstream.

The current code path can lead to warnings because of uninitialized device,
which contains, as a consequence, uninitialized kobject. The uninitialized
device is passed to of_platform_populate, which will at some point, while
creating child device, try to get a reference on uninitialized parent,
resulting in the following warning:

kobject: '(null)' ((ptrval)): is not initialized, yet kobject_get() is
being called.

The warning is observed after migrating a kernel 5.10.x to 6.1.x.
Reverting commit 0d70af3c2530 ("fpga: bridge: Use standard dev_release for
class driver") seems to remove the warning.
This commit aggregates device_initialize() and device_add() into
device_register() but this new call is done AFTER of_platform_populate

Fixes: 0d70af3c2530 ("fpga: bridge: Use standard dev_release for class driver")
Signed-off-by: Alexis Lothoré <alexis.lothore@bootlin.com>
Acked-by: Xu Yilun <yilun.xu@intel.com>
Link: https://lore.kernel.org/r/20230404133102.2837535-2-alexis.lothore@bootlin.com
Signed-off-by: Xu Yilun <yilun.xu@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/fpga/fpga-bridge.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/fpga/fpga-bridge.c
+++ b/drivers/fpga/fpga-bridge.c
@@ -360,7 +360,6 @@ fpga_bridge_register(struct device *pare
 	bridge->dev.parent = parent;
 	bridge->dev.of_node = parent->of_node;
 	bridge->dev.id = id;
-	of_platform_populate(bridge->dev.of_node, NULL, NULL, &bridge->dev);
 
 	ret = dev_set_name(&bridge->dev, "br%d", id);
 	if (ret)
@@ -372,6 +371,8 @@ fpga_bridge_register(struct device *pare
 		return ERR_PTR(ret);
 	}
 
+	of_platform_populate(bridge->dev.of_node, NULL, NULL, &bridge->dev);
+
 	return bridge;
 
 error_device:


