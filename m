Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EB61011B6F4
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 17:05:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731270AbfLKPM5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 10:12:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:35480 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731264AbfLKPM4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 10:12:56 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E194024654;
        Wed, 11 Dec 2019 15:12:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576077175;
        bh=cbppnptq3t0tXRFcWniMsJU+1fvxOW+4v1a/QucKyME=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UWgtNBsPa7qHbFsmFnwvLfjTwHhsy8kDNdwEcYQd772fU4Wg+Gg964bdBytoFVegy
         teavN/nOy8TSQrSVTxKCddKu8WVggymFBFc0yoX/iHzuGVW6WMr8q3IqN7PAyheXmD
         ywo6F7FCMb8qrcCQryrRElpCRozKf+FZnPJ3QmC8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Adam Ford <aford173@gmail.com>,
        Sven Van Asbroeck <TheSven73@gmail.com>,
        Sasha Levin <sashal@kernel.org>, linux-input@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 060/134] Input: ili210x - handle errors from input_mt_init_slots()
Date:   Wed, 11 Dec 2019 10:10:36 -0500
Message-Id: <20191211151150.19073-60-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191211151150.19073-1-sashal@kernel.org>
References: <20191211151150.19073-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

[ Upstream commit 43f06a4c639de8ee89fc348a9a3ecd70320a04dd ]

input_mt_init_slots() may fail and we need to handle such failures.

Tested-by: Adam Ford <aford173@gmail.com> #imx6q-logicpd
Tested-by: Sven Van Asbroeck <TheSven73@gmail.com> # ILI2118A variant
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/input/touchscreen/ili210x.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/input/touchscreen/ili210x.c b/drivers/input/touchscreen/ili210x.c
index e9006407c9bc0..f4ebdab062806 100644
--- a/drivers/input/touchscreen/ili210x.c
+++ b/drivers/input/touchscreen/ili210x.c
@@ -334,7 +334,12 @@ static int ili210x_i2c_probe(struct i2c_client *client,
 	input_set_abs_params(input, ABS_MT_POSITION_X, 0, 0xffff, 0, 0);
 	input_set_abs_params(input, ABS_MT_POSITION_Y, 0, 0xffff, 0, 0);
 	touchscreen_parse_properties(input, true, &priv->prop);
-	input_mt_init_slots(input, priv->max_touches, INPUT_MT_DIRECT);
+
+	error = input_mt_init_slots(input, priv->max_touches, INPUT_MT_DIRECT);
+	if (error) {
+		dev_err(dev, "Unable to set up slots, err: %d\n", error);
+		return error;
+	}
 
 	error = devm_add_action(dev, ili210x_cancel_work, priv);
 	if (error)
-- 
2.20.1

