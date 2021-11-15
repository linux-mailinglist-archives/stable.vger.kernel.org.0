Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44C0B4513B2
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 20:53:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348626AbhKOTyo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 14:54:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:44630 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343864AbhKOTWQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:22:16 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 00A9563395;
        Mon, 15 Nov 2021 18:47:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637002049;
        bh=OdPxKY2c7kAht3iiLXBnSutzuDh+aocw/PFPwt6d29o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VUt7gOpgqy0g3R8stpB9sQYTKVZXFrBmqKDcV0HEGifIcJMrpA5opByaNdNK6PwCz
         0EtiT1hx3H/xqZ/ry1i7iYbJhxZ+FLCgn0HOVCer7FyfCPuLaXVKh4tpbLYjrfSy+7
         0GjI/lLsJhJTijK5WgztI9QQCK0mHmYFsyLgpGLw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Pavel Skripkin <paskripkin@gmail.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        syzbot+a6969ef522a36d3344c9@syzkaller.appspotmail.com
Subject: [PATCH 5.15 377/917] media: em28xx: add missing em28xx_close_extension
Date:   Mon, 15 Nov 2021 17:57:52 +0100
Message-Id: <20211115165441.547470216@linuxfoundation.org>
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
index c1e0dccb74088..948e22e29b42a 100644
--- a/drivers/media/usb/em28xx/em28xx-cards.c
+++ b/drivers/media/usb/em28xx/em28xx-cards.c
@@ -4139,8 +4139,11 @@ static void em28xx_usb_disconnect(struct usb_interface *intf)
 
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



