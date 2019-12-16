Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0E6F21213AE
	for <lists+stable@lfdr.de>; Mon, 16 Dec 2019 19:04:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729580AbfLPSDw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 13:03:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:40884 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729172AbfLPSDv (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Dec 2019 13:03:51 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D4116207FF;
        Mon, 16 Dec 2019 18:03:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576519431;
        bh=klIdzkzvFKDWvvLxvjoRckTHmAjYSgP6WS1tO3GbRjI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=F9lzD2/VE5skrv5Rf5XcPY9l8Dq8lc0EmdstVAUZ292EKHE3TyugjVBHoY0z+hPnB
         jmCoc1TeEI5aD60lkaHV0HIdCO24UxY0zfOz8z7woLOas3mgyuDTFXsAs/8g5CXimk
         mPHqosOT3nbBAyrmprw9gwNcI5isHUW8U3dhyLmE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Matti Aaltonen <matti.j.aaltonen@nokia.com>,
        Johan Hovold <johan@kernel.org>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@kernel.org>
Subject: [PATCH 4.19 064/140] media: radio: wl1273: fix interrupt masking on release
Date:   Mon, 16 Dec 2019 18:48:52 +0100
Message-Id: <20191216174805.217646045@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191216174747.111154704@linuxfoundation.org>
References: <20191216174747.111154704@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johan Hovold <johan@kernel.org>

commit 1091eb830627625dcf79958d99353c2391f41708 upstream.

If a process is interrupted while accessing the radio device and the
core lock is contended, release() could return early and fail to update
the interrupt mask.

Note that the return value of the v4l2 release file operation is
ignored.

Fixes: 87d1a50ce451 ("[media] V4L2: WL1273 FM Radio: TI WL1273 FM radio driver")
Cc: stable <stable@vger.kernel.org>     # 2.6.38
Cc: Matti Aaltonen <matti.j.aaltonen@nokia.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/media/radio/radio-wl1273.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/media/radio/radio-wl1273.c
+++ b/drivers/media/radio/radio-wl1273.c
@@ -1156,8 +1156,7 @@ static int wl1273_fm_fops_release(struct
 	if (radio->rds_users > 0) {
 		radio->rds_users--;
 		if (radio->rds_users == 0) {
-			if (mutex_lock_interruptible(&core->lock))
-				return -EINTR;
+			mutex_lock(&core->lock);
 
 			radio->irq_flags &= ~WL1273_RDS_EVENT;
 


