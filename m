Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B560226851
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 18:19:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388191AbgGTQN6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 12:13:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:54096 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388183AbgGTQNy (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 12:13:54 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3ED2420734;
        Mon, 20 Jul 2020 16:13:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595261633;
        bh=w/m3pAhGy9x6FcDstO1uELlCaPwaoR19eOYw8AEp/QY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bZVZGkTQAesCG3GvDMchHkyL2SsG98RWLV1GD65doNMTrJTYE6V0mRtOZ9SdIBFqF
         bk+i7F8Aeskd3+avzIoyz2y15x7bfFkK/mvBKc5Ztd7LKjsVAfT7ZJe+jasu5kkwXG
         all8aFZoSY2V842DXUFnWD0p+6y7gPB0h1Dnsvt8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Harry Cutts <hcutts@chromium.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 5.7 187/244] Revert "Input: elants_i2c - report resolution information for touch major"
Date:   Mon, 20 Jul 2020 17:37:38 +0200
Message-Id: <20200720152834.737082423@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200720152825.863040590@linuxfoundation.org>
References: <20200720152825.863040590@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

commit 93b9de223c0135db495c25334e66cb669bef13e2 upstream.

This reverts commit 061706716384f1633d3d5090b22a99f33f1fcf2f - it turns
out that the resolution of 1 unit per mm was not correct for a number of
touch screens, causing touch sizes to be reported as way too large.
See https://crbug.com/1085648

Reported-by: Harry Cutts <hcutts@chromium.org>
Cc: stable@vger.kernel.org
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/input/touchscreen/elants_i2c.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/input/touchscreen/elants_i2c.c
+++ b/drivers/input/touchscreen/elants_i2c.c
@@ -1318,7 +1318,6 @@ static int elants_i2c_probe(struct i2c_c
 			     0, MT_TOOL_PALM, 0, 0);
 	input_abs_set_res(ts->input, ABS_MT_POSITION_X, ts->x_res);
 	input_abs_set_res(ts->input, ABS_MT_POSITION_Y, ts->y_res);
-	input_abs_set_res(ts->input, ABS_MT_TOUCH_MAJOR, 1);
 
 	error = input_register_device(ts->input);
 	if (error) {


