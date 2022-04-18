Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F384A50555F
	for <lists+stable@lfdr.de>; Mon, 18 Apr 2022 15:24:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241643AbiDRNVY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 09:21:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242085AbiDRNSL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 09:18:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 255343B3DC;
        Mon, 18 Apr 2022 05:51:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7A31A6124A;
        Mon, 18 Apr 2022 12:51:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85154C385A7;
        Mon, 18 Apr 2022 12:51:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650286296;
        bh=3X5yPZmDQzoAnMRoFbTlEmaaQNUNd2P8pdHICpsssZU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FOuG6r9HHbInerH4sFi5PMkPrwPuFqAZhFWys4FIYN4pSguWITgXOU42Ab0aL17IX
         qH9hyOS68vTe/q6dCc+n3eoEtz3TNgQbiRNhqE2CxjBK1d5wbi/5zsleDMDlGE5i7m
         JAAiXVrabvfazch4WthxwoSqoH7pY38ppnv6XK0c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaoqian Lin <linmq006@gmail.com>,
        Helge Deller <deller@gmx.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 091/284] video: fbdev: omapfb: Add missing of_node_put() in dvic_probe_of
Date:   Mon, 18 Apr 2022 14:11:12 +0200
Message-Id: <20220418121213.274113951@linuxfoundation.org>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220418121210.689577360@linuxfoundation.org>
References: <20220418121210.689577360@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
index 06e1db34541e..41b0db0cc047 100644
--- a/drivers/video/fbdev/omap2/omapfb/displays/connector-dvi.c
+++ b/drivers/video/fbdev/omap2/omapfb/displays/connector-dvi.c
@@ -254,6 +254,7 @@ static int dvic_probe_of(struct platform_device *pdev)
 	adapter_node = of_parse_phandle(node, "ddc-i2c-bus", 0);
 	if (adapter_node) {
 		adapter = of_get_i2c_adapter_by_node(adapter_node);
+		of_node_put(adapter_node);
 		if (adapter == NULL) {
 			dev_err(&pdev->dev, "failed to parse ddc-i2c-bus\n");
 			omap_dss_put_device(ddata->in);
-- 
2.34.1



