Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2C4337C9E7
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 18:49:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233645AbhELQXY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:23:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:59068 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240592AbhELQSY (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:18:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0DC1761D78;
        Wed, 12 May 2021 15:44:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620834281;
        bh=QYHYkripwHaGR1tW7wMyF4+coN5sPnCg/WOWkblfgL4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DvuNx1G5+5D+pYOrg6sCnXFClRv4NSdx1Gh+DmD8Kvbu6/SrCafakNV9dHCvIQDeG
         0706vYb0FtsZPDhVgqA03gYAG6UWzPtU2LtXyAn9zvcLi6UwCf5GVI44dj+PcqbI6v
         TFgG+oU+jWMV+dIOMNmzki542IMyFJQJH+O60yco=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
        Hans de Goede <hdegoede@redhat.com>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 446/601] HID: lenovo: Check hid_get_drvdata() returns non NULL in lenovo_event()
Date:   Wed, 12 May 2021 16:48:43 +0200
Message-Id: <20210512144842.532478289@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144827.811958675@linuxfoundation.org>
References: <20210512144827.811958675@linuxfoundation.org>
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



