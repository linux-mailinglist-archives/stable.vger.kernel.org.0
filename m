Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DC6D27CB9F
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 14:29:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729795AbgI2M3I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 08:29:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:46444 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729459AbgI2LcG (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:32:06 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 31DFE23B1A;
        Tue, 29 Sep 2020 11:25:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601378717;
        bh=pGhwVmzAKmrsyihS5XbA3TPrkvfmkoyMXMpaORXB8ZI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=edGX1AG1IYHyZZwyT6yZDTWzbGchg9vYyU9CtyuoMKxkhtq/ZsCjwXvbfqtIuezPA
         AvMsDEh3gEHdL/2rd5xgkvnvP9UKK1QRBAOgBPBZ6m/FETG3xRwYuMkWVLxYTQ0MuZ
         MjXrS2lTuSlxKbPOjIxaOEyf9+Jm7d5b/V6XD9zc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Colin Ian King <colin.king@canonical.com>,
        Sean Young <sean@mess.org>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 106/245] media: tda10071: fix unsigned sign extension overflow
Date:   Tue, 29 Sep 2020 12:59:17 +0200
Message-Id: <20200929105952.160933968@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929105946.978650816@linuxfoundation.org>
References: <20200929105946.978650816@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

[ Upstream commit a7463e2dc698075132de9905b89f495df888bb79 ]

The shifting of buf[3] by 24 bits to the left will be promoted to
a 32 bit signed int and then sign-extended to an unsigned long. In
the unlikely event that the the top bit of buf[3] is set then all
then all the upper bits end up as also being set because of
the sign-extension and this affect the ev->post_bit_error sum.
Fix this by using the temporary u32 variable bit_error to avoid
the sign-extension promotion. This also removes the need to do the
computation twice.

Addresses-Coverity: ("Unintended sign extension")

Fixes: 267897a4708f ("[media] tda10071: implement DVBv5 statistics")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
Signed-off-by: Sean Young <sean@mess.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/dvb-frontends/tda10071.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/media/dvb-frontends/tda10071.c b/drivers/media/dvb-frontends/tda10071.c
index 097c42d3f8c26..df0c7243eafe4 100644
--- a/drivers/media/dvb-frontends/tda10071.c
+++ b/drivers/media/dvb-frontends/tda10071.c
@@ -483,10 +483,11 @@ static int tda10071_read_status(struct dvb_frontend *fe, enum fe_status *status)
 			goto error;
 
 		if (dev->delivery_system == SYS_DVBS) {
-			dev->dvbv3_ber = buf[0] << 24 | buf[1] << 16 |
-					 buf[2] << 8 | buf[3] << 0;
-			dev->post_bit_error += buf[0] << 24 | buf[1] << 16 |
-					       buf[2] << 8 | buf[3] << 0;
+			u32 bit_error = buf[0] << 24 | buf[1] << 16 |
+					buf[2] << 8 | buf[3] << 0;
+
+			dev->dvbv3_ber = bit_error;
+			dev->post_bit_error += bit_error;
 			c->post_bit_error.stat[0].scale = FE_SCALE_COUNTER;
 			c->post_bit_error.stat[0].uvalue = dev->post_bit_error;
 			dev->block_error += buf[4] << 8 | buf[5] << 0;
-- 
2.25.1



