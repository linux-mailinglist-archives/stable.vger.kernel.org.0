Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59F0C540721
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 19:43:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347801AbiFGRmp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 13:42:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347662AbiFGRl5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 13:41:57 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6A4312816A;
        Tue,  7 Jun 2022 10:34:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6D3C4B822B4;
        Tue,  7 Jun 2022 17:34:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0769C385A5;
        Tue,  7 Jun 2022 17:34:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654623252;
        bh=FWkQWp40lBmrHdjQ/7RZ8RaE0IoDNQ3yi2JVKYsklJ8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iLvaE6ky78SUTWsYXKd0JIZ0uKmcwRRyeUxPHzntGrlXCNMNNErzOwwrUYwZAMvIs
         BV9zauM8p1dMfvhmRXpNU4rCOmysuPi+mJhqeDWDbBFcm8bR609aP6jDHD2yjSVHZf
         RA7MK7cFxDCB8qPYVat0qHtedNEyxlqUri16Ayt8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaoqian Lin <linmq006@gmail.com>,
        Helge Deller <deller@gmx.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 333/452] video: fbdev: clcdfb: Fix refcount leak in clcdfb_of_vram_setup
Date:   Tue,  7 Jun 2022 19:03:10 +0200
Message-Id: <20220607164918.483003245@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164908.521895282@linuxfoundation.org>
References: <20220607164908.521895282@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miaoqian Lin <linmq006@gmail.com>

[ Upstream commit b23789a59fa6f00e98a319291819f91fbba0deb8 ]

of_parse_phandle() returns a node pointer with refcount incremented, we should
use of_node_put() on it when not need anymore.  Add missing of_node_put() to
avoid refcount leak.

Fixes: d10715be03bd ("video: ARM CLCD: Add DT support")
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/fbdev/amba-clcd.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/video/fbdev/amba-clcd.c b/drivers/video/fbdev/amba-clcd.c
index 33595cc4778e..79efefd224f4 100644
--- a/drivers/video/fbdev/amba-clcd.c
+++ b/drivers/video/fbdev/amba-clcd.c
@@ -771,12 +771,15 @@ static int clcdfb_of_vram_setup(struct clcd_fb *fb)
 		return -ENODEV;
 
 	fb->fb.screen_base = of_iomap(memory, 0);
-	if (!fb->fb.screen_base)
+	if (!fb->fb.screen_base) {
+		of_node_put(memory);
 		return -ENOMEM;
+	}
 
 	fb->fb.fix.smem_start = of_translate_address(memory,
 			of_get_address(memory, 0, &size, NULL));
 	fb->fb.fix.smem_len = size;
+	of_node_put(memory);
 
 	return 0;
 }
-- 
2.35.1



