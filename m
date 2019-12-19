Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 74F7A126CD0
	for <lists+stable@lfdr.de>; Thu, 19 Dec 2019 20:06:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728999AbfLSSo3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Dec 2019 13:44:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:36482 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728216AbfLSSo3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Dec 2019 13:44:29 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CDB6024672;
        Thu, 19 Dec 2019 18:44:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576781068;
        bh=+YAmTaND9wQX1INLoAIes12pJjrdbmC96OQLhzaGlPk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zQNQjzqtyXb8ykuH6kEzfIFD7mcodjoK9bdJdbUwjQDbTxXChsbpsqXBDhrOQQ8Uz
         uMFw0J0O5Am/7nF6obcTVmE0QOx3RQrNa9Cmo6r2ksgA2s60NgZSMbRQN0nVdeuuEb
         vxP/3VEr9+wBCZ/PVxt8FmGkwFPolJnmfLQJRmas=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andreas Pape <ap@ca-pape.de>,
        Kieran Bingham <kieran.bingham@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 068/199] media: stkwebcam: Bugfix for wrong return values
Date:   Thu, 19 Dec 2019 19:32:30 +0100
Message-Id: <20191219183218.762617898@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191219183214.629503389@linuxfoundation.org>
References: <20191219183214.629503389@linuxfoundation.org>
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
index 7297fd261df94..f9844f87467b4 100644
--- a/drivers/media/usb/stkwebcam/stk-webcam.c
+++ b/drivers/media/usb/stkwebcam/stk-webcam.c
@@ -166,7 +166,11 @@ int stk_camera_read_reg(struct stk_camera *dev, u16 index, u8 *value)
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



