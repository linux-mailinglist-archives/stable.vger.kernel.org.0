Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9768A32850F
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 17:50:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235432AbhCAQsQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 11:48:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:43464 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234814AbhCAQlB (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 11:41:01 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 141AA64EE6;
        Mon,  1 Mar 2021 16:29:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614616141;
        bh=wwx+OBKzcmj9v4GT1cz5IeUSPnHG4SqCokbmRCxzNUU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=faS9SCVkkYqtN0KdKlocImEccjIac7Z+fUGPiBLYj3qA5NVxJuhXKliIH9vcW13gx
         0CsoI4MTm1C3w8D2ZqrxJGVqdJ6A65mduwxWa22m97wX8g8o0xb0DurMvDrvpdm7zC
         3FadkQDs3gZyHSplFCRxIgl+NA2sA7R918vnlPGg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 048/176] media: vsp1: Fix an error handling path in the probe function
Date:   Mon,  1 Mar 2021 17:12:01 +0100
Message-Id: <20210301161023.352146458@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161020.931630716@linuxfoundation.org>
References: <20210301161020.931630716@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit 7113469dafc2d545fa4fa9bc649c31dc27db492e ]

A previous 'rcar_fcp_get()' call must be undone in the error handling path,
as already done in the remove function.

Fixes: 94fcdf829793 ("[media] v4l: vsp1: Add FCP support")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reviewed-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/vsp1/vsp1_drv.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/media/platform/vsp1/vsp1_drv.c b/drivers/media/platform/vsp1/vsp1_drv.c
index 5836fb298de27..1b0c236e70fd3 100644
--- a/drivers/media/platform/vsp1/vsp1_drv.c
+++ b/drivers/media/platform/vsp1/vsp1_drv.c
@@ -866,8 +866,10 @@ static int vsp1_probe(struct platform_device *pdev)
 	}
 
 done:
-	if (ret)
+	if (ret) {
 		pm_runtime_disable(&pdev->dev);
+		rcar_fcp_put(vsp1->fcp);
+	}
 
 	return ret;
 }
-- 
2.27.0



