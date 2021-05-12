Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DD5337CD50
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 19:13:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238484AbhELQyO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:54:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:35700 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243756AbhELQmB (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:42:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 705BE61959;
        Wed, 12 May 2021 16:06:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620835590;
        bh=OPilQ3elZv6OQHFnUhl9jytN63+Xh4iDZ11ez+SXlrg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RXk3Chtlvgb9MX7McLagO5Hhjp+7bidcZ/P5OPokWV1R7JzuBYlKkkvT9P7cB6aO2
         fvfCT4E43IoKhL4OoFRTD/oPbHgGfxQpH795SPzRil0Qlk8Sw7+LJJ90KZ2CogQLtT
         qwhnJT+k9qZTSTClu0mlsHPO2g+4pB9G8BV9/xKI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Jacopo Mondi <jacopo+renesas@jmondi.org>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 404/677] media: i2c: rdamc21: Fix warning on u8 cast
Date:   Wed, 12 May 2021 16:47:30 +0200
Message-Id: <20210512144850.756268035@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144837.204217980@linuxfoundation.org>
References: <20210512144837.204217980@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jacopo Mondi <jacopo+renesas@jmondi.org>

[ Upstream commit 5f58ac04f36e32507d8f60fd47266ae2a60a2fa8 ]

Sparse reports a warning on a cast to u8 of a 16 bits constant.

drivers/media/i2c/rdacm21.c:348:62: warning: cast truncates bits
from constant value (300a becomes a)

Even if the behaviour is intended, silence the sparse warning replacing
the cast with a bitwise & operation.

Fixes: a59f853b3b4b ("media: i2c: Add driver for RDACM21 camera module")
Reported-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Reviewed-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Jacopo Mondi <jacopo+renesas@jmondi.org>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/rdacm21.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/i2c/rdacm21.c b/drivers/media/i2c/rdacm21.c
index dcc21515e5a4..179d107f494c 100644
--- a/drivers/media/i2c/rdacm21.c
+++ b/drivers/media/i2c/rdacm21.c
@@ -345,7 +345,7 @@ static int ov10640_initialize(struct rdacm21_device *dev)
 	/* Read OV10640 ID to test communications. */
 	ov490_write_reg(dev, OV490_SCCB_SLAVE0_DIR, OV490_SCCB_SLAVE_READ);
 	ov490_write_reg(dev, OV490_SCCB_SLAVE0_ADDR_HIGH, OV10640_CHIP_ID >> 8);
-	ov490_write_reg(dev, OV490_SCCB_SLAVE0_ADDR_LOW, (u8)OV10640_CHIP_ID);
+	ov490_write_reg(dev, OV490_SCCB_SLAVE0_ADDR_LOW, OV10640_CHIP_ID & 0xff);
 
 	/* Trigger SCCB slave transaction and give it some time to complete. */
 	ov490_write_reg(dev, OV490_HOST_CMD, OV490_HOST_CMD_TRIGGER);
-- 
2.30.2



