Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C77E3C3121
	for <lists+stable@lfdr.de>; Sat, 10 Jul 2021 04:48:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235005AbhGJCkM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Jul 2021 22:40:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:58368 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235893AbhGJCju (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Jul 2021 22:39:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2E1176144C;
        Sat, 10 Jul 2021 02:36:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625884579;
        bh=kUuZPfMVGV4XhquWVVjB2MEku53VjT/5FansboFNLog=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rSKFVaA9mEPi9i63WP/KNKg7vZks70zkGrUO5pDpaUuUUmELU8lDEpbJG3KiPleGz
         WxX4eYea12WecHgrplj8GlZm6aadKfkPdHh6qC6yPULn6uynd8UvKYq346KhW3rhQi
         Gy/l1+7CCwqAAIqNjmEgThIMUlFM44ZJNAHQ2dkTa7G2ufPnGJ1i9kx8Kz24J7FAWU
         K+mbb2azp+yBsOnXRzPBl2GgAXZVYH78YZ4ZbaItcLILndrw2CQ8liask9PgCWjtmf
         DQAZ1fx9HS8DQewMweEjj5sYuIPdCLDD42aag9P6+YFYH8mqObTsNn2uMyGcWm3OlP
         VFh8cb3IErgzQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alan Stern <stern@rowland.harvard.edu>,
        Johan Hovold <johan@kernel.org>,
        syzbot+7dbcd9ff34dc4ed45240@syzkaller.appspotmail.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 4.9 11/26] USB: core: Avoid WARNings for 0-length descriptor requests
Date:   Fri,  9 Jul 2021 22:35:49 -0400
Message-Id: <20210710023604.3172486-11-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210710023604.3172486-1-sashal@kernel.org>
References: <20210710023604.3172486-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alan Stern <stern@rowland.harvard.edu>

[ Upstream commit 60dfe484cef45293e631b3a6e8995f1689818172 ]

The USB core has utility routines to retrieve various types of
descriptors.  These routines will now provoke a WARN if they are asked
to retrieve 0 bytes (USB "receive" requests must not have zero
length), so avert this by checking the size argument at the start.

CC: Johan Hovold <johan@kernel.org>
Reported-and-tested-by: syzbot+7dbcd9ff34dc4ed45240@syzkaller.appspotmail.com
Reviewed-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Link: https://lore.kernel.org/r/20210607152307.GD1768031@rowland.harvard.edu
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/core/message.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/usb/core/message.c b/drivers/usb/core/message.c
index 7c4937013429..39e528b0b59d 100644
--- a/drivers/usb/core/message.c
+++ b/drivers/usb/core/message.c
@@ -644,6 +644,9 @@ int usb_get_descriptor(struct usb_device *dev, unsigned char type,
 	int i;
 	int result;
 
+	if (size <= 0)		/* No point in asking for no data */
+		return -EINVAL;
+
 	memset(buf, 0, size);	/* Make sure we parse really received data */
 
 	for (i = 0; i < 3; ++i) {
@@ -692,6 +695,9 @@ static int usb_get_string(struct usb_device *dev, unsigned short langid,
 	int i;
 	int result;
 
+	if (size <= 0)		/* No point in asking for no data */
+		return -EINVAL;
+
 	for (i = 0; i < 3; ++i) {
 		/* retry on length 0 or stall; some devices are flakey */
 		result = usb_control_msg(dev, usb_rcvctrlpipe(dev, 0),
-- 
2.30.2

