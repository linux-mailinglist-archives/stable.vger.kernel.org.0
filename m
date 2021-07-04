Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF5103BB313
	for <lists+stable@lfdr.de>; Mon,  5 Jul 2021 01:15:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232986AbhGDXRK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 4 Jul 2021 19:17:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:50502 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234057AbhGDXOw (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 4 Jul 2021 19:14:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C15A06162A;
        Sun,  4 Jul 2021 23:11:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625440264;
        bh=S/VLIVkYk1uLWSewoxryVdCxBD48RHaJTth9LF1k63Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=F6EPCciY5OQU120bYdBDZ+5zwTnC6NUdMnjiEHs5w1bmciEV7Ab0fOYBXT9jH5AqS
         /rm6DSJ6caksR11n5UunOJCs5ez4pkj4gG1vxSIQkIl+VoBhmUppI9WsoHyLeV4ML0
         WHaq/zKLinLHUEs3zfBzQXRQfmUKgxCiewfD4u9RwzIPqAC4xldgvzYsl+13ZA5hqn
         87/efOxX8h24/FMgszh1uKQWIRL6cjfBOF8dhSDXvIZL7LxIbedHx2yY9MVeCMZq6N
         9yvpj5Dwji4JtaCoEnadmW5bqqlZHJ0+IaS1qGr5MAmoAKdA24hybLi7VSFPaEYQ40
         un7MCXqOybg9A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Igor Matheus Andrade Torrente <igormtorrente@gmail.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 16/31] media: em28xx: Fix possible memory leak of em28xx struct
Date:   Sun,  4 Jul 2021 19:10:28 -0400
Message-Id: <20210704231043.1491209-16-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210704231043.1491209-1-sashal@kernel.org>
References: <20210704231043.1491209-1-sashal@kernel.org>
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
index f84a1208d5d3..3612f0d730dd 100644
--- a/drivers/media/usb/em28xx/em28xx-input.c
+++ b/drivers/media/usb/em28xx/em28xx-input.c
@@ -736,7 +736,8 @@ static int em28xx_ir_init(struct em28xx *dev)
 			dev->board.has_ir_i2c = 0;
 			dev_warn(&dev->intf->dev,
 				 "No i2c IR remote control device found.\n");
-			return -ENODEV;
+			err = -ENODEV;
+			goto ref_put;
 		}
 	}
 
@@ -751,7 +752,7 @@ static int em28xx_ir_init(struct em28xx *dev)
 
 	ir = kzalloc(sizeof(*ir), GFP_KERNEL);
 	if (!ir)
-		return -ENOMEM;
+		goto ref_put;
 	rc = rc_allocate_device(RC_DRIVER_SCANCODE);
 	if (!rc)
 		goto error;
@@ -862,6 +863,9 @@ static int em28xx_ir_init(struct em28xx *dev)
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

