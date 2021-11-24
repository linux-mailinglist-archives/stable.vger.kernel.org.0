Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E71E945BDBE
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 13:38:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345108AbhKXMkj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 07:40:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:39878 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344662AbhKXMid (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 07:38:33 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 673236120C;
        Wed, 24 Nov 2021 12:23:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637756596;
        bh=pBkYxER+EN8Hfyz1ekNpIL6qF5G0qTENbmrLuw+4EUM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EeXfT1xYPdlkvsoxxIsi7LYXHRAfV506nW3NhB3TSEhMJ6FeHkBynUvKVgQwKckTb
         D0TOBnd7pL1EoaA54COXWVSLUO1kCP82un0+F6VjEfSJHhkr64EkfG6MO1X8t6AxhB
         M1P84fcUJ5GmBTiBOtWUrf+igjH+smb6oPlbwFPM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Skripkin <paskripkin@gmail.com>,
        Sean Young <sean@mess.org>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        syzbot+2cd8c5db4a85f0a04142@syzkaller.appspotmail.com
Subject: [PATCH 4.14 107/251] media: dvb-usb: fix ununit-value in az6027_rc_query
Date:   Wed, 24 Nov 2021 12:55:49 +0100
Message-Id: <20211124115713.961947912@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115710.214900256@linuxfoundation.org>
References: <20211124115710.214900256@linuxfoundation.org>
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
index 2e711362847e4..382c8075ef524 100644
--- a/drivers/media/usb/dvb-usb/az6027.c
+++ b/drivers/media/usb/dvb-usb/az6027.c
@@ -394,6 +394,7 @@ static struct rc_map_table rc_map_az6027_table[] = {
 /* remote control stuff (does not work with my box) */
 static int az6027_rc_query(struct dvb_usb_device *d, u32 *event, int *state)
 {
+	*state = REMOTE_NO_KEY_PRESSED;
 	return 0;
 }
 
-- 
2.33.0



