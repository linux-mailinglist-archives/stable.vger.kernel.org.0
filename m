Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 89B5A491866
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 03:47:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345351AbiARCqg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 21:46:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347871AbiARCnT (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 21:43:19 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EB31C06135C;
        Mon, 17 Jan 2022 18:37:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5657CB811CF;
        Tue, 18 Jan 2022 02:37:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE24CC36AEF;
        Tue, 18 Jan 2022 02:37:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642473434;
        bh=zDM+ojreXxp6aysR43uWqt69LDkwRD5ECLE0praKzMQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bF48ybNkrbOMGlxV/LVUNuDiAHr9/RtFB68zKgcYDVqTqKnchPYV8HEx3a3nebhsH
         UW7NRdWw6K3VWiwohbbMSVaCVVezdTmVIyE8Q0btG0fr3L2Ox1PmlNwWQCqWBp4wlt
         ph4b5aMv4w+pnt2JdNakUX0hQCxIq69a9jHdLeSr5lg13ZQOkJ87Mhdlm7z3L1R4OE
         8OLNztJaTj/jssdW509ht+a+MdKNPkdvQXNXE8Cg1Q65GBJG/0NkJzyGmyL/gmmUU/
         wu9OyuJShZnbn7PjQhqS5zOOu451dTZtA++mbe+hcEmU1wnoWmS3XjGhoBYJth/EIa
         mddMpxvh1DtCA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mikhail Rudenko <mike.rudenko@gmail.com>,
        Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>, helen.koike@collabora.com,
        dafna.hirschfeld@collabora.com, mchehab@kernel.org,
        heiko@sntech.de, linux-media@vger.kernel.org,
        linux-rockchip@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 5.15 115/188] media: rockchip: rkisp1: use device name for debugfs subdir name
Date:   Mon, 17 Jan 2022 21:30:39 -0500
Message-Id: <20220118023152.1948105-115-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118023152.1948105-1-sashal@kernel.org>
References: <20220118023152.1948105-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

