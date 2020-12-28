Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 510D02E3758
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 13:54:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728259AbgL1MyJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 07:54:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:50798 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728312AbgL1MyF (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 07:54:05 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0CCC8207C9;
        Mon, 28 Dec 2020 12:53:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609160029;
        bh=PJPfqOCIwCtxfZRcij9grBZ2SWWpzfuOijX5NuUNmEk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NKj/I5IXbpQYrRY5eHKNpXDxasw/oa6g7eKut9zuIFOeKOich+TF0I0MDZ930FqRB
         fHwlteBMA5zr3S7ofbWrcoM7Q7Dg1oxIiyyB1oJv5AVd5CWXFgnQ7W/zEtu/npX8Rw
         1aQs4YbdNT7y+Tfyq4Qd4c8SaW2q7Mis1zlKvH2g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 049/132] Input: ads7846 - fix unaligned access on 7845
Date:   Mon, 28 Dec 2020 13:48:53 +0100
Message-Id: <20201228124848.806279622@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124846.409999325@linuxfoundation.org>
References: <20201228124846.409999325@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

[ Upstream commit 03e2c9c782f721b661a0e42b1b58f394b5298544 ]

req->sample[1] is not naturally aligned at word boundary, and therefore we
should use get_unaligned_be16() when accessing it.

Fixes: 3eac5c7e44f3 ("Input: ads7846 - extend the driver for ads7845 controller support")
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/input/touchscreen/ads7846.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/input/touchscreen/ads7846.c b/drivers/input/touchscreen/ads7846.c
index b4ded36cc4162..1d98198c4bdfb 100644
--- a/drivers/input/touchscreen/ads7846.c
+++ b/drivers/input/touchscreen/ads7846.c
@@ -35,6 +35,7 @@
 #include <linux/regulator/consumer.h>
 #include <linux/module.h>
 #include <asm/irq.h>
+#include <asm/unaligned.h>
 
 /*
  * This code has been heavily tested on a Nokia 770, and lightly
@@ -410,7 +411,7 @@ static int ads7845_read12_ser(struct device *dev, unsigned command)
 
 	if (status == 0) {
 		/* BE12 value, then padding */
-		status = be16_to_cpu(*((u16 *)&req->sample[1]));
+		status = get_unaligned_be16(&req->sample[1]);
 		status = status >> 3;
 		status &= 0x0fff;
 	}
-- 
2.27.0



