Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED93F29C32D
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 18:44:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1821453AbgJ0Rnw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 13:43:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:58522 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1759287AbgJ0Obn (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:31:43 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 957CF206DC;
        Tue, 27 Oct 2020 14:31:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603809103;
        bh=DfuOybiE0/kryS5zQ+oUbHWyBHHnPpeSbI96AM6mWTg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dzNiKhnM7wHQjwM8uMtPMbOMokkqPM4AKKeTDhsp1OuytU3A87XZFnscPJ7n1l5tC
         uVAgoRKF90TJRiJxyafDEv/D6OCFUYPqLVQvSFXq8+3t0mtgnlPTZGZSOGDU1BGdB6
         7C1rfz8JOyHI0oEfD6I5+2opr1rRZoy+D5fBil4s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 076/408] media: uvcvideo: Silence shift-out-of-bounds warning
Date:   Tue, 27 Oct 2020 14:50:14 +0100
Message-Id: <20201027135458.591123700@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135455.027547757@linuxfoundation.org>
References: <20201027135455.027547757@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

[ Upstream commit 171994e498a0426cbe17f874c5c6af3c0af45200 ]

UBSAN reports a shift-out-of-bounds warning in uvc_get_le_value(). The
report is correct, but the issue should be harmless as the computed
value isn't used when the shift is negative. This may however cause
incorrect behaviour if a negative shift could generate adverse side
effects (such as a trap on some architectures for instance).

Regardless of whether that may happen or not, silence the warning as a
full WARN backtrace isn't nice.

Reported-by: Bart Van Assche <bvanassche@acm.org>
Fixes: c0efd232929c ("V4L/DVB (8145a): USB Video Class driver")
Signed-off-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Tested-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/usb/uvc/uvc_ctrl.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/media/usb/uvc/uvc_ctrl.c b/drivers/media/usb/uvc/uvc_ctrl.c
index e399b9fad7574..a30a8a731eda8 100644
--- a/drivers/media/usb/uvc/uvc_ctrl.c
+++ b/drivers/media/usb/uvc/uvc_ctrl.c
@@ -773,12 +773,16 @@ static s32 uvc_get_le_value(struct uvc_control_mapping *mapping,
 	offset &= 7;
 	mask = ((1LL << bits) - 1) << offset;
 
-	for (; bits > 0; data++) {
+	while (1) {
 		u8 byte = *data & mask;
 		value |= offset > 0 ? (byte >> offset) : (byte << (-offset));
 		bits -= 8 - (offset > 0 ? offset : 0);
+		if (bits <= 0)
+			break;
+
 		offset -= 8;
 		mask = (1 << bits) - 1;
+		data++;
 	}
 
 	/* Sign-extend the value if needed. */
-- 
2.25.1



