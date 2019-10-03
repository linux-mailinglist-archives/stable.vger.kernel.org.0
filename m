Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 19DBBCA684
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 18:56:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405384AbfJCQod (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 12:44:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:56664 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405377AbfJCQoc (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 12:44:32 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 42181206BB;
        Thu,  3 Oct 2019 16:44:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570121071;
        bh=bFLCTGyYohymiALd+WKgy6NVhCk0aLlPxI6AHXlCS/0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MTrJThkwPBbIsy806+kzW99656kAueRDrTX6r7Y06CPTX57BLjYJdDBihxJQuaeAu
         LKtwhF/twRK3kKIjJBnq/8geKiGd2Q0sGnC2tGuvdnXlGd+0Cy80+WEEmiBJPg1DOB
         Hurj3m6csy6tUUCqipDGNXHnYJ6mcyA5Y8hyAvLg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 108/344] media: fdp1: Reduce FCP not found message level to debug
Date:   Thu,  3 Oct 2019 17:51:13 +0200
Message-Id: <20191003154550.859307945@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154540.062170222@linuxfoundation.org>
References: <20191003154540.062170222@linuxfoundation.org>
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
index 43aae9b6bb20e..c23ec127c2776 100644
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



