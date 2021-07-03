Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 035693BA91B
	for <lists+stable@lfdr.de>; Sat,  3 Jul 2021 17:04:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229900AbhGCPGd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 3 Jul 2021 11:06:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52494 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229865AbhGCPGc (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 3 Jul 2021 11:06:32 -0400
Received: from gofer.mess.org (gofer.mess.org [IPv6:2a02:8011:d000:212::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBDE1C061764;
        Sat,  3 Jul 2021 08:03:57 -0700 (PDT)
Received: by gofer.mess.org (Postfix, from userid 1000)
        id 5D19FC63BB; Sat,  3 Jul 2021 16:03:54 +0100 (BST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=mess.org; s=2020;
        t=1625324634; bh=nYJSqwT7wPEaON3HYmDIAmj4Y5R9jQI/E84Fxq3j/do=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qurOP/ofL0swqR552iQ+Qo1lpxJxmREtEHrCeN5H1k4qOk5LkGviAzmPXzEmjJM2q
         iVWd9dsUJWi1IvIHs8zNV0wkubYd5P6S1dnP1aiv9KE5xBGN2LfcMIK9MefvCEhPc5
         jVi2eBuBChxTi1385+sU2kXUcGFAS4+ALt3eEjFkr9pEXrQZGgNg4F04WsNpOKu1Wq
         odVohJTei2WhAY9VE3Ar+YS8uR2MiW2T3WaH5bKvNUz4NYJD5XMLLLpeVbqlT+logY
         mkoVLc9ukNg12U5ydKVU9C5uuXM45EIgmRVabRLjlYgl0kXV8/6TKhjgxia6C44D3p
         cgeq/Nc570RQQ==
From:   Sean Young <sean@mess.org>
To:     linux-media@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: [PATCH 1/4] media: rc-loopback: return set of valid emitters rather error
Date:   Sat,  3 Jul 2021 16:03:51 +0100
Message-Id: <3794b019b5ba41fcc2b1212c89b170129e1859c6.1625324530.git.sean@mess.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <cover.1625324530.git.sean@mess.org>
References: <cover.1625324530.git.sean@mess.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The LIRC_SET_TRANSMITTER_MASK ioctl should return a list valid emitters
if an invalid list was passed.

Cc: stable@vger.kernel.org
Signed-off-by: Sean Young <sean@mess.org>
---
 drivers/media/rc/rc-loopback.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/rc/rc-loopback.c b/drivers/media/rc/rc-loopback.c
index 1ba3f96ffa7d..15212244f83c 100644
--- a/drivers/media/rc/rc-loopback.c
+++ b/drivers/media/rc/rc-loopback.c
@@ -42,7 +42,7 @@ static int loop_set_tx_mask(struct rc_dev *dev, u32 mask)
 
 	if ((mask & (RXMASK_REGULAR | RXMASK_LEARNING)) != mask) {
 		dprintk("invalid tx mask: %u\n", mask);
-		return -EINVAL;
+		return RXMASK_REGULAR | RXMASK_LEARNING;
 	}
 
 	dprintk("setting tx mask: %u\n", mask);
-- 
2.31.1

