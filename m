Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A7C845BFFA
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 14:01:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245742AbhKXNEA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 08:04:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:38602 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345894AbhKXNCO (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 08:02:14 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 89DD661179;
        Wed, 24 Nov 2021 12:35:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637757327;
        bh=tbKFZ9hmkTXpIXUhsnfpIvlXr/0eN8S+OJ2MV5wrPnY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k7N1wnUzfNTwxtKsLUnJNmH4/PMUyI64QKzvkJCoUWQnso4ZDQ2mQJHReNUB91pUK
         g0tfvBdo1B/bwuI/nneYJwKRlDI6ngGQFOFkw6uhhPBMTvQRo2jpYmK90VbOcbcDol
         Qer6fG095iGghiGQNlcliUhnYCTA7WSYdES/D51U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Skripkin <paskripkin@gmail.com>,
        Sean Young <sean@mess.org>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        syzbot+2cd8c5db4a85f0a04142@syzkaller.appspotmail.com
Subject: [PATCH 4.19 132/323] media: dvb-usb: fix ununit-value in az6027_rc_query
Date:   Wed, 24 Nov 2021 12:55:22 +0100
Message-Id: <20211124115723.390297168@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115718.822024889@linuxfoundation.org>
References: <20211124115718.822024889@linuxfoundation.org>
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
index 6321b8e302612..990719727dc37 100644
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



