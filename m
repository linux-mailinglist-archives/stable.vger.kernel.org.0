Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6C316AEB03
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 18:39:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231982AbjCGRjN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 12:39:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231947AbjCGRiu (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 12:38:50 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 062179BA48
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:35:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8B76B614D0
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:35:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80409C433D2;
        Tue,  7 Mar 2023 17:35:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678210508;
        bh=gVK+vHDxhgfc05MESC6t6rqKAnLRDv5wRzzOFiCR5OI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XJ75aPFQgc5lCLYd9K65tRzky8UNJqZv+Lte4OeHC9pNUzIV6rDv/lY3lgGE4u2He
         C25bU6ykhGwgq0Rluu/LwaSaTDyJjHRMElfjfDI8gH1OcRBIZBKawO59SW3hPpKEEk
         Zxm2R0S5hjnyNOo57EG5LhlGb/GhiYbepA6w2/M4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Maxim Kiselev <bigunclemax@gmail.com>,
        Saravana Kannan <saravanak@google.com>,
        Douglas Anderson <dianders@chromium.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Sasha Levin <sashal@kernel.org>,
        Luca Weiss <luca.weiss@fairphone.com>
Subject: [PATCH 6.2 0556/1001] mtd: mtdpart: Dont create platform device thatll never probe
Date:   Tue,  7 Mar 2023 17:55:28 +0100
Message-Id: <20230307170045.610912755@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Saravana Kannan <saravanak@google.com>

[ Upstream commit fb42378dcc7f247df56f0ecddfdae85487495fbc ]

These "nvmem-cells" platform devices never get probed because there's no
platform driver for it and it's never used anywhere else. So it's a
waste of memory. These devices also cause fw_devlink to block nvmem
consumers of "nvmem-cells" partition from probing because the supplier
device never probes.

So stop creating platform devices for nvmem-cells partitions to avoid
wasting memory and to avoid blocking probing of consumers.

Reported-by: Maxim Kiselev <bigunclemax@gmail.com>
Fixes: bcdf0315a61a ("mtd: call of_platform_populate() for MTD partitions")
Signed-off-by: Saravana Kannan <saravanak@google.com>
Tested-by: Maksim Kiselev <bigunclemax@gmail.com>
Tested-by: Douglas Anderson <dianders@chromium.org>
Tested-by: Geert Uytterhoeven <geert+renesas@glider.be>
Tested-by: Luca Weiss <luca.weiss@fairphone.com> # qcom/sm7225-fairphone-fp4
Link: https://lore.kernel.org/r/20230207014207.1678715-13-saravanak@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/mtdpart.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/mtd/mtdpart.c b/drivers/mtd/mtdpart.c
index d442fa94c8720..85f5ee6f06fc6 100644
--- a/drivers/mtd/mtdpart.c
+++ b/drivers/mtd/mtdpart.c
@@ -577,6 +577,7 @@ static int mtd_part_of_parse(struct mtd_info *master,
 {
 	struct mtd_part_parser *parser;
 	struct device_node *np;
+	struct device_node *child;
 	struct property *prop;
 	struct device *dev;
 	const char *compat;
@@ -594,6 +595,15 @@ static int mtd_part_of_parse(struct mtd_info *master,
 	else
 		np = of_get_child_by_name(np, "partitions");
 
+	/*
+	 * Don't create devices that are added to a bus but will never get
+	 * probed. That'll cause fw_devlink to block probing of consumers of
+	 * this partition until the partition device is probed.
+	 */
+	for_each_child_of_node(np, child)
+		if (of_device_is_compatible(child, "nvmem-cells"))
+			of_node_set_flag(child, OF_POPULATED);
+
 	of_property_for_each_string(np, "compatible", prop, compat) {
 		parser = mtd_part_get_compatible_parser(compat);
 		if (!parser)
-- 
2.39.2



