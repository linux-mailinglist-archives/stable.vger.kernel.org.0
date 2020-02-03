Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A42FD150C40
	for <lists+stable@lfdr.de>; Mon,  3 Feb 2020 17:36:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730817AbgBCQeg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Feb 2020 11:34:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:48996 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730815AbgBCQef (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Feb 2020 11:34:35 -0500
Received: from localhost (unknown [104.132.45.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 60E5321775;
        Mon,  3 Feb 2020 16:34:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580747674;
        bh=6DmBolbtfr5xFdGIY7cFqc5o5dNUZ0YZKeKqRMpNUGo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=y+udwoXChaAsIe6jt/Q/klG+/5shPp3zbj1P3SQazZIKppdUXMWXzBGTi4PU8awYR
         Mss5qtAuk7eSdb65l0GIUs2T7kRnRMxfpZDLYN9yDiho97uyLxLVsvxkPuB0Sg2YUp
         UvODcTfMzBRFWVXCAaJzh6z0LwwDxVWkIJiP/9fA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+6bf9606ee955b646c0e1@syzkaller.appspotmail.com,
        Sean Young <sean@mess.org>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: [PATCH 5.4 15/90] media: digitv: dont continue if remote control state cant be read
Date:   Mon,  3 Feb 2020 16:19:18 +0000
Message-Id: <20200203161919.685182477@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200203161917.612554987@linuxfoundation.org>
References: <20200203161917.612554987@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Young <sean@mess.org>

commit eecc70d22ae51225de1ef629c1159f7116476b2e upstream.

This results in an uninitialized variable read.

Reported-by: syzbot+6bf9606ee955b646c0e1@syzkaller.appspotmail.com
Signed-off-by: Sean Young <sean@mess.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/media/usb/dvb-usb/digitv.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

--- a/drivers/media/usb/dvb-usb/digitv.c
+++ b/drivers/media/usb/dvb-usb/digitv.c
@@ -230,18 +230,22 @@ static struct rc_map_table rc_map_digitv
 
 static int digitv_rc_query(struct dvb_usb_device *d, u32 *event, int *state)
 {
-	int i;
+	int ret, i;
 	u8 key[5];
 	u8 b[4] = { 0 };
 
 	*event = 0;
 	*state = REMOTE_NO_KEY_PRESSED;
 
-	digitv_ctrl_msg(d,USB_READ_REMOTE,0,NULL,0,&key[1],4);
+	ret = digitv_ctrl_msg(d, USB_READ_REMOTE, 0, NULL, 0, &key[1], 4);
+	if (ret)
+		return ret;
 
 	/* Tell the device we've read the remote. Not sure how necessary
 	   this is, but the Nebula SDK does it. */
-	digitv_ctrl_msg(d,USB_WRITE_REMOTE,0,b,4,NULL,0);
+	ret = digitv_ctrl_msg(d, USB_WRITE_REMOTE, 0, b, 4, NULL, 0);
+	if (ret)
+		return ret;
 
 	/* if something is inside the buffer, simulate key press */
 	if (key[1] != 0)


