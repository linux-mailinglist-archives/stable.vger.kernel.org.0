Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4E3D811B083
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 16:23:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732550AbfLKPXe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 10:23:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:54606 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732729AbfLKPXd (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 10:23:33 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C3E382073D;
        Wed, 11 Dec 2019 15:23:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576077813;
        bh=yrCqURBF1LS8Yk5NB9S0YYrG5mdalSXhXTNPvL/2Jew=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ud+4YPcf0yUUf70YR3lG3ugiFczwk1vCDdfS/itV45PGcCeOwZG8iYUnHwBMFLfht
         iJAKp4ziBPSeOuDrZq9W5vvZEBzEcjCw8VFJ+TrvYQar7Poilgw8YODschpcll7n43
         WchR4r5l3vwG4EKaVdbpEluRi6kdaOyQwEFyV9AM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andreas Pape <ap@ca-pape.de>,
        Kieran Bingham <kieran.bingham@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 179/243] media: stkwebcam: Bugfix for wrong return values
Date:   Wed, 11 Dec 2019 16:05:41 +0100
Message-Id: <20191211150351.254659809@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191211150339.185439726@linuxfoundation.org>
References: <20191211150339.185439726@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andreas Pape <ap@ca-pape.de>

[ Upstream commit 3c28b91380dd1183347d32d87d820818031ebecf ]

usb_control_msg returns in case of a successfully sent message the number
of sent bytes as a positive number. Don't use this value as a return value
for stk_camera_read_reg, as a non-zero return value is used as an error
condition in some cases when stk_camera_read_reg is called.

Signed-off-by: Andreas Pape <ap@ca-pape.de>
Reviewed-by: Kieran Bingham <kieran.bingham@ideasonboard.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/usb/stkwebcam/stk-webcam.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/media/usb/stkwebcam/stk-webcam.c b/drivers/media/usb/stkwebcam/stk-webcam.c
index 6e3f234e790b8..e33fa78ef98dd 100644
--- a/drivers/media/usb/stkwebcam/stk-webcam.c
+++ b/drivers/media/usb/stkwebcam/stk-webcam.c
@@ -164,7 +164,11 @@ int stk_camera_read_reg(struct stk_camera *dev, u16 index, u8 *value)
 		*value = *buf;
 
 	kfree(buf);
-	return ret;
+
+	if (ret < 0)
+		return ret;
+	else
+		return 0;
 }
 
 static int stk_start_stream(struct stk_camera *dev)
-- 
2.20.1



