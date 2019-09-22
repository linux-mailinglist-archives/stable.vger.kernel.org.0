Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BFB4FBA68B
	for <lists+stable@lfdr.de>; Sun, 22 Sep 2019 21:46:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404979AbfIVSvX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Sep 2019 14:51:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:49158 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404935AbfIVSvX (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 22 Sep 2019 14:51:23 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 886742190F;
        Sun, 22 Sep 2019 18:51:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569178282;
        bh=IXyyax35NLJ6YWTbr1HB6lNWXUjGA3if8XZRop/f770=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=V5zd9nRh5tffXN9AsP+ZTiob+elXIuIjWyCtYinC8IqJx3vEqoj3EevNML9p/dE5N
         fhbk9zGG2H9qEKB4zqOLwWsffeSWOQjzCPBT4VCPSPjibCj8yIOLc0zBcGBuYLpDN6
         bS0pWIqDCkDsW/Ha8rB5LhGReXUBG78syIBLsO/I=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Geert Uytterhoeven <geert+renesas@glider.be>,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
Subject: [PATCH AUTOSEL 5.2 063/185] media: fdp1: Reduce FCP not found message level to debug
Date:   Sun, 22 Sep 2019 14:47:21 -0400
Message-Id: <20190922184924.32534-63-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190922184924.32534-1-sashal@kernel.org>
References: <20190922184924.32534-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit 4fd22938569c14f6092c05880ca387409d78355f ]

When support for the IPMMU is not enabled, the FDP driver may be
probe-deferred multiple times, causing several messages to be printed
like:

    rcar_fdp1 fe940000.fdp1: FCP not found (-517)
    rcar_fdp1 fe944000.fdp1: FCP not found (-517)

Fix this by reducing the message level to debug level, as is done in the
VSP1 driver.

Fixes: 4710b752e029f3f8 ("[media] v4l: Add Renesas R-Car FDP1 Driver")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reviewed-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/rcar_fdp1.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/platform/rcar_fdp1.c b/drivers/media/platform/rcar_fdp1.c
index b8615a288e2b7..6ca2cb15291f1 100644
--- a/drivers/media/platform/rcar_fdp1.c
+++ b/drivers/media/platform/rcar_fdp1.c
@@ -2306,7 +2306,7 @@ static int fdp1_probe(struct platform_device *pdev)
 		fdp1->fcp = rcar_fcp_get(fcp_node);
 		of_node_put(fcp_node);
 		if (IS_ERR(fdp1->fcp)) {
-			dev_err(&pdev->dev, "FCP not found (%ld)\n",
+			dev_dbg(&pdev->dev, "FCP not found (%ld)\n",
 				PTR_ERR(fdp1->fcp));
 			return PTR_ERR(fdp1->fcp);
 		}
-- 
2.20.1

