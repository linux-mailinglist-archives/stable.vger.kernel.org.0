Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D73E49154C
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 03:27:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244581AbiARC1O (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 21:27:14 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:41576 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244545AbiARCY4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 21:24:56 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BC70E60AAF;
        Tue, 18 Jan 2022 02:24:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6585CC36AEB;
        Tue, 18 Jan 2022 02:24:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642472695;
        bh=aXgAlWjFhuTYaGo0IQrs5NxFaBkHUtQAgDjh1OBwC9o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KQxVg9bd00pHTluwK/WTOgoeXgHTSYxRoti4kkVFvmKHZI2H8bacqo5TlDrnxP6sp
         26DZNfDYGRAAfhCOItrEp20Mr2m7EGxGebsUnQwCDwsLoFq4lNR3TIcy+j6n0pQeR5
         SgrWArqnpfjOz+iEEIrre/SuumhdAD7IKLbvicqbX0kiQgxHlD+7DegE70RGSL8512
         c+WKOAT1cC4/TlYqsknFxuYnN87lTPiezNjeeuDnvAE6Qo1kn1uhbjg3i6NlYXsu2I
         HDajKN9YpUe4Sok6PzbvmWIQiuFsZoAr/WEhG5yObQ6t0gPrFn7Q1q2G2wqfmv23qB
         LNrbZPMUPpA4Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        rkardell@mida.se, Sasha Levin <sashal@kernel.org>,
        mchehab@kernel.org, linux-media@vger.kernel.org
Subject: [PATCH AUTOSEL 5.16 101/217] media: m920x: don't use stack on USB reads
Date:   Mon, 17 Jan 2022 21:17:44 -0500
Message-Id: <20220118021940.1942199-101-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118021940.1942199-1-sashal@kernel.org>
References: <20220118021940.1942199-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>

[ Upstream commit a2ab06d7c4d6bfd0b545a768247a70463e977e27 ]

Using stack-allocated pointers for USB message data don't work.
This driver is almost OK with that, except for the I2C read
logic.

Fix it by using a temporary read buffer, just like on all other
calls to m920x_read().

Link: https://lore.kernel.org/all/ccc99e48-de4f-045e-0fe4-61e3118e3f74@mida.se/
Reported-by: rkardell@mida.se
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/usb/dvb-usb/m920x.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/media/usb/dvb-usb/m920x.c b/drivers/media/usb/dvb-usb/m920x.c
index 4bb5b82599a79..691e05833db19 100644
--- a/drivers/media/usb/dvb-usb/m920x.c
+++ b/drivers/media/usb/dvb-usb/m920x.c
@@ -274,6 +274,13 @@ static int m920x_i2c_xfer(struct i2c_adapter *adap, struct i2c_msg msg[], int nu
 			/* Should check for ack here, if we knew how. */
 		}
 		if (msg[i].flags & I2C_M_RD) {
+			char *read = kmalloc(1, GFP_KERNEL);
+			if (!read) {
+				ret = -ENOMEM;
+				kfree(read);
+				goto unlock;
+			}
+
 			for (j = 0; j < msg[i].len; j++) {
 				/* Last byte of transaction?
 				 * Send STOP, otherwise send ACK. */
@@ -281,9 +288,12 @@ static int m920x_i2c_xfer(struct i2c_adapter *adap, struct i2c_msg msg[], int nu
 
 				if ((ret = m920x_read(d->udev, M9206_I2C, 0x0,
 						      0x20 | stop,
-						      &msg[i].buf[j], 1)) != 0)
+						      read, 1)) != 0)
 					goto unlock;
+				msg[i].buf[j] = read[0];
 			}
+
+			kfree(read);
 		} else {
 			for (j = 0; j < msg[i].len; j++) {
 				/* Last byte of transaction? Then send STOP. */
-- 
2.34.1

