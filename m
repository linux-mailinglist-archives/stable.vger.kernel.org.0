Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A1AC3A0224
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 21:20:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236368AbhFHTB3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 15:01:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:34016 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235659AbhFHS6Q (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Jun 2021 14:58:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 042136162A;
        Tue,  8 Jun 2021 18:42:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623177770;
        bh=slXEvorXgnkERiCypSz2a2OJZYDxd1ky0BIT90n/41U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mOE2yRi1+dqd1BP0Y884fVnAK9gXxtd1kxAjSQhRdL2JBnFvL0I7NxxEVaBfACymE
         xvqk1TsJ6hemM+bw51rZKxNoscjyxrIFjlhry4wvqXXJ4qnIus2BwC2/RQZZiUlp3j
         UPRzXY2Zs46UP0JJ/JS7J5/WrtEYcmFlRL6IGRY0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+ee6f6e2e68886ca256a8@syzkaller.appspotmail.com,
        Claudio Mettler <claudio@ponyfleisch.ch>,
        Marek Wyborski <marek.wyborski@emwesoft.com>,
        Sean OBrien <seobrien@chromium.org>,
        Johan Hovold <johan@kernel.org>, Jiri Kosina <jkosina@suse.cz>
Subject: [PATCH 5.10 094/137] HID: magicmouse: fix NULL-deref on disconnect
Date:   Tue,  8 Jun 2021 20:27:14 +0200
Message-Id: <20210608175945.560883449@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210608175942.377073879@linuxfoundation.org>
References: <20210608175942.377073879@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johan Hovold <johan@kernel.org>

commit 4b4f6cecca446abcb686c6e6c451d4f1ec1a7497 upstream.

Commit 9d7b18668956 ("HID: magicmouse: add support for Apple Magic
Trackpad 2") added a sanity check for an Apple trackpad but returned
success instead of -ENODEV when the check failed. This means that the
remove callback will dereference the never-initialised driver data
pointer when the driver is later unbound (e.g. on USB disconnect).

Reported-by: syzbot+ee6f6e2e68886ca256a8@syzkaller.appspotmail.com
Fixes: 9d7b18668956 ("HID: magicmouse: add support for Apple Magic Trackpad 2")
Cc: stable@vger.kernel.org      # 4.20
Cc: Claudio Mettler <claudio@ponyfleisch.ch>
Cc: Marek Wyborski <marek.wyborski@emwesoft.com>
Cc: Sean O'Brien <seobrien@chromium.org>
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/hid-magicmouse.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/hid/hid-magicmouse.c
+++ b/drivers/hid/hid-magicmouse.c
@@ -597,7 +597,7 @@ static int magicmouse_probe(struct hid_d
 	if (id->vendor == USB_VENDOR_ID_APPLE &&
 	    id->product == USB_DEVICE_ID_APPLE_MAGICTRACKPAD2 &&
 	    hdev->type != HID_TYPE_USBMOUSE)
-		return 0;
+		return -ENODEV;
 
 	msc = devm_kzalloc(&hdev->dev, sizeof(*msc), GFP_KERNEL);
 	if (msc == NULL) {


