Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A5B77121831
	for <lists+stable@lfdr.de>; Mon, 16 Dec 2019 19:42:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729022AbfLPSAw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 13:00:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:35318 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729014AbfLPSAv (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Dec 2019 13:00:51 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5943020726;
        Mon, 16 Dec 2019 18:00:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576519250;
        bh=+vuE0SJ/uHWQr+87i2aXr+YmFOdOSLxYkw5YQuOsSLQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=u5VdPH7qWuBBJnydzus+pOUIjBgjRR7qb17tl51d40XfPZxKq+pNsKYMhBiqfLWhh
         haAy3P0l/Zjaq1tkXuRoeCNwsKzPXlHJjIhjw0A15YkIgrQhM6v71Bgq9+IVQkOQXp
         x0G4SYb2bNUtjO0ewuleiuYs2fJs9Tft9e0J/GPk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Helen Koike <helen.koike@collabora.com>,
        Boris Brezillon <boris.brezillon@collabora.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 257/267] media: vimc: fix component match compare
Date:   Mon, 16 Dec 2019 18:49:43 +0100
Message-Id: <20191216174916.788330411@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191216174848.701533383@linuxfoundation.org>
References: <20191216174848.701533383@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Helen Koike <helen.koike@collabora.com>

[ Upstream commit ee1c71a8e1456ab53fe667281d855849edf26a4d ]

If the system has other devices being registered in the component
framework, the compare function will be called with a device that
doesn't belong to vimc.
This device is not necessarily a platform_device, nor have a
platform_data (which causes a NULL pointer dereference error) and if it
does have a pdata, it is not necessarily type of struct vimc_platform_data.
So casting to any of these types is wrong.

Instead of expecting a given pdev with a given pdata, just expect for
the device it self. vimc-core is the one who creates them, we know in
advance exactly which object to expect in the match.

Fixes: 4a29b7090749 ("[media] vimc: Subdevices as modules")

Signed-off-by: Helen Koike <helen.koike@collabora.com>
Reviewed-by: Boris Brezillon <boris.brezillon@collabora.com>
Tested-by: Boris Brezillon <boris.brezillon@collabora.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/vimc/vimc-core.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/media/platform/vimc/vimc-core.c b/drivers/media/platform/vimc/vimc-core.c
index 57e5d6a020b0e..447a01ff4e23c 100644
--- a/drivers/media/platform/vimc/vimc-core.c
+++ b/drivers/media/platform/vimc/vimc-core.c
@@ -243,10 +243,7 @@ static void vimc_comp_unbind(struct device *master)
 
 static int vimc_comp_compare(struct device *comp, void *data)
 {
-	const struct platform_device *pdev = to_platform_device(comp);
-	const char *name = data;
-
-	return !strcmp(pdev->dev.platform_data, name);
+	return comp == data;
 }
 
 static struct component_match *vimc_add_subdevs(struct vimc_device *vimc)
@@ -275,7 +272,7 @@ static struct component_match *vimc_add_subdevs(struct vimc_device *vimc)
 		}
 
 		component_match_add(&vimc->pdev.dev, &match, vimc_comp_compare,
-				    (void *)vimc->pipe_cfg->ents[i].name);
+				    &vimc->subdevs[i]->dev);
 	}
 
 	return match;
-- 
2.20.1



