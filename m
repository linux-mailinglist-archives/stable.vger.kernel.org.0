Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A18340E620
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 19:29:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346428AbhIPRSL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 13:18:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:41429 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344027AbhIPRQJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 13:16:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B91F361BBF;
        Thu, 16 Sep 2021 16:40:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631810420;
        bh=UEgh7KQtnW5lA2hV2j533cGjH0PKuJRYcbQtdhF7p9M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=17+jl6bXhO5A7yfCnzUlXm1GIw+pmpdh+e3q6UDZ9aGBjqWaM4fJFw/3oY/7Hbd56
         dBmHE/MSzAZq2UyTvTPXKgufzHqVXBiYFruj+bbapGef6QCDrufnJZuQ8Sb3yyCjWW
         wc4iNFGzpEd4m+stMGm7Hxu9AbzvV6gCrKad7y+A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lukas Bulwahn <lukas.bulwahn@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 127/432] HID: thrustmaster: clean up Makefile and adapt quirks
Date:   Thu, 16 Sep 2021 17:57:56 +0200
Message-Id: <20210916155815.063006612@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155810.813340753@linuxfoundation.org>
References: <20210916155810.813340753@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lukas Bulwahn <lukas.bulwahn@gmail.com>

[ Upstream commit 462ba66198a4a8ea996028915af10a698086e302 ]

Commit c49c33637802 ("HID: support for initialization of some Thrustmaster
wheels") messed up the Makefile and quirks during the refactoring of this
commit.

Luckily, ./scripts/checkkconfigsymbols.py warns on non-existing configs:

HID_TMINIT
Referencing files: drivers/hid/Makefile, drivers/hid/hid-quirks.c

Following the discussion (see Link), CONFIG_HID_THRUSTMASTER is the
intended config for CONFIG_HID_TMINIT and the file hid-tminit.c was
actually added as hid-thrustmaster.c.

So, clean up Makefile and adapt quirks to that refactoring.

Fixes: c49c33637802 ("HID: support for initialization of some Thrustmaster wheels")
Link: https://lore.kernel.org/linux-input/CAKXUXMx6dByO03f3dX0X5zjvQp0j2AhJBg0vQFDmhZUhtKxRxw@mail.gmail.com/
Signed-off-by: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/Makefile     | 1 -
 drivers/hid/hid-quirks.c | 2 --
 2 files changed, 3 deletions(-)

diff --git a/drivers/hid/Makefile b/drivers/hid/Makefile
index 1ea1a7c0b20f..e29efcb1c040 100644
--- a/drivers/hid/Makefile
+++ b/drivers/hid/Makefile
@@ -115,7 +115,6 @@ obj-$(CONFIG_HID_STEELSERIES)	+= hid-steelseries.o
 obj-$(CONFIG_HID_SUNPLUS)	+= hid-sunplus.o
 obj-$(CONFIG_HID_GREENASIA)	+= hid-gaff.o
 obj-$(CONFIG_HID_THRUSTMASTER)	+= hid-tmff.o hid-thrustmaster.o
-obj-$(CONFIG_HID_TMINIT)	+= hid-tminit.o
 obj-$(CONFIG_HID_TIVO)		+= hid-tivo.o
 obj-$(CONFIG_HID_TOPSEED)	+= hid-topseed.o
 obj-$(CONFIG_HID_TWINHAN)	+= hid-twinhan.o
diff --git a/drivers/hid/hid-quirks.c b/drivers/hid/hid-quirks.c
index 51b39bda9a9d..2e104682c22b 100644
--- a/drivers/hid/hid-quirks.c
+++ b/drivers/hid/hid-quirks.c
@@ -662,8 +662,6 @@ static const struct hid_device_id hid_have_special_driver[] = {
 	{ HID_USB_DEVICE(USB_VENDOR_ID_THRUSTMASTER, 0xb653) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_THRUSTMASTER, 0xb654) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_THRUSTMASTER, 0xb65a) },
-#endif
-#if IS_ENABLED(CONFIG_HID_TMINIT)
 	{ HID_USB_DEVICE(USB_VENDOR_ID_THRUSTMASTER, 0xb65d) },
 #endif
 #if IS_ENABLED(CONFIG_HID_TIVO)
-- 
2.30.2



