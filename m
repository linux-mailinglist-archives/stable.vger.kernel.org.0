Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B40033BC2AC
	for <lists+stable@lfdr.de>; Mon,  5 Jul 2021 20:31:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229873AbhGESeM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Jul 2021 14:34:12 -0400
Received: from gofer.mess.org ([88.97.38.141]:43111 "EHLO gofer.mess.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229807AbhGESeM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Jul 2021 14:34:12 -0400
Received: by gofer.mess.org (Postfix, from userid 1000)
        id 33A5EC6321; Mon,  5 Jul 2021 19:31:33 +0100 (BST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=mess.org; s=2020;
        t=1625509893; bh=C97Jf0IqMGc/9Ae4C0upgpgnrECJPBkfBahrQt6SAok=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=D/eewfO6zf4agoMwKBmFtNv+Yr3+DlmXur1NZ/vGOGrBQzLObaVwyG9ibsnnWsLps
         jwXywGW9+nlNh/5B5KFX3fFVFS03OPTPtwzGfXsZo5K5UHmRqicskKywGJXQjWprTV
         GQtFbJEp7l3q1C/6cGxfAq0FOOp5Jb6EUAppRh3ROFbzFeFVJrX3oTYYCWYP0GiHSQ
         cGiakbWfGuWfzs3CeG7/dB55bsFBEr6GWoMf2gtGZu60jLEw2An73VZnBw/OUaWNma
         UUmcgJ/HFRP8J0kiR6gHPn8NYfxiR/QAySnv9MXqVimjiHXYwL7Eqocsu/r5ntkxh3
         Ri6EL+RgEWJdw==
From:   Sean Young <sean@mess.org>
To:     linux-media@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: [PATCH v2 1/5] media: rc-loopback: return number of emitters rather than error
Date:   Mon,  5 Jul 2021 19:31:28 +0100
Message-Id: <1c0df5716e9aa335d6d47558b3a1c7fbd7477bc7.1625509803.git.sean@mess.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <cover.1625509803.git.sean@mess.org>
References: <cover.1625509803.git.sean@mess.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The LIRC_SET_TRANSMITTER_MASK ioctl should return the number of emitters
if an invalid list was set.

Cc: stable@vger.kernel.org
Signed-off-by: Sean Young <sean@mess.org>
---
 drivers/media/rc/rc-loopback.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/rc/rc-loopback.c b/drivers/media/rc/rc-loopback.c
index 1ba3f96ffa7d..40ab66c850f2 100644
--- a/drivers/media/rc/rc-loopback.c
+++ b/drivers/media/rc/rc-loopback.c
@@ -42,7 +42,7 @@ static int loop_set_tx_mask(struct rc_dev *dev, u32 mask)
 
 	if ((mask & (RXMASK_REGULAR | RXMASK_LEARNING)) != mask) {
 		dprintk("invalid tx mask: %u\n", mask);
-		return -EINVAL;
+		return 2;
 	}
 
 	dprintk("setting tx mask: %u\n", mask);
-- 
2.31.1

