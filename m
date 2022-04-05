Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43BB34F36BF
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 16:08:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242768AbiDELHe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 07:07:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348661AbiDEJsN (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:48:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F51A3466D;
        Tue,  5 Apr 2022 02:34:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4BE29616D6;
        Tue,  5 Apr 2022 09:34:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52BF6C385A3;
        Tue,  5 Apr 2022 09:34:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649151262;
        bh=KK+VudrWUz/uioNtrgiRdIcswanyWA9dVTY+SNt1vgc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JPx2uQHDT8UzEeC9P/Nku50zDMdh8IEC9G77VJyv1GzhOvikPPAz+gGez0rR7Op81
         Iq0i/0YhI/1q7yQ9vEgZLvqqhIeg39Poye3W46gI+WDPCFBaDJALQJPYuPn8VW3tXD
         QSjfDJTdRS1ZLIGJsbPzJ00/s2+E6u0qXX/5RHUE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaoqian Lin <linmq006@gmail.com>,
        Helge Deller <deller@gmx.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 352/913] video: fbdev: omapfb: Add missing of_node_put() in dvic_probe_of
Date:   Tue,  5 Apr 2022 09:23:34 +0200
Message-Id: <20220405070350.397110988@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070339.801210740@linuxfoundation.org>
References: <20220405070339.801210740@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miaoqian Lin <linmq006@gmail.com>

[ Upstream commit a58c22cfbbf62fefca090334bbd35fd132e92a23 ]

The device_node pointer is returned by of_parse_phandle()  with refcount
incremented. We should use of_node_put() on it when done.

Fixes: f76ee892a99e ("omapfb: copy omapdss & displays for omapfb")
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/fbdev/omap2/omapfb/displays/connector-dvi.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/video/fbdev/omap2/omapfb/displays/connector-dvi.c b/drivers/video/fbdev/omap2/omapfb/displays/connector-dvi.c
index 2fa436475b40..c8ad3ef42bd3 100644
--- a/drivers/video/fbdev/omap2/omapfb/displays/connector-dvi.c
+++ b/drivers/video/fbdev/omap2/omapfb/displays/connector-dvi.c
@@ -246,6 +246,7 @@ static int dvic_probe_of(struct platform_device *pdev)
 	adapter_node = of_parse_phandle(node, "ddc-i2c-bus", 0);
 	if (adapter_node) {
 		adapter = of_get_i2c_adapter_by_node(adapter_node);
+		of_node_put(adapter_node);
 		if (adapter == NULL) {
 			dev_err(&pdev->dev, "failed to parse ddc-i2c-bus\n");
 			omap_dss_put_device(ddata->in);
-- 
2.34.1



