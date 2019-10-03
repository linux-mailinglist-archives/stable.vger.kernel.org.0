Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7B867CA888
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 19:19:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391485AbfJCQ2O (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 12:28:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:60674 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391482AbfJCQ2N (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 12:28:13 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8C92221783;
        Thu,  3 Oct 2019 16:28:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570120092;
        bh=IXyyax35NLJ6YWTbr1HB6lNWXUjGA3if8XZRop/f770=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Dda2HUq/IwrseVj0cbjoppS+mZjRVsnNQuI2f4r52xQQsDw0tBFV3PkINb3+x9l2h
         kiHMuKQKCMsvU4gCiSEzopJ23quo4+p2eRDDEsnjDJuxkrwldrnJ/GVSTM3pLJHYO1
         ryGdSKO8zENSn7B2B5fhXS0rEeK4k2BLElLlIhBo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 095/313] media: fdp1: Reduce FCP not found message level to debug
Date:   Thu,  3 Oct 2019 17:51:13 +0200
Message-Id: <20191003154542.235103460@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154533.590915454@linuxfoundation.org>
References: <20191003154533.590915454@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



