Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA18719B272
	for <lists+stable@lfdr.de>; Wed,  1 Apr 2020 18:44:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389521AbgDAQoC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Apr 2020 12:44:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:44966 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389512AbgDAQoB (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Apr 2020 12:44:01 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8386E2063A;
        Wed,  1 Apr 2020 16:44:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585759441;
        bh=SKezd3hTCZDSA3HVF8gUR5nBnyW55dO8DbZHa6vRcio=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HUB0QYJ7245fJdcdInYNzFGP8a91Ahn0QuGtj6x+NseYIcW0AkKOx2Ke/lCPifVJn
         cBBtkeuMndRkz4sgT42x5NNjxCDddVOF11wQxq0Wj0jpbX4J5xkY1U/jgNbGv5o+uV
         RWYoKpzD8qKFprheTFIt1/0zAL5eUD+i7+toN854=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Anthony Mallet <anthony.mallet@laas.fr>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 040/148] USB: cdc-acm: fix close_delay and closing_wait units in TIOCSSERIAL
Date:   Wed,  1 Apr 2020 18:17:12 +0200
Message-Id: <20200401161556.647725359@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200401161552.245876366@linuxfoundation.org>
References: <20200401161552.245876366@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Anthony Mallet <anthony.mallet@laas.fr>

[ Upstream commit 633e2b2ded739a34bd0fb1d8b5b871f7e489ea29 ]

close_delay and closing_wait are specified in hundredth of a second but stored
internally in jiffies. Use the jiffies_to_msecs() and msecs_to_jiffies()
functions to convert from each other.

Signed-off-by: Anthony Mallet <anthony.mallet@laas.fr>
Cc: stable <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20200312133101.7096-1-anthony.mallet@laas.fr
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/class/cdc-acm.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/usb/class/cdc-acm.c b/drivers/usb/class/cdc-acm.c
index 0453f0eb11781..74d0a91e84273 100644
--- a/drivers/usb/class/cdc-acm.c
+++ b/drivers/usb/class/cdc-acm.c
@@ -926,10 +926,10 @@ static int get_serial_info(struct acm *acm, struct serial_struct __user *info)
 	memset(&tmp, 0, sizeof(tmp));
 	tmp.xmit_fifo_size = acm->writesize;
 	tmp.baud_base = le32_to_cpu(acm->line.dwDTERate);
-	tmp.close_delay	= acm->port.close_delay / 10;
+	tmp.close_delay	= jiffies_to_msecs(acm->port.close_delay) / 10;
 	tmp.closing_wait = acm->port.closing_wait == ASYNC_CLOSING_WAIT_NONE ?
 				ASYNC_CLOSING_WAIT_NONE :
-				acm->port.closing_wait / 10;
+				jiffies_to_msecs(acm->port.closing_wait) / 10;
 
 	if (copy_to_user(info, &tmp, sizeof(tmp)))
 		return -EFAULT;
@@ -947,9 +947,10 @@ static int set_serial_info(struct acm *acm,
 	if (copy_from_user(&new_serial, newinfo, sizeof(new_serial)))
 		return -EFAULT;
 
-	close_delay = new_serial.close_delay * 10;
+	close_delay = msecs_to_jiffies(new_serial.close_delay * 10);
 	closing_wait = new_serial.closing_wait == ASYNC_CLOSING_WAIT_NONE ?
-			ASYNC_CLOSING_WAIT_NONE : new_serial.closing_wait * 10;
+			ASYNC_CLOSING_WAIT_NONE :
+			msecs_to_jiffies(new_serial.closing_wait * 10);
 
 	mutex_lock(&acm->port.mutex);
 
-- 
2.20.1



