Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65EBA451FD9
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 01:42:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352423AbhKPApi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 19:45:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:44614 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343829AbhKOTWJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:22:09 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4D774635E8;
        Mon, 15 Nov 2021 18:46:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637002017;
        bh=1tHYTRTbKddxjQ+pjPqTvktsf/SwFTKOcCkXUaImFUQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=c+hGcG4yUXXqdv10Uic1QNzSDHl1ZltRgYc4AyG1GwjhH17gYFOLnkfqbzYTZ+5rj
         5q7M4MSHm79Z5aN8iYhOceLRhnJnYYu7tcptefKHLU8SIaCsBNXE6KkJP/eyXcqT7/
         j2URwUDGp8xdcIuXqPuXe0xRUXhlCtiLg530kDTc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Evgeny Novikov <novikov@ispras.ru>,
        Sean Young <sean@mess.org>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 380/917] media: ttusb-dec: avoid release of non-acquired mutex
Date:   Mon, 15 Nov 2021 17:57:55 +0100
Message-Id: <20211115165441.648934103@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Evgeny Novikov <novikov@ispras.ru>

[ Upstream commit 36b9d695aa6fb8e9a312db21af41f90824d16ab4 ]

ttusb_dec_send_command() invokes mutex_lock_interruptible() that can
fail but then it releases the non-acquired mutex. The patch fixes that.

Found by Linux Driver Verification project (linuxtesting.org).

Fixes: dba328bab4c6 ("media: ttusb-dec: cleanup an error handling logic")
Signed-off-by: Evgeny Novikov <novikov@ispras.ru>
Signed-off-by: Sean Young <sean@mess.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/usb/ttusb-dec/ttusb_dec.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/media/usb/ttusb-dec/ttusb_dec.c b/drivers/media/usb/ttusb-dec/ttusb_dec.c
index bfda46a36dc50..38822cedd93a9 100644
--- a/drivers/media/usb/ttusb-dec/ttusb_dec.c
+++ b/drivers/media/usb/ttusb-dec/ttusb_dec.c
@@ -327,7 +327,7 @@ static int ttusb_dec_send_command(struct ttusb_dec *dec, const u8 command,
 	result = mutex_lock_interruptible(&dec->usb_mutex);
 	if (result) {
 		printk("%s: Failed to lock usb mutex.\n", __func__);
-		goto err;
+		goto err_free;
 	}
 
 	b[0] = 0xaa;
@@ -349,7 +349,7 @@ static int ttusb_dec_send_command(struct ttusb_dec *dec, const u8 command,
 	if (result) {
 		printk("%s: command bulk message failed: error %d\n",
 		       __func__, result);
-		goto err;
+		goto err_mutex_unlock;
 	}
 
 	result = usb_bulk_msg(dec->udev, dec->result_pipe, b,
@@ -358,7 +358,7 @@ static int ttusb_dec_send_command(struct ttusb_dec *dec, const u8 command,
 	if (result) {
 		printk("%s: result bulk message failed: error %d\n",
 		       __func__, result);
-		goto err;
+		goto err_mutex_unlock;
 	} else {
 		if (debug) {
 			printk(KERN_DEBUG "%s: result: %*ph\n",
@@ -371,9 +371,9 @@ static int ttusb_dec_send_command(struct ttusb_dec *dec, const u8 command,
 			memcpy(cmd_result, &b[4], b[3]);
 	}
 
-err:
+err_mutex_unlock:
 	mutex_unlock(&dec->usb_mutex);
-
+err_free:
 	kfree(b);
 	return result;
 }
-- 
2.33.0



