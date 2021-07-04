Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C1463BB05A
	for <lists+stable@lfdr.de>; Mon,  5 Jul 2021 01:08:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231235AbhGDXIS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 4 Jul 2021 19:08:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:46478 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230346AbhGDXHx (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 4 Jul 2021 19:07:53 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AEB63613FC;
        Sun,  4 Jul 2021 23:05:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625439917;
        bh=H6I1CzE8LzvNbpcekBj5LRlqnEHe8h7OLwJsoz0QF8M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IBg6+SReLSUjMc9tyNf9OWqnwD/hNatQ726up4E1jWJI+ZFmqym9A1Xs37TF9TYaD
         LFJJ2Wjpa7Qc3T6PGQ9AfcJq/TE4EZzyUWI+hp/DhRANLnrZ4ShKq1fa9/fI/jmv5S
         v0/xCyAQQj/tcJz3NPUPgnuOB+tDbdLbTWcirBi12Y0RR8al7uwJGCWYp6qOvhy8iT
         feWGLWHMFPFIm6Wyhkxtp2y3AhkaGeSjX48UjO6LVcBNfHjj/79f8BLnzn/uhAu8bF
         ZadbA3hBSx7Lbp3szjVGTRXOfyVyv9bvq3fGkQoQBQ5E2af3joGXYVAwpDO+pfWrsn
         PC1/nLwqs7Tzg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Igor Matheus Andrade Torrente <igormtorrente@gmail.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 5.13 41/85] media: em28xx: Fix possible memory leak of em28xx struct
Date:   Sun,  4 Jul 2021 19:03:36 -0400
Message-Id: <20210704230420.1488358-41-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210704230420.1488358-1-sashal@kernel.org>
References: <20210704230420.1488358-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Igor Matheus Andrade Torrente <igormtorrente@gmail.com>

[ Upstream commit ac5688637144644f06ed1f3c6d4dd8bb7db96020 ]

The em28xx struct kref isn't being decreased after an error in the
em28xx_ir_init, leading to a possible memory leak.

A kref_put and em28xx_shutdown_buttons is added to the error handler code.

Signed-off-by: Igor Matheus Andrade Torrente <igormtorrente@gmail.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/usb/em28xx/em28xx-input.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/media/usb/em28xx/em28xx-input.c b/drivers/media/usb/em28xx/em28xx-input.c
index 5aa15a7a49de..59529cbf9cd0 100644
--- a/drivers/media/usb/em28xx/em28xx-input.c
+++ b/drivers/media/usb/em28xx/em28xx-input.c
@@ -720,7 +720,8 @@ static int em28xx_ir_init(struct em28xx *dev)
 			dev->board.has_ir_i2c = 0;
 			dev_warn(&dev->intf->dev,
 				 "No i2c IR remote control device found.\n");
-			return -ENODEV;
+			err = -ENODEV;
+			goto ref_put;
 		}
 	}
 
@@ -735,7 +736,7 @@ static int em28xx_ir_init(struct em28xx *dev)
 
 	ir = kzalloc(sizeof(*ir), GFP_KERNEL);
 	if (!ir)
-		return -ENOMEM;
+		goto ref_put;
 	rc = rc_allocate_device(RC_DRIVER_SCANCODE);
 	if (!rc)
 		goto error;
@@ -839,6 +840,9 @@ static int em28xx_ir_init(struct em28xx *dev)
 	dev->ir = NULL;
 	rc_free_device(rc);
 	kfree(ir);
+ref_put:
+	em28xx_shutdown_buttons(dev);
+	kref_put(&dev->ref, em28xx_free_device);
 	return err;
 }
 
-- 
2.30.2

