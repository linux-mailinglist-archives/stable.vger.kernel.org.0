Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53A4C370C0D
	for <lists+stable@lfdr.de>; Sun,  2 May 2021 16:05:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232749AbhEBOFN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 2 May 2021 10:05:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:49940 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232525AbhEBOEw (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 2 May 2021 10:04:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 94E97613AF;
        Sun,  2 May 2021 14:03:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619964238;
        bh=yRYcq6j35c8xXbshQieIahs1G4PzznF+jh3voE7fUqo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tkEYPI7v3VhGmQx5jBQjBUdJQiXHN1DApFd8hHciPpY72ZYKPBfNMlGJNAWU0hv36
         Y8PtMOyEt0PeroRKqtWk08s2kSvrpcSe5X6jcUTyoVc3BZkqJP9O/FzSWU3ES2GRVG
         HvIVvkB+NGVgZ+xblq/t/zDuEPC+lyGHClzmw/2BGi5yqEwIvVuCXypfVQ5RpJ+h4V
         gXGbz1+ihjDpaHaJOpxVclaW/wsV2gDjekJ/jGXVWzObSKiiyX2MZrdntfhdzNAO47
         Kz6asKlk7ZAiw7AmgkN1KfQ4xHmS6m4OSpWnUz+DJ5gWiN/TmJyBaoHNN9eKzf1JQz
         NJcG/1XWE1jxg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Pawel Laszczak <pawell@cadence.com>,
        Peter Chen <peter.chen@kernel.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 5.11 09/70] usb: gadget: uvc: add bInterval checking for HS mode
Date:   Sun,  2 May 2021 10:02:43 -0400
Message-Id: <20210502140344.2719040-9-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210502140344.2719040-1-sashal@kernel.org>
References: <20210502140344.2719040-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pawel Laszczak <pawell@cadence.com>

[ Upstream commit 26adde04acdff14a1f28d4a5dce46a8513a3038b ]

Patch adds extra checking for bInterval passed by configfs.
The 5.6.4 chapter of USB Specification (rev. 2.0) say:
"A high-bandwidth endpoint must specify a period of 1x125 µs
(i.e., a bInterval value of 1)."

The issue was observed during testing UVC class on CV.
I treat this change as improvement because we can control
bInterval by configfs.

Reviewed-by: Peter Chen <peter.chen@kernel.org>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Pawel Laszczak <pawell@cadence.com>
Link: https://lore.kernel.org/r/20210308125338.4824-1-pawell@gli-login.cadence.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/gadget/function/f_uvc.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/gadget/function/f_uvc.c b/drivers/usb/gadget/function/f_uvc.c
index 44b4352a2676..ed77a126a74f 100644
--- a/drivers/usb/gadget/function/f_uvc.c
+++ b/drivers/usb/gadget/function/f_uvc.c
@@ -633,7 +633,12 @@ uvc_function_bind(struct usb_configuration *c, struct usb_function *f)
 
 	uvc_hs_streaming_ep.wMaxPacketSize =
 		cpu_to_le16(max_packet_size | ((max_packet_mult - 1) << 11));
-	uvc_hs_streaming_ep.bInterval = opts->streaming_interval;
+
+	/* A high-bandwidth endpoint must specify a bInterval value of 1 */
+	if (max_packet_mult > 1)
+		uvc_hs_streaming_ep.bInterval = 1;
+	else
+		uvc_hs_streaming_ep.bInterval = opts->streaming_interval;
 
 	uvc_ss_streaming_ep.wMaxPacketSize = cpu_to_le16(max_packet_size);
 	uvc_ss_streaming_ep.bInterval = opts->streaming_interval;
-- 
2.30.2

