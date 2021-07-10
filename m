Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1EFFF3C2E3B
	for <lists+stable@lfdr.de>; Sat, 10 Jul 2021 04:26:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233398AbhGJC0i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Jul 2021 22:26:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:42616 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233403AbhGJCZ4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Jul 2021 22:25:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 209DA613E8;
        Sat, 10 Jul 2021 02:23:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625883792;
        bh=TOcl3h8y0zUeqb5SQcKCPtz9ZLYgerjxGs4W3oevh8A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SA11PgHYn/4gsLZQfChljmbDBgRn0WWKyyTYvONZdYAjdiEKJAxZ/vXWpc64E9qmH
         V6GULPOLSTYmudE1Ffr6triSw+zlVFHqQ+Fmp9N8u20hNOlw/E16MiJu8mIIgBKxS+
         +dJ5gb9KneLCQGwXEcPa/rrgLjNhPjn4+fFywRR0zu/93ksHAX8nszKtAgW9/bRVO8
         KFq23ZpcAHfVYWRojqggg+tA8rlP1Z+Whq3rpWur3dJRps6QXS8r/6PEAyCtUqrimp
         xDHTiMJBCbOEAVbnWewGNjPts0YcRfUTLaH75EOrl2mzo3U/YebmosThJMNL/qriLZ
         Oq0u8OHKrVZ/w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alan Stern <stern@rowland.harvard.edu>,
        Johan Hovold <johan@kernel.org>,
        syzbot+7dbcd9ff34dc4ed45240@syzkaller.appspotmail.com,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 5.12 057/104] USB: core: Avoid WARNings for 0-length descriptor requests
Date:   Fri,  9 Jul 2021 22:21:09 -0400
Message-Id: <20210710022156.3168825-57-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210710022156.3168825-1-sashal@kernel.org>
References: <20210710022156.3168825-1-sashal@kernel.org>
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
index 30e9e680c74c..4d59d927ae3e 100644
--- a/drivers/usb/core/message.c
+++ b/drivers/usb/core/message.c
@@ -783,6 +783,9 @@ int usb_get_descriptor(struct usb_device *dev, unsigned char type,
 	int i;
 	int result;
 
+	if (size <= 0)		/* No point in asking for no data */
+		return -EINVAL;
+
 	memset(buf, 0, size);	/* Make sure we parse really received data */
 
 	for (i = 0; i < 3; ++i) {
@@ -832,6 +835,9 @@ static int usb_get_string(struct usb_device *dev, unsigned short langid,
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

