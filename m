Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C54B2C5BA9
	for <lists+stable@lfdr.de>; Thu, 26 Nov 2020 19:10:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404789AbgKZSJ4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 26 Nov 2020 13:09:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:55026 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404737AbgKZSJz (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 26 Nov 2020 13:09:55 -0500
Received: from localhost (82-217-20-185.cable.dynamic.v4.ziggo.nl [82.217.20.185])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6310721D7E;
        Thu, 26 Nov 2020 18:09:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606414193;
        bh=vgr4nsH06A3wo/W7zrY8+O1P2aOVbxP/HEId8TSlnU8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JFK4l/IXqRAdEBMq94OlHXI7FOz7avnSycZsDpf88lpVAgy7sLWdralqqAyjnZRSA
         0vyWuNDi3VLlNirNRnbw2cMk1qiAPgeesKwJVKhUs3Z4MVl8QhaEsN3KNN/ecow5ek
         t3V1hX0ZE3voXA5YC6yuaCvna3ONLEepKdAcE/Us=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     balbi@kernel.org
Cc:     linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Will McVicker <willmcvicker@google.com>,
        stable <stable@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 4/4] USB: gadget: f_midi: setup SuperSpeed Plus descriptors
Date:   Thu, 26 Nov 2020 19:09:37 +0100
Message-Id: <20201126180937.255892-4-gregkh@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201126180937.255892-1-gregkh@linuxfoundation.org>
References: <20201126180937.255892-1-gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Will McVicker <willmcvicker@google.com>

Needed for SuperSpeed Plus support for f_midi.  This allows the
gadget to work properly without crashing at SuperSpeed rates.

Cc: Felipe Balbi <balbi@kernel.org>
Cc: stable <stable@vger.kernel.org>
Signed-off-by: Will McVicker <willmcvicker@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/function/f_midi.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/usb/gadget/function/f_midi.c b/drivers/usb/gadget/function/f_midi.c
index 85cb15734aa8..ceb67651de4f 100644
--- a/drivers/usb/gadget/function/f_midi.c
+++ b/drivers/usb/gadget/function/f_midi.c
@@ -1048,6 +1048,11 @@ static int f_midi_bind(struct usb_configuration *c, struct usb_function *f)
 		f->ss_descriptors = usb_copy_descriptors(midi_function);
 		if (!f->ss_descriptors)
 			goto fail_f_midi;
+		if (gadget_is_superspeed_plus(c->cdev->gadget)) {
+			f->ssp_descriptors = usb_copy_descriptors(midi_function);
+			if (!f->ssp_descriptors)
+				goto fail_f_midi;
+		}
 	}
 
 	kfree(midi_function);
-- 
2.29.2

