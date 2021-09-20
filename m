Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59146411A1E
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 18:45:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240261AbhITQrQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 12:47:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:35444 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242570AbhITQrO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 12:47:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8050361177;
        Mon, 20 Sep 2021 16:45:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632156347;
        bh=wv6aURyAnnH/nWZotmWW8eObxb+iKMxZlbflWjJi1Ls=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Nc0KdLmgjwDbrHqrtI2zrHSpHsDSdy39VuzwyGLt3rv2UGn+eneoXbJXALv8LEe5A
         vinYrsj9TEOkP8a6r8kBDsAEVyAlxRZDNj5dqxAoWLAAj/vK6Nr7clR1KokYJzY7Qq
         e9SjynnqKTxla+Z5N2IoKLZSk92r5oDxyMRthjgs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Arnd Bergmann <arnd@arndb.de>,
        Hans Verkuil <hansverk@cisco.com>
Subject: [PATCH 4.4 018/133] [media] tc358743: fix register i2c_rd/wr function fix
Date:   Mon, 20 Sep 2021 18:41:36 +0200
Message-Id: <20210920163913.207088483@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163912.603434365@linuxfoundation.org>
References: <20210920163912.603434365@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Philipp Zabel <p.zabel@pengutronix.de>

commit 4b0755e90ae03ba40174842af6fa810355960fbc upstream.

The below mentioned fix contains a small but severe bug,
fix it to make the driver work again.

Fixes: 3538aa6ecfb2 ("[media] tc358743: fix register i2c_rd/wr functions")

Cc: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Signed-off-by: Philipp Zabel <p.zabel@pengutronix.de>
Acked-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Hans Verkuil <hansverk@cisco.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/i2c/tc358743.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/media/i2c/tc358743.c
+++ b/drivers/media/i2c/tc358743.c
@@ -241,7 +241,7 @@ static void i2c_wr16(struct v4l2_subdev
 
 static void i2c_wr16_and_or(struct v4l2_subdev *sd, u16 reg, u16 mask, u16 val)
 {
-	i2c_wrreg(sd, reg, (i2c_rdreg(sd, reg, 2) & mask) | val, 2);
+	i2c_wrreg(sd, reg, (i2c_rdreg(sd, reg, 1) & mask) | val, 1);
 }
 
 static u32 i2c_rd32(struct v4l2_subdev *sd, u16 reg)


