Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B772247102
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 20:19:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390772AbgHQSTh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 14:19:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:53176 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387902AbgHQQFX (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 12:05:23 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EF1D6207FF;
        Mon, 17 Aug 2020 16:05:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597680304;
        bh=Z6wxDB/kNNPoBu4IE1f6YOWOpB/XzsTJije4bwfd+5o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=T8NAFZLUIlvZZH/RYSVWsh4Y/1d6+QorEXvC+2KEE2AqXt4UJkV956UNgLM9vaAvn
         sy2tjoLg0hrEowC2jQImDZqFWhF9AWtsgsAbW23wnI0P+PbpwOnJxsfrYctlIqGKIn
         2YvysJuYOL3TUDOijrA6ZtiQ6+MuoadCXubhHAPE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dariusz Marcinkiewicz <darekm@google.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 126/270] media: cros-ec-cec: do not bail on device_init_wakeup failure
Date:   Mon, 17 Aug 2020 17:15:27 +0200
Message-Id: <20200817143802.057347794@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143755.807583758@linuxfoundation.org>
References: <20200817143755.807583758@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dariusz Marcinkiewicz <darekm@google.com>

[ Upstream commit 6f01dfb760c027d5dd6199d91ee9599f2676b5c6 ]

Do not fail probing when device_init_wakeup fails.

device_init_wakeup fails when the device is already enabled as wakeup
device. Hence, the driver fails to probe the device if:
- The device has already been enabled for wakeup (by e.g. sysfs)
- The driver has been unloaded and is being loaded again.

This goal of the patch is to fix the above cases.

Overwhelming majority of the drivers do not check device_init_wakeup
return code.

Fixes: cd70de2d356ee ("media: platform: Add ChromeOS EC CEC driver")
Signed-off-by: Dariusz Marcinkiewicz <darekm@google.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/cros-ec-cec/cros-ec-cec.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/drivers/media/platform/cros-ec-cec/cros-ec-cec.c b/drivers/media/platform/cros-ec-cec/cros-ec-cec.c
index 4a3b3810fd895..31390ce2dbf2d 100644
--- a/drivers/media/platform/cros-ec-cec/cros-ec-cec.c
+++ b/drivers/media/platform/cros-ec-cec/cros-ec-cec.c
@@ -278,11 +278,7 @@ static int cros_ec_cec_probe(struct platform_device *pdev)
 	platform_set_drvdata(pdev, cros_ec_cec);
 	cros_ec_cec->cros_ec = cros_ec;
 
-	ret = device_init_wakeup(&pdev->dev, 1);
-	if (ret) {
-		dev_err(&pdev->dev, "failed to initialize wakeup\n");
-		return ret;
-	}
+	device_init_wakeup(&pdev->dev, 1);
 
 	cros_ec_cec->adap = cec_allocate_adapter(&cros_ec_cec_ops, cros_ec_cec,
 						 DRV_NAME,
-- 
2.25.1



