Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 968124F3BF5
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 17:23:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1382211AbiDEMDm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 08:03:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357970AbiDEK1g (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 06:27:36 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85520CBE7E;
        Tue,  5 Apr 2022 03:11:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 425DBB81B7A;
        Tue,  5 Apr 2022 10:11:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACA1BC385A0;
        Tue,  5 Apr 2022 10:11:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649153515;
        bh=nfhQSG9JWnqT+nUVC4av6L1bI1OYlS6HDqhxDGKd+f0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zCNMcuPXTo+WdoZRio9tsKIGf+i4PtKNB3ca0W5caw2g3f9pYIbZFb0iU7zMUvW15
         rew77Qz9EfRlPekzVPV/AtZO1zn0Mm4dmX/N+skfN7g0z7UX5cc/4/BT8ThaJv6/Jl
         Ij7hpzMM+70dPmbUJweJZvTSoYRzy16hPdZOG0zs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaoqian Lin <linmq006@gmail.com>,
        Helge Deller <deller@gmx.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 242/599] video: fbdev: omapfb: Add missing of_node_put() in dvic_probe_of
Date:   Tue,  5 Apr 2022 09:28:56 +0200
Message-Id: <20220405070306.042477767@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070258.802373272@linuxfoundation.org>
References: <20220405070258.802373272@linuxfoundation.org>
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
index b4a1aefff766..777f6d66c28c 100644
--- a/drivers/video/fbdev/omap2/omapfb/displays/connector-dvi.c
+++ b/drivers/video/fbdev/omap2/omapfb/displays/connector-dvi.c
@@ -251,6 +251,7 @@ static int dvic_probe_of(struct platform_device *pdev)
 	adapter_node = of_parse_phandle(node, "ddc-i2c-bus", 0);
 	if (adapter_node) {
 		adapter = of_get_i2c_adapter_by_node(adapter_node);
+		of_node_put(adapter_node);
 		if (adapter == NULL) {
 			dev_err(&pdev->dev, "failed to parse ddc-i2c-bus\n");
 			omap_dss_put_device(ddata->in);
-- 
2.34.1



