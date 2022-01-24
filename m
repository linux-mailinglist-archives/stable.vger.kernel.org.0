Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D60F499C62
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 23:08:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1579256AbiAXWFN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 17:05:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1458122AbiAXVzI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:55:08 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0D6DC07E2AB;
        Mon, 24 Jan 2022 12:37:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4E1C06154F;
        Mon, 24 Jan 2022 20:37:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2365FC340E5;
        Mon, 24 Jan 2022 20:37:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643056643;
        bh=zDM+ojreXxp6aysR43uWqt69LDkwRD5ECLE0praKzMQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QQReqEVIQ1GNqm/syZ7oP2IVr8OPeYuM6idgZ8cfhbqnppsU9e/j99Zk/WTNVNMua
         jW97WUPmOYBVgyMaAqzsCuXFB7eF0AfiTqbAyH/2SIiOG3wIZjv1tDQdIn3NQP346o
         b6Kyt+dmZ8eJgH5M08WVFE58s0LL4yNjl/EDP9cA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mikhail Rudenko <mike.rudenko@gmail.com>,
        Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 553/846] media: rockchip: rkisp1: use device name for debugfs subdir name
Date:   Mon, 24 Jan 2022 19:41:10 +0100
Message-Id: <20220124184120.106923829@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mikhail Rudenko <mike.rudenko@gmail.com>

[ Upstream commit c2611e479f5d9b05108270e1ab423955486b4457 ]

While testing Rockchip RK3399 with both ISPs enabled, a dmesg error
was observed:
```
[   15.559141] debugfs: Directory 'rkisp1' with parent '/' already present!
```

Fix it by using the device name for the debugfs subdirectory name
instead of the driver name, thus preventing name collision.

Link: https://lore.kernel.org/linux-media/20211010175457.438627-1-mike.rudenko@gmail.com
Signed-off-by: Mikhail Rudenko <mike.rudenko@gmail.com>
Reviewed-by: Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>
Reviewed-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/rockchip/rkisp1/rkisp1-dev.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/rockchip/rkisp1/rkisp1-dev.c b/drivers/media/platform/rockchip/rkisp1/rkisp1-dev.c
index 7474150b94ed3..560f928c37520 100644
--- a/drivers/media/platform/rockchip/rkisp1/rkisp1-dev.c
+++ b/drivers/media/platform/rockchip/rkisp1/rkisp1-dev.c
@@ -426,7 +426,7 @@ static void rkisp1_debug_init(struct rkisp1_device *rkisp1)
 {
 	struct rkisp1_debug *debug = &rkisp1->debug;
 
-	debug->debugfs_dir = debugfs_create_dir(RKISP1_DRIVER_NAME, NULL);
+	debug->debugfs_dir = debugfs_create_dir(dev_name(rkisp1->dev), NULL);
 	debugfs_create_ulong("data_loss", 0444, debug->debugfs_dir,
 			     &debug->data_loss);
 	debugfs_create_ulong("outform_size_err", 0444,  debug->debugfs_dir,
-- 
2.34.1



