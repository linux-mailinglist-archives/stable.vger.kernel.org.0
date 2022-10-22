Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61935608AF0
	for <lists+stable@lfdr.de>; Sat, 22 Oct 2022 11:16:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230202AbiJVJQS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Oct 2022 05:16:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230280AbiJVJP2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Oct 2022 05:15:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 008D5836D3;
        Sat, 22 Oct 2022 01:30:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 801DB60B82;
        Sat, 22 Oct 2022 07:56:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86660C433D6;
        Sat, 22 Oct 2022 07:56:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666425368;
        bh=vefNYbMf8Zt5bHYazbZqb/GZMUBayjSqs/8fWewmGmE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mnIU7JR+HvttRpP+GvLGMuXJtjJbZiexV0TiQ4hyphL2WvgXZQYZOzZyZEgQU30PK
         sh4BQ1r9EpLfhuETkosvpgryU9lzXx76bbu0eeDNU8xhY53gwvll6utICPGohzeUvp
         x3eBmvQg4RK5kYytuNpkS20FU9zkvhuvIOZypjbE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Tianping Fang <tianping.fang@mediatek.com>,
        Chunfeng Yun <chunfeng.yun@mediatek.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 478/717] usb: mtu3: fix failed runtime suspend in host only mode
Date:   Sat, 22 Oct 2022 09:25:57 +0200
Message-Id: <20221022072519.497103600@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221022072415.034382448@linuxfoundation.org>
References: <20221022072415.034382448@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chunfeng Yun <chunfeng.yun@mediatek.com>

[ Upstream commit 1c703e29da5efac6180e4c189029fa34b7e48e97 ]

When the dr_mode is "host", after the host enter runtime suspend,
the mtu3 can't do it, because the mtu3's device wakeup function is
not enabled, instead it's enabled in gadget init function, to fix
the issue, init wakeup early in mtu3's probe()

Fixes: 6b587394c65c ("usb: mtu3: support suspend/resume for dual-role mode")
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Reported-by: Tianping Fang <tianping.fang@mediatek.com>
Signed-off-by: Chunfeng Yun <chunfeng.yun@mediatek.com>
Link: https://lore.kernel.org/r/20220929064459.32522-1-chunfeng.yun@mediatek.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/mtu3/mtu3_core.c | 2 --
 drivers/usb/mtu3/mtu3_plat.c | 2 ++
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/mtu3/mtu3_core.c b/drivers/usb/mtu3/mtu3_core.c
index c4a2c37abf62..3ea5145a842b 100644
--- a/drivers/usb/mtu3/mtu3_core.c
+++ b/drivers/usb/mtu3/mtu3_core.c
@@ -971,8 +971,6 @@ int ssusb_gadget_init(struct ssusb_mtk *ssusb)
 		goto irq_err;
 	}
 
-	device_init_wakeup(dev, true);
-
 	/* power down device IP for power saving by default */
 	mtu3_stop(mtu);
 
diff --git a/drivers/usb/mtu3/mtu3_plat.c b/drivers/usb/mtu3/mtu3_plat.c
index 4309ed939178..845b25320fd2 100644
--- a/drivers/usb/mtu3/mtu3_plat.c
+++ b/drivers/usb/mtu3/mtu3_plat.c
@@ -332,6 +332,8 @@ static int mtu3_probe(struct platform_device *pdev)
 	pm_runtime_enable(dev);
 	pm_runtime_get_sync(dev);
 
+	device_init_wakeup(dev, true);
+
 	ret = ssusb_rscs_init(ssusb);
 	if (ret)
 		goto comm_init_err;
-- 
2.35.1



