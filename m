Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3917B12EC01
	for <lists+stable@lfdr.de>; Thu,  2 Jan 2020 23:15:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727879AbgABWOU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jan 2020 17:14:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:54532 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727361AbgABWOT (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 Jan 2020 17:14:19 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 65B6D24125;
        Thu,  2 Jan 2020 22:14:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578003258;
        bh=YKzmLDGM+26DWt1qYfbrH6yMPu9ZkjIK/pFyMAkhQ98=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DHHbvCbkQVHGCJcbPanFkJ/R8UGqI7QGH+qCh/7rNahU+Z5D474zhA4JV346+wXxR
         vW9GH2p/efvyjQ+JWZFmF4On9Fh8Cc9E85XIavHRat5PBy7QQOWfaSVB3bHsuBQozO
         kX8/1b6ZqbPoIs88MhuvPRVTHaCFGuC4sEbPR34M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Sasha Levin <sashal@kernel.org>,
        Adam Ford <aford173@gmail.com>,
        Sven Van Asbroeck <TheSven73@gmail.com>
Subject: [PATCH 5.4 060/191] Input: ili210x - handle errors from input_mt_init_slots()
Date:   Thu,  2 Jan 2020 23:05:42 +0100
Message-Id: <20200102215836.397291369@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200102215829.911231638@linuxfoundation.org>
References: <20200102215829.911231638@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index e9006407c9bc..f4ebdab06280 100644
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



