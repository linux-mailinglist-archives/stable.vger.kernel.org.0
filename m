Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F3EB29C305
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 18:42:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1821311AbgJ0Rmd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 13:42:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:59256 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1760090AbgJ0OcW (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:32:22 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2619420754;
        Tue, 27 Oct 2020 14:32:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603809141;
        bh=BVxlaQ4e428YxoBkIKi4lxRZtgM/8yVnXxfe50osDKs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uvoqwKUkui0xiBZ7gUfcjXOG4ifpZ6bk6axoM3pGjTOyrimRb1o5JzkAEpet7rVfl
         p+jTOfrPkLmeMFPcRjQu50NpfVlAXgogSve8VffmUJi//zN6C6mkvuNFs+FOC3r88F
         SJMxuMarfLEUgv/U59QjpmgPXDBghfrKOACcabyg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Qiushi Wu <wu000273@umn.edu>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 091/408] media: rcar-vin: Fix a reference count leak.
Date:   Tue, 27 Oct 2020 14:50:29 +0100
Message-Id: <20201027135459.308237140@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135455.027547757@linuxfoundation.org>
References: <20201027135455.027547757@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qiushi Wu <wu000273@umn.edu>

[ Upstream commit aaffa0126a111d65f4028c503c76192d4cc93277 ]

pm_runtime_get_sync() increments the runtime PM usage counter even
when it returns an error code. Thus call pm_runtime_put_noidle()
if pm_runtime_get_sync() fails.

Fixes: 90dedce9bc54 ("media: rcar-vin: add function to manipulate Gen3 chsel value")
Signed-off-by: Qiushi Wu <wu000273@umn.edu>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/rcar-vin/rcar-dma.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/rcar-vin/rcar-dma.c b/drivers/media/platform/rcar-vin/rcar-dma.c
index 3cb29b2e0b2b1..e5f6360801082 100644
--- a/drivers/media/platform/rcar-vin/rcar-dma.c
+++ b/drivers/media/platform/rcar-vin/rcar-dma.c
@@ -1334,8 +1334,10 @@ int rvin_set_channel_routing(struct rvin_dev *vin, u8 chsel)
 	int ret;
 
 	ret = pm_runtime_get_sync(vin->dev);
-	if (ret < 0)
+	if (ret < 0) {
+		pm_runtime_put_noidle(vin->dev);
 		return ret;
+	}
 
 	/* Make register writes take effect immediately. */
 	vnmc = rvin_read(vin, VNMC_REG);
-- 
2.25.1



