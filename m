Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2512A491588
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 03:28:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343978AbiARC2j (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 21:28:39 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:43796 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244676AbiARC0g (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 21:26:36 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C279261157;
        Tue, 18 Jan 2022 02:26:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDA35C36AEF;
        Tue, 18 Jan 2022 02:26:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642472795;
        bh=s1+wA1K07F5Sne0E08ebjE9IXHWGC4ncgOKASX8xlfM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uHP7lZybTGN9ygG6xWy+Df3c6i686PG/BPlv5ppxOB28B3BN3CqBFGk3YsBP1Xqrc
         jg0Aw//CHR/x0eyVKh2yvyk9dpdFIa6cEOU5+LHtW/f36/FyRoFLz78lyC10CNdrCj
         kA4fl903hOHVkfav7EGrUaToxFY9wwZW7N24FA0Y0GIFkdwfrnU7bYLqLqkhDl5pHd
         lYQVHY8XTu0CJaT1nLQ8jK7Pfk1rBvbOqLxwzatO29GIh/VxMsX/YFNC9TY5J8oaT+
         HOo8TkcXtVJMH1B79NAz4ZaeyXRNIOLwSlbNLwHXMaH1vUCOVV97FT37urSjrw3Wn/
         xhBLNRkKbJ9ww==
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
Subject: [PATCH AUTOSEL 5.16 135/217] media: rockchip: rkisp1: use device name for debugfs subdir name
Date:   Mon, 17 Jan 2022 21:18:18 -0500
Message-Id: <20220118021940.1942199-135-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118021940.1942199-1-sashal@kernel.org>
References: <20220118021940.1942199-1-sashal@kernel.org>
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
index 50b166c49a03a..3f5cfa7eb9372 100644
--- a/drivers/media/platform/rockchip/rkisp1/rkisp1-dev.c
+++ b/drivers/media/platform/rockchip/rkisp1/rkisp1-dev.c
@@ -462,7 +462,7 @@ static void rkisp1_debug_init(struct rkisp1_device *rkisp1)
 {
 	struct rkisp1_debug *debug = &rkisp1->debug;
 
-	debug->debugfs_dir = debugfs_create_dir(RKISP1_DRIVER_NAME, NULL);
+	debug->debugfs_dir = debugfs_create_dir(dev_name(rkisp1->dev), NULL);
 	debugfs_create_ulong("data_loss", 0444, debug->debugfs_dir,
 			     &debug->data_loss);
 	debugfs_create_ulong("outform_size_err", 0444,  debug->debugfs_dir,
-- 
2.34.1

