Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 691E1411B3C
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 18:55:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242671AbhITQ4q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 12:56:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:45192 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343489AbhITQyn (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 12:54:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4F63B611C2;
        Mon, 20 Sep 2021 16:50:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632156647;
        bh=vYEt8ykzRp17MLWOLTt108IoCn/jjKrMzXqSIG1pOcM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BhCONwkx9VztCVSlO4+tcfEjForPl8UHr2EXCcURVJ2fQ0W6fVDt++Tm0ZKB+HtuE
         HgdQMJwjtGpeUMEc4sz8bZfYS6yH5QXW/toIZVr340Ff3LS5KcDGI7PhGRALN9tosx
         DkUv3gWXBUuQk9s1GFQ5Os6IS7ReG1XdoOfJUKHY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <mchehab@s-opensource.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Arnd Bergmann <arnd@arndb.de>,
        Hans Verkuil <hansverk@cisco.com>
Subject: [PATCH 4.9 021/175] [media] tc358743: fix register i2c_rd/wr function fix
Date:   Mon, 20 Sep 2021 18:41:10 +0200
Message-Id: <20210920163918.768211620@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163918.068823680@linuxfoundation.org>
References: <20210920163918.068823680@linuxfoundation.org>
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
@@ -237,7 +237,7 @@ static void i2c_wr16(struct v4l2_subdev
 
 static void i2c_wr16_and_or(struct v4l2_subdev *sd, u16 reg, u16 mask, u16 val)
 {
-	i2c_wrreg(sd, reg, (i2c_rdreg(sd, reg, 2) & mask) | val, 2);
+	i2c_wrreg(sd, reg, (i2c_rdreg(sd, reg, 1) & mask) | val, 1);
 }
 
 static u32 i2c_rd32(struct v4l2_subdev *sd, u16 reg)


