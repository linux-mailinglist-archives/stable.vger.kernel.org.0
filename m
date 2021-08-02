Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F38F3DD937
	for <lists+stable@lfdr.de>; Mon,  2 Aug 2021 15:58:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233958AbhHBN6Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Aug 2021 09:58:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:43164 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236303AbhHBN4X (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 2 Aug 2021 09:56:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C79A86113E;
        Mon,  2 Aug 2021 13:54:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627912472;
        bh=9tJuRX9Qp1ToO185blhtRO+oQzh78cM80OJNjrYgTQo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qXrF03DafKHtzCS7lx+qQW1Iu7SG87/lrnyrSLT64m8wVzEJx5uOp2iE4uIykGrDZ
         XBETPmIIFV2I4A/6ZDQgTUZQHFGh+iq3G5gYm6oWSeKXu+v9JgdjGmmvV/4/+ARsFI
         /jF4C+DkS5nvT8a9C8t/u8c+ttZTeA1TLtU5Ig0E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Carpenter <dan.carpenter@oracle.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 57/67] can: hi311x: fix a signedness bug in hi3110_cmd()
Date:   Mon,  2 Aug 2021 15:45:20 +0200
Message-Id: <20210802134340.996410352@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210802134339.023067817@linuxfoundation.org>
References: <20210802134339.023067817@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit f6b3c7848e66e9046c8a79a5b88fd03461cc252b ]

The hi3110_cmd() is supposed to return zero on success and negative
error codes on failure, but it was accidentally declared as a u8 when
it needs to be an int type.

Fixes: 57e83fb9b746 ("can: hi311x: Add Holt HI-311x CAN driver")
Link: https://lore.kernel.org/r/20210729141246.GA1267@kili
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/can/spi/hi311x.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/can/spi/hi311x.c b/drivers/net/can/spi/hi311x.c
index 73d48c3b8ded..7d2315c8cacb 100644
--- a/drivers/net/can/spi/hi311x.c
+++ b/drivers/net/can/spi/hi311x.c
@@ -218,7 +218,7 @@ static int hi3110_spi_trans(struct spi_device *spi, int len)
 	return ret;
 }
 
-static u8 hi3110_cmd(struct spi_device *spi, u8 command)
+static int hi3110_cmd(struct spi_device *spi, u8 command)
 {
 	struct hi3110_priv *priv = spi_get_drvdata(spi);
 
-- 
2.30.2



