Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E840E3F652F
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 19:09:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236525AbhHXRKi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Aug 2021 13:10:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:52052 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239353AbhHXRJD (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Aug 2021 13:09:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3D37B61A35;
        Tue, 24 Aug 2021 17:00:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629824418;
        bh=h4iI8qPCizwNq2s1nC5fWv27sgXvHZ9YUi+My+ND0zg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sclOWyPwlTH66cJS2j6QygBi5FYmSv8x37kHaL3k1JJNGLMWPj78myEHgmtcMDz62
         0Nqv4U4eRec0ydZL8W07jYLCM0tusRhp0X+a0CAtX4mp1ohohmzBJZJqWG6/CWGx2s
         6u95/R9rnlmu/4MkaNzFysg3c8HSsBifj/VD9TQfPDYqaBLbSmLaO/Nn9vBv/ptE1a
         omRx9kXF0K+edDYJIMNk9En4jC8Bk58frjdCv0ohTGBhs7TdpUb24LAX2jAVhXNdvi
         4Fsp4MK51IHRoq8DMYUK48OiZg3mc7+xDoS5s0JutNtLIQHnkDRHC4aAnzWqg1XTbL
         uQGc5ch7HoqKw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hayes Wang <hayeswang@realtek.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 69/98] r8152: fix writing USB_BP2_EN
Date:   Tue, 24 Aug 2021 12:58:39 -0400
Message-Id: <20210824165908.709932-70-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210824165908.709932-1-sashal@kernel.org>
References: <20210824165908.709932-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.61-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.10.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.10.61-rc1
X-KernelTest-Deadline: 2021-08-26T16:58+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hayes Wang <hayeswang@realtek.com>

[ Upstream commit a876a33d2a1102f99fc782fefb784f4dd4841d8c ]

The register of USB_BP2_EN is 16 bits, so we should use
ocp_write_word(), not ocp_write_byte().

Fixes: 9370f2d05a2a ("support request_firmware for RTL8153")
Signed-off-by: Hayes Wang <hayeswang@realtek.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/r8152.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/usb/r8152.c b/drivers/net/usb/r8152.c
index 105622e1defa..0bb5b1c78654 100644
--- a/drivers/net/usb/r8152.c
+++ b/drivers/net/usb/r8152.c
@@ -3432,7 +3432,7 @@ static void rtl_clear_bp(struct r8152 *tp, u16 type)
 	case RTL_VER_09:
 	default:
 		if (type == MCU_TYPE_USB) {
-			ocp_write_byte(tp, MCU_TYPE_USB, USB_BP2_EN, 0);
+			ocp_write_word(tp, MCU_TYPE_USB, USB_BP2_EN, 0);
 
 			ocp_write_word(tp, MCU_TYPE_USB, USB_BP_8, 0);
 			ocp_write_word(tp, MCU_TYPE_USB, USB_BP_9, 0);
-- 
2.30.2

