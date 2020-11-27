Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA8BF2C6770
	for <lists+stable@lfdr.de>; Fri, 27 Nov 2020 15:07:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730816AbgK0OGT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 Nov 2020 09:06:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:46636 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730811AbgK0OGS (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 27 Nov 2020 09:06:18 -0500
Received: from localhost (82-217-20-185.cable.dynamic.v4.ziggo.nl [82.217.20.185])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 95AA5206D8;
        Fri, 27 Nov 2020 14:06:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606485978;
        bh=7Cx0G/Y2mfpFIqDuZ+46cjD+xP3rrBp6SC4rq755758=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=euJ0tZlg94SgaqtlB7OQrZFZ1ctCiknUOFp+RWcUIOXjEHHKz9THIXJAhLzC80Tpc
         /QcKsxh45ybgD8Hnwj4mqPS5NjVe/AxhIeo64MI2lW10R5K0mWwF7DPeUv7tGHCafW
         C8dnPfcMOpI17lvSOVEyY5GvfQ9vMLgcsQuiw1x0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     balbi@kernel.org
Cc:     peter.chen@nxp.com, willmcvicker@google.com,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable <stable@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH v2 3/5] USB: gadget: f_midi: setup SuperSpeed Plus descriptors
Date:   Fri, 27 Nov 2020 15:05:57 +0100
Message-Id: <20201127140559.381351-4-gregkh@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201127140559.381351-1-gregkh@linuxfoundation.org>
References: <20201127140559.381351-1-gregkh@linuxfoundation.org>
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
Reviewed-by: Peter Chen <peter.chen@nxp.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/function/f_midi.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/usb/gadget/function/f_midi.c b/drivers/usb/gadget/function/f_midi.c
index 85cb15734aa8..974a2d931c3b 100644
--- a/drivers/usb/gadget/function/f_midi.c
+++ b/drivers/usb/gadget/function/f_midi.c
@@ -1048,6 +1048,12 @@ static int f_midi_bind(struct usb_configuration *c, struct usb_function *f)
 		f->ss_descriptors = usb_copy_descriptors(midi_function);
 		if (!f->ss_descriptors)
 			goto fail_f_midi;
+
+		if (gadget_is_superspeed_plus(c->cdev->gadget)) {
+			f->ssp_descriptors = usb_copy_descriptors(midi_function);
+			if (!f->ssp_descriptors)
+				goto fail_f_midi;
+		}
 	}
 
 	kfree(midi_function);
-- 
2.29.2

