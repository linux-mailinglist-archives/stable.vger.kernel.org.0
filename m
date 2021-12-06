Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47AEE46AA13
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 22:19:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351209AbhLFVXY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 16:23:24 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:59034 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351192AbhLFVXV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 16:23:21 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E6F74B81235;
        Mon,  6 Dec 2021 21:19:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A42EC341C7;
        Mon,  6 Dec 2021 21:19:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638825589;
        bh=5cg5oAvJriNeNNBOrIb4iPS0++hOPrbHcRo+XXsfv/o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FGFtTNaCU7Bf0rcaikQVDi5cmktS9AnzJQzzAiz/W1jWa/k+7nsl+FhPzyxzG5oFk
         XpFYnIEvTRl2ltFlvcuPHEWl0Nesa9/eUZWmKWNmx5oqkBf0eYFcO38FkW3G9nPfa/
         u1UsNq/nfG+RdyO1xfgqd3omhV8ArGRoJhDVt9qhiaQA85LRPaSGo2B0j1Ws3dp3SQ
         H/ETqMd/v1h2R7xBytMeAG36PK/aYoGm2H0QfGp45tgxkl5s/xEqW7NuinRWrqSROx
         +jmZNZqlhCK5mGCCcwROoAZdSunm7GQuS8MASQYtKNeqGLm8JNzb0jQ3qZyz6OYtVW
         eHSi0hyq+HZgQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ole Ernst <olebowle@gmx.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, gregkh@linuxfoundation.org,
        stern@rowland.harvard.edu, vpalatin@chromium.org,
        chris.chiu@canonical.com, oneukum@suse.com,
        stefan.ursella@wolfvision.net, johan@kernel.org,
        linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 2/7] USB: NO_LPM quirk Lenovo Powered USB-C Travel Hub
Date:   Mon,  6 Dec 2021 16:19:22 -0500
Message-Id: <20211206211934.1661294-2-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211206211934.1661294-1-sashal@kernel.org>
References: <20211206211934.1661294-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ole Ernst <olebowle@gmx.com>

[ Upstream commit 49989adc38f8693fb6e9f019904dd00c1d1db5ac ]

This is another branded 8153 device that doesn't work well with LPM:
r8152 2-2.1:1.0 enp0s13f0u2u1: Stop submitting intr, status -71

Disable LPM to resolve the issue.

Signed-off-by: Ole Ernst <olebowle@gmx.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/core/quirks.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/usb/core/quirks.c b/drivers/usb/core/quirks.c
index d97544fd339b1..e170c5b4d6f0c 100644
--- a/drivers/usb/core/quirks.c
+++ b/drivers/usb/core/quirks.c
@@ -435,6 +435,9 @@ static const struct usb_device_id usb_quirk_list[] = {
 	{ USB_DEVICE(0x1532, 0x0116), .driver_info =
 			USB_QUIRK_LINEAR_UFRAME_INTR_BINTERVAL },
 
+	/* Lenovo Powered USB-C Travel Hub (4X90S92381, RTL8153 GigE) */
+	{ USB_DEVICE(0x17ef, 0x721e), .driver_info = USB_QUIRK_NO_LPM },
+
 	/* Lenovo ThinkCenter A630Z TI024Gen3 usb-audio */
 	{ USB_DEVICE(0x17ef, 0xa012), .driver_info =
 			USB_QUIRK_DISCONNECT_SUSPEND },
-- 
2.33.0

