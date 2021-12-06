Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 916AB46A95D
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 22:13:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350241AbhLFVRY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 16:17:24 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:52034 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350377AbhLFVRF (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 16:17:05 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B96F9B8110F;
        Mon,  6 Dec 2021 21:13:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3EFEC341C7;
        Mon,  6 Dec 2021 21:13:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638825213;
        bh=gG5974s/tIrHmn1xoPlo+42fR1hB2+r/ON3rWhyASRk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EF+0P0zpcWM/649/JOmMkiaZJD1oFyAufS+eLGsaWZ4l+1c/FNwcMJls/x3qFdzzc
         B8mpdQjCMkm66frkIYht5mit6TkjeCUH32/TNLf4qfnom5Mcn9z3VALFe3yDVIeHAw
         MJ6/Qp3weJBda8Bl6FvrYM6wuv1eH4Ww4JrUaQgw4lFFQLsuLY2xzlgplMWeeqeqyE
         G7XUtTLLtvysJAFfWu52rrrr394X1snRuT/549XgPvVWlBYQX3n6ydIqTZdnpunDyv
         S2XigKXUi21AUA5zjL5dPQmC/TvqA+Kkvr9mSi6ViOC6UFoqu3osr8MZt6mo2AI49r
         N1E8F0nn7/QEA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ole Ernst <olebowle@gmx.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, gregkh@linuxfoundation.org,
        vpalatin@chromium.org, chris.chiu@canonical.com,
        stern@rowland.harvard.edu, stefan.ursella@wolfvision.net,
        kai.heng.feng@canonical.com, oneukum@suse.com, johan@kernel.org,
        linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 08/24] USB: NO_LPM quirk Lenovo Powered USB-C Travel Hub
Date:   Mon,  6 Dec 2021 16:12:13 -0500
Message-Id: <20211206211230.1660072-8-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211206211230.1660072-1-sashal@kernel.org>
References: <20211206211230.1660072-1-sashal@kernel.org>
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
index 8239fe7129dd7..019351c0b52cf 100644
--- a/drivers/usb/core/quirks.c
+++ b/drivers/usb/core/quirks.c
@@ -434,6 +434,9 @@ static const struct usb_device_id usb_quirk_list[] = {
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

