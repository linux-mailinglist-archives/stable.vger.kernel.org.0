Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D610451FD3
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 01:42:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351810AbhKPApc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 19:45:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:44648 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343857AbhKOTWQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:22:16 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 10227635F8;
        Mon, 15 Nov 2021 18:47:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637002033;
        bh=3KEeUKsD20rnqkOoxMDDnkcbzJPrL7qYaG1to0p+6+c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Wl6+vd482+YNOsuYt/Dm9Yvo/7BMDwGumHfncP50bZQQ7Tlb80vY7uSfWGBrZT5tE
         uJ5igvLzD/vcp7zVPZCZAu8XYQG+NoRnWAV0TaiCzafRsXDTCbwjnLh1ua3Dwduc01
         c2BuORGxolFxhxORgV+FipgA1C21KhOZpQhmMl+U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Skripkin <paskripkin@gmail.com>,
        Sean Young <sean@mess.org>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        syzbot+2cd8c5db4a85f0a04142@syzkaller.appspotmail.com
Subject: [PATCH 5.15 381/917] media: dvb-usb: fix ununit-value in az6027_rc_query
Date:   Mon, 15 Nov 2021 17:57:56 +0100
Message-Id: <20211115165441.681354159@linuxfoundation.org>
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

From: Pavel Skripkin <paskripkin@gmail.com>

[ Upstream commit afae4ef7d5ad913cab1316137854a36bea6268a5 ]

Syzbot reported ununit-value bug in az6027_rc_query(). The problem was
in missing state pointer initialization. Since this function does nothing
we can simply initialize state to REMOTE_NO_KEY_PRESSED.

Reported-and-tested-by: syzbot+2cd8c5db4a85f0a04142@syzkaller.appspotmail.com

Fixes: 76f9a820c867 ("V4L/DVB: AZ6027: Initial import of the driver")
Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
Signed-off-by: Sean Young <sean@mess.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/usb/dvb-usb/az6027.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/usb/dvb-usb/az6027.c b/drivers/media/usb/dvb-usb/az6027.c
index 1c39b61cde29b..86788771175b7 100644
--- a/drivers/media/usb/dvb-usb/az6027.c
+++ b/drivers/media/usb/dvb-usb/az6027.c
@@ -391,6 +391,7 @@ static struct rc_map_table rc_map_az6027_table[] = {
 /* remote control stuff (does not work with my box) */
 static int az6027_rc_query(struct dvb_usb_device *d, u32 *event, int *state)
 {
+	*state = REMOTE_NO_KEY_PRESSED;
 	return 0;
 }
 
-- 
2.33.0



