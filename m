Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E69A137C59A
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 17:41:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234604AbhELPly (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 11:41:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:57088 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236228AbhELPhW (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 11:37:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4E8FB6198A;
        Wed, 12 May 2021 15:18:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620832729;
        bh=QYHYkripwHaGR1tW7wMyF4+coN5sPnCg/WOWkblfgL4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kZrTfXAbr13TM5YYuHlGkbVyqy45+xGerVtklx9fgW7in/zLAkEVFSG9nHDZFe7/g
         hnjZZEry3J4DKdPWDMb+Du5fvs7A/hzTYPDfFXJ84LiIX6HKHGe3SQx4FUP/Z85MiZ
         M4fPBIaHUBIlrKB7au1f4kZ+nyItA3q4QZb9qPp4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
        Hans de Goede <hdegoede@redhat.com>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 398/530] HID: lenovo: Check hid_get_drvdata() returns non NULL in lenovo_event()
Date:   Wed, 12 May 2021 16:48:28 +0200
Message-Id: <20210512144832.850804275@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144819.664462530@linuxfoundation.org>
References: <20210512144819.664462530@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit 34348a8661e3cd67dcf6938f08c8bb77522301f7 ]

The HID lenovo probe function only attaches drvdata to one of the
USB interfaces, but lenovo_event() will get called for all USB interfaces
to which hid-lenovo is bound.

This allows a malicious device to fake being a device handled by
hid-lenovo, which generates events for which lenovo_event() has
special handling (and thus dereferences hid_get_drvdata()) on another
interface triggering a NULL pointer exception.

Add a check for hid_get_drvdata() returning NULL, avoiding this
possible NULL pointer exception.

Fixes: bc04b37ea0ec ("HID: lenovo: Add ThinkPad 10 Ultrabook Keyboard support")
Reviewed-by: Marek Behún <kabel@kernel.org>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-lenovo.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/hid/hid-lenovo.c b/drivers/hid/hid-lenovo.c
index ee175ab54281..b2596ed37880 100644
--- a/drivers/hid/hid-lenovo.c
+++ b/drivers/hid/hid-lenovo.c
@@ -508,6 +508,9 @@ static int lenovo_event_cptkbd(struct hid_device *hdev,
 static int lenovo_event(struct hid_device *hdev, struct hid_field *field,
 		struct hid_usage *usage, __s32 value)
 {
+	if (!hid_get_drvdata(hdev))
+		return 0;
+
 	switch (hdev->product) {
 	case USB_DEVICE_ID_LENOVO_CUSBKBD:
 	case USB_DEVICE_ID_LENOVO_CBTKBD:
-- 
2.30.2



