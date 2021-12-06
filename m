Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94F6346A9BE
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 22:16:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350944AbhLFVTw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 16:19:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350510AbhLFVTa (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 16:19:30 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9FF0C061D5E;
        Mon,  6 Dec 2021 13:16:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B3DA8B8110F;
        Mon,  6 Dec 2021 21:15:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8067FC341C9;
        Mon,  6 Dec 2021 21:15:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638825358;
        bh=BnH9eXVs3zPSfGfbFrJjwOny6+mY5lAF9kfF8ap7i6w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oDjiz9pcweUBSLKlugI2b0ga+DmysvdHcH4TmB40YjWZbSJPppdKTLLQ9IjhxnOV8
         TqM9OXvkSn7+o2BCPwnfjma0tVzdx4hiXurRxWW26g3G/tkKhs3+XJ1kk8Go/qx5xW
         4+3d0pdAxkMQCLhAMy6EerOITh8df9kR5puBeyplyV6VGTR7iDMz7B6Cv5G6k9ATDc
         C4FeRDvgQ4ZIaGzhiD3Ztqc45DpFQswJv+TEG+71VbfqDTTXCT3MtLotdJtujgfWnQ
         SuS6fsuMGCNdWwyB3vrffMWtNfvgXiR2HT2JCg9iaC61sAnhWm12oqE05os3Sylr4i
         /4Jx/hGzUtsog==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ole Ernst <olebowle@gmx.com>,
        "David S . Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>, gregkh@linuxfoundation.org,
        chris.chiu@canonical.com, stern@rowland.harvard.edu,
        vpalatin@chromium.org, kai.heng.feng@canonical.com,
        johan@kernel.org, stefan.ursella@wolfvision.net,
        linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 05/15] USB: NO_LPM quirk Lenovo Powered USB-C Travel Hub
Date:   Mon,  6 Dec 2021 16:15:05 -0500
Message-Id: <20211206211520.1660478-5-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211206211520.1660478-1-sashal@kernel.org>
References: <20211206211520.1660478-1-sashal@kernel.org>
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
index a54a735b63843..61f686c5bd9c6 100644
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

