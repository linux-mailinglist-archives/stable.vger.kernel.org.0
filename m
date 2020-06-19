Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0F0A200F39
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 17:17:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390337AbgFSPQr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 11:16:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:47364 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392495AbgFSPQp (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 11:16:45 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0AD322080C;
        Fri, 19 Jun 2020 15:16:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592579804;
        bh=vvdsUyh4/pxM07iiVjNfdaPg3hzQ8TBXAqWOytNYNZU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=J+jXRqHq6lgVdwaZb+7vaJ1+qQaUz5Jzc5iRfSl7p0qYjFIh7aaWtYFDmHFEl9TAB
         KgG9F6dzywb2356A9ZXFvAp5e9GkPV4/KDuAnBYkrA+09u9+XsiAmaHGoz6gN+xexc
         YJM9lXrVk/PAh6+UyGCcZF38wkDv5W9voC+EupU8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Brad Love <brad@nextdimension.cc>,
        Sean Young <sean@mess.org>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 011/376] media: si2157: Better check for running tuner in init
Date:   Fri, 19 Jun 2020 16:28:49 +0200
Message-Id: <20200619141710.897023785@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141710.350494719@linuxfoundation.org>
References: <20200619141710.350494719@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Brad Love <brad@nextdimension.cc>

[ Upstream commit e955f959ac52e145f27ff2be9078b646d0352af0 ]

Getting the Xtal trim property to check if running is less error prone.
Reset if_frequency if state is unknown.

Replaces the previous "garbage check".

Signed-off-by: Brad Love <brad@nextdimension.cc>
Signed-off-by: Sean Young <sean@mess.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/tuners/si2157.c | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/drivers/media/tuners/si2157.c b/drivers/media/tuners/si2157.c
index 898e0f9f8b70..20487b25fbe1 100644
--- a/drivers/media/tuners/si2157.c
+++ b/drivers/media/tuners/si2157.c
@@ -75,24 +75,23 @@ static int si2157_init(struct dvb_frontend *fe)
 	struct si2157_cmd cmd;
 	const struct firmware *fw;
 	const char *fw_name;
-	unsigned int uitmp, chip_id;
+	unsigned int chip_id, xtal_trim;
 
 	dev_dbg(&client->dev, "\n");
 
-	/* Returned IF frequency is garbage when firmware is not running */
-	memcpy(cmd.args, "\x15\x00\x06\x07", 4);
+	/* Try to get Xtal trim property, to verify tuner still running */
+	memcpy(cmd.args, "\x15\x00\x04\x02", 4);
 	cmd.wlen = 4;
 	cmd.rlen = 4;
 	ret = si2157_cmd_execute(client, &cmd);
-	if (ret)
-		goto err;
 
-	uitmp = cmd.args[2] << 0 | cmd.args[3] << 8;
-	dev_dbg(&client->dev, "if_frequency kHz=%u\n", uitmp);
+	xtal_trim = cmd.args[2] | (cmd.args[3] << 8);
 
-	if (uitmp == dev->if_frequency / 1000)
+	if (ret == 0 && xtal_trim < 16)
 		goto warm;
 
+	dev->if_frequency = 0; /* we no longer know current tuner state */
+
 	/* power up */
 	if (dev->chiptype == SI2157_CHIPTYPE_SI2146) {
 		memcpy(cmd.args, "\xc0\x05\x01\x00\x00\x0b\x00\x00\x01", 9);
-- 
2.25.1



