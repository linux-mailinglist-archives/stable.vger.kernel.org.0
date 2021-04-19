Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37E7A3643D6
	for <lists+stable@lfdr.de>; Mon, 19 Apr 2021 15:32:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241241AbhDSNVx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Apr 2021 09:21:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:54752 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241435AbhDSNUe (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Apr 2021 09:20:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6CFCC613EA;
        Mon, 19 Apr 2021 13:16:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1618838207;
        bh=+aeO+f+Y2ffOCXajMAx0E9n74vMRNP/r8MCf0cTWVPg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=06WLA9V3z43B59C1EkPpbUlu3L3+kWij4yU7n2tBdJ1c6D4XvTL1xNnHk9L+gzyUn
         gIC+6Bcj1/cdhMacwUImgqETthXjsgE1qKF6IgtIDDE4WmhPnR+pBOz65xZK49+/ZR
         G8qnHElWxSJTZVc0xed+GYvgxXw5Xey6Gg/mx55k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Caleb Connolly <caleb@connolly.tech>,
        Andi Shyti <andi@etezian.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 5.10 047/103] Input: s6sy761 - fix coordinate read bit shift
Date:   Mon, 19 Apr 2021 15:05:58 +0200
Message-Id: <20210419130529.435420150@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210419130527.791982064@linuxfoundation.org>
References: <20210419130527.791982064@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Caleb Connolly <caleb@connolly.tech>

commit 30b3f68715595dee7fe4d9bd91a2252c3becdf0a upstream.

The touch coordinate register contains the following:

        byte 3             byte 2             byte 1
+--------+--------+ +-----------------+ +-----------------+
|        |        | |                 | |                 |
| X[3:0] | Y[3:0] | |     Y[11:4]     | |     X[11:4]     |
|        |        | |                 | |                 |
+--------+--------+ +-----------------+ +-----------------+

Bytes 2 and 1 need to be shifted left by 4 bits, the least significant
nibble of each is stored in byte 3. Currently they are only
being shifted by 3 causing the reported coordinates to be incorrect.

This matches downstream examples, and has been confirmed on my
device (OnePlus 7 Pro).

Fixes: 0145a7141e59 ("Input: add support for the Samsung S6SY761 touchscreen")
Signed-off-by: Caleb Connolly <caleb@connolly.tech>
Reviewed-by: Andi Shyti <andi@etezian.org>
Link: https://lore.kernel.org/r/20210305185710.225168-1-caleb@connolly.tech
Cc: stable@vger.kernel.org
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/touchscreen/s6sy761.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/input/touchscreen/s6sy761.c
+++ b/drivers/input/touchscreen/s6sy761.c
@@ -145,8 +145,8 @@ static void s6sy761_report_coordinates(s
 	u8 major = event[4];
 	u8 minor = event[5];
 	u8 z = event[6] & S6SY761_MASK_Z;
-	u16 x = (event[1] << 3) | ((event[3] & S6SY761_MASK_X) >> 4);
-	u16 y = (event[2] << 3) | (event[3] & S6SY761_MASK_Y);
+	u16 x = (event[1] << 4) | ((event[3] & S6SY761_MASK_X) >> 4);
+	u16 y = (event[2] << 4) | (event[3] & S6SY761_MASK_Y);
 
 	input_mt_slot(sdata->input, tid);
 


