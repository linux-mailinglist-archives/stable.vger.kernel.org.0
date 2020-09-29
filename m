Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A09B27C345
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 13:06:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728578AbgI2LET (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 07:04:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:40292 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728574AbgI2LEP (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:04:15 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6244021924;
        Tue, 29 Sep 2020 11:04:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601377454;
        bh=DjjZnuXmxG8+DQetD0b8tSgVwIQADmWBtrQyC0jnWBU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eP7Ei3VCt5FzO6GyOHZscJNtIdTJ3GX8Vx1dEtRxn8XdfZZjEK1VZ+xDPiURycLtJ
         zwdNGoj9tCOImoGjzSWnXu5wPA3Bsa+kCi7IEKcCENS6MpVtWKAP4Msmr4cPIDwdok
         MnnzWN7SXmxMTk6s+FxrrlzyG7eXExMHij0ThsD8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Colin Ian King <colin.king@canonical.com>,
        Sean Young <sean@mess.org>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 42/85] media: tda10071: fix unsigned sign extension overflow
Date:   Tue, 29 Sep 2020 13:00:09 +0200
Message-Id: <20200929105930.336089662@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929105928.198942536@linuxfoundation.org>
References: <20200929105928.198942536@linuxfoundation.org>
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
index 119d47596ac81..b81887c4f72a9 100644
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



