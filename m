Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D02760463D
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 15:03:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231458AbiJSNDU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 09:03:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231490AbiJSNDC (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 09:03:02 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4601BFFFB0;
        Wed, 19 Oct 2022 05:46:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id CF224CE2166;
        Wed, 19 Oct 2022 09:04:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C199EC433D6;
        Wed, 19 Oct 2022 09:04:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666170267;
        bh=Abd8TtgViZsYRoO+q7ZGMnJJBXxq5ckWM858dKQWM9s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kLG3n6M92XoH8R4lHRlqKp+1WUO9S/aH25AkN6hTIuzlsyqeYpHd/vKJxwIw+6uZy
         /pFB6m4KVf92eie4VwfzeLvGxmjnYi4n7md1xlFKmyMDmAnozXcxWS+L4+64WE3bda
         26sGHv6dl/G3AHthpB7mW57WQ9zFGJC3aMMUuvSs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Tianping Fang <tianping.fang@mediatek.com>,
        Chunfeng Yun <chunfeng.yun@mediatek.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 589/862] usb: mtu3: fix failed runtime suspend in host only mode
Date:   Wed, 19 Oct 2022 10:31:16 +0200
Message-Id: <20221019083315.995498897@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
index 0ca173af87bb..a3a6282893d0 100644
--- a/drivers/usb/mtu3/mtu3_core.c
+++ b/drivers/usb/mtu3/mtu3_core.c
@@ -978,8 +978,6 @@ int ssusb_gadget_init(struct ssusb_mtk *ssusb)
 		goto irq_err;
 	}
 
-	device_init_wakeup(dev, true);
-
 	/* power down device IP for power saving by default */
 	mtu3_stop(mtu);
 
diff --git a/drivers/usb/mtu3/mtu3_plat.c b/drivers/usb/mtu3/mtu3_plat.c
index 4cb65346789d..d78ae52b4e26 100644
--- a/drivers/usb/mtu3/mtu3_plat.c
+++ b/drivers/usb/mtu3/mtu3_plat.c
@@ -356,6 +356,8 @@ static int mtu3_probe(struct platform_device *pdev)
 	pm_runtime_enable(dev);
 	pm_runtime_get_sync(dev);
 
+	device_init_wakeup(dev, true);
+
 	ret = ssusb_rscs_init(ssusb);
 	if (ret)
 		goto comm_init_err;
-- 
2.35.1



