Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFC6345BFF9
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 14:01:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245589AbhKXND7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 08:03:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:38620 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345904AbhKXNCO (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 08:02:14 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3662961181;
        Wed, 24 Nov 2021 12:35:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637757323;
        bh=hGWVHhAgHzJunRZHDwTTP5dU3566NUjALwn/F2qqB0c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2bSR3B05q1BWSDtAtLtXF02DCegT0aPLKZwwbri4i2+txnhTDGJYJrMdVBIDsFsR2
         DkqhF85psS+j6bEoFDXR729PX4BarZWEzAbP5vtmJYtBbpyKj118f3EexsA8PrQusr
         d1ojR02XFENIO9NDSIzbsAWC89hDf/HHd2J1LfS4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Skripkin <paskripkin@gmail.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        syzbot+a6969ef522a36d3344c9@syzkaller.appspotmail.com
Subject: [PATCH 4.19 131/323] media: em28xx: add missing em28xx_close_extension
Date:   Wed, 24 Nov 2021 12:55:21 +0100
Message-Id: <20211124115723.359815643@linuxfoundation.org>
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

[ Upstream commit 2c98b8a3458df03abdc6945bbef67ef91d181938 ]

If em28xx dev has ->dev_next pointer, we need to delete ->dev_next list
node from em28xx_extension_devlist on disconnect to avoid UAF bugs and
corrupted list bugs, since driver frees this pointer on disconnect.

Reported-and-tested-by: syzbot+a6969ef522a36d3344c9@syzkaller.appspotmail.com

Fixes: 1a23f81b7dc3 ("V4L/DVB (9979): em28xx: move usb probe code to a proper place")
Signed-off-by: Pavel Skripkin <paskripkin@gmail.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/usb/em28xx/em28xx-cards.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/media/usb/em28xx/em28xx-cards.c b/drivers/media/usb/em28xx/em28xx-cards.c
index 3f59a98dbf9a1..ec608f60d2c75 100644
--- a/drivers/media/usb/em28xx/em28xx-cards.c
+++ b/drivers/media/usb/em28xx/em28xx-cards.c
@@ -4030,8 +4030,11 @@ static void em28xx_usb_disconnect(struct usb_interface *intf)
 
 	em28xx_close_extension(dev);
 
-	if (dev->dev_next)
+	if (dev->dev_next) {
+		em28xx_close_extension(dev->dev_next);
 		em28xx_release_resources(dev->dev_next);
+	}
+
 	em28xx_release_resources(dev);
 
 	if (dev->dev_next) {
-- 
2.33.0



