Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A26533C484F
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:29:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236788AbhGLGhp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:37:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:55158 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235401AbhGLGgW (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:36:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 24F5260FD8;
        Mon, 12 Jul 2021 06:33:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626071588;
        bh=pm0P6MIYFV4UwASFGjmsJVkEZD7UJkVgOjZ807PFSkk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TlzRX0A2v8pe/b/Yvw0OVGzk4Rr1cHoCsLh6PBZy228ZE7cKp0qalBy5YIMuVB11/
         oinSaEFw6oZx525J6LnCtU5gzb3APFikEeSgIMPWch6aovZtRyxx2aMOtqORBLU9Lf
         xqquLeb600Bp+za8o+jVyYDuFcR7SRf0tlq3dycQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Igor Matheus Andrade Torrente <igormtorrente@gmail.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 134/593] media: em28xx: Fix possible memory leak of em28xx struct
Date:   Mon, 12 Jul 2021 08:04:54 +0200
Message-Id: <20210712060857.848914762@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060843.180606720@linuxfoundation.org>
References: <20210712060843.180606720@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
@@ -839,6 +840,9 @@ error:
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



