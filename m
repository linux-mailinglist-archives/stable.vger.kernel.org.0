Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 62C5B191112
	for <lists+stable@lfdr.de>; Tue, 24 Mar 2020 14:39:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728207AbgCXNPH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Mar 2020 09:15:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:33864 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727717AbgCXNPH (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Mar 2020 09:15:07 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 213E7208D5;
        Tue, 24 Mar 2020 13:15:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585055706;
        bh=HrAzwTQxkW5nFCS4hF9w7WLyIphCQYAPQfRP45tJzBs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hs4H1QMfY+/ObUYvM161kR10jUeeIF3hyFNzfpsXFFhF/IQrSNJUZryFvndDjcysv
         svH12LyG1yZnbb7DrRV58eTyGwW6OnUCOPX0zyr9FYva/TQzZsXQVbi9c9a2ANwZkB
         gAwJZ8T/j08VVqHVxhqAznDhOgmVOKGJv/lfSAtk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Anthony Mallet <anthony.mallet@laas.fr>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 52/65] USB: cdc-acm: fix close_delay and closing_wait units in TIOCSSERIAL
Date:   Tue, 24 Mar 2020 14:11:13 +0100
Message-Id: <20200324130803.459320435@linuxfoundation.org>
X-Mailer: git-send-email 2.25.2
In-Reply-To: <20200324130756.679112147@linuxfoundation.org>
References: <20200324130756.679112147@linuxfoundation.org>
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
index 59675cc7aa017..709884b99b3e3 100644
--- a/drivers/usb/class/cdc-acm.c
+++ b/drivers/usb/class/cdc-acm.c
@@ -914,10 +914,10 @@ static int get_serial_info(struct acm *acm, struct serial_struct __user *info)
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
@@ -935,9 +935,10 @@ static int set_serial_info(struct acm *acm,
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



