Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E58276948D1
	for <lists+stable@lfdr.de>; Mon, 13 Feb 2023 15:53:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230100AbjBMOxq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Feb 2023 09:53:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230366AbjBMOxm (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Feb 2023 09:53:42 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 157D6EFAE
        for <stable@vger.kernel.org>; Mon, 13 Feb 2023 06:53:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BF7BEB81257
        for <stable@vger.kernel.org>; Mon, 13 Feb 2023 14:53:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AD78C4339C;
        Mon, 13 Feb 2023 14:53:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676299997;
        bh=SXgf2nm3QiTx8rvcpjPMpEs7JRR4WOOI6pWQhkk4SE0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=19W7as+R7mUPgwsS2X+kkLVEQCDvEFOKCf+Ct2Lzz7+1oAEL6BB4l5xyJbHm78FuW
         xGkQ6N0PdrbOxi7MfPUybColVvNbCy4rjlJcd2STIomidKtVo+VrN1DK3oiPt6yjav
         TANhiq4Ik6sDwKu3S6oWGWzcTjKRkfWD7nXiIjqs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, linuxppc-dev@lists.ozlabs.org,
        "Erhard F." <erhard_f@mailbox.org>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        Michal Suchanek <msuchanek@suse.de>,
        Rob Herring <robh@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 024/114] of: Make OF framebuffer device names unique
Date:   Mon, 13 Feb 2023 15:47:39 +0100
Message-Id: <20230213144743.394615178@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230213144742.219399167@linuxfoundation.org>
References: <20230213144742.219399167@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michal Suchanek <msuchanek@suse.de>

[ Upstream commit 241d2fb56a18473af5f2ff0d512992a996eb64dd ]

Since Linux 5.19 this error is observed:

sysfs: cannot create duplicate filename '/devices/platform/of-display'

This is because multiple devices with the same name 'of-display' are
created on the same bus. Update the code to create numbered device names
for the displays.

Also, fix a node refcounting issue when exiting the boot display loop.

cc: linuxppc-dev@lists.ozlabs.org
Fixes: 52b1b46c39ae ("of: Create platform devices for OF framebuffers")
Reported-by: Erhard F. <erhard_f@mailbox.org>
Suggested-by: Thomas Zimmermann <tzimmermann@suse.de>
Signed-off-by: Michal Suchanek <msuchanek@suse.de>
Link: https://lore.kernel.org/r/20230201162247.3575506-1-robh@kernel.org
[robh: Rework to avoid node refcount leaks]
Signed-off-by: Rob Herring <robh@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/of/platform.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/of/platform.c b/drivers/of/platform.c
index 3507095a69f69..6e93fd37ccd1a 100644
--- a/drivers/of/platform.c
+++ b/drivers/of/platform.c
@@ -526,6 +526,7 @@ static int __init of_platform_default_populate_init(void)
 	if (IS_ENABLED(CONFIG_PPC)) {
 		struct device_node *boot_display = NULL;
 		struct platform_device *dev;
+		int display_number = 0;
 		int ret;
 
 		/* Check if we have a MacOS display without a node spec */
@@ -556,16 +557,23 @@ static int __init of_platform_default_populate_init(void)
 			if (!of_get_property(node, "linux,opened", NULL) ||
 			    !of_get_property(node, "linux,boot-display", NULL))
 				continue;
-			dev = of_platform_device_create(node, "of-display", NULL);
+			dev = of_platform_device_create(node, "of-display.0", NULL);
+			of_node_put(node);
 			if (WARN_ON(!dev))
 				return -ENOMEM;
 			boot_display = node;
+			display_number++;
 			break;
 		}
 		for_each_node_by_type(node, "display") {
+			char buf[14];
+			const char *of_display_format = "of-display.%d";
+
 			if (!of_get_property(node, "linux,opened", NULL) || node == boot_display)
 				continue;
-			of_platform_device_create(node, "of-display", NULL);
+			ret = snprintf(buf, sizeof(buf), of_display_format, display_number++);
+			if (ret < sizeof(buf))
+				of_platform_device_create(node, buf, NULL);
 		}
 
 	} else {
-- 
2.39.0



