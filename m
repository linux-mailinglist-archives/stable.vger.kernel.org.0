Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 79774198F2F
	for <lists+stable@lfdr.de>; Tue, 31 Mar 2020 11:01:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730341AbgCaJBU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Mar 2020 05:01:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:40460 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730541AbgCaJBT (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 31 Mar 2020 05:01:19 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CA82420B1F;
        Tue, 31 Mar 2020 09:01:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585645278;
        bh=vhGI45rn2Ty8tXWcSB2nbLy+mTD6PsHxSUVxyGrjF3c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fltoT55GJNsZfsyN6kV92NsZzltQVtaMKYmxNgIq1R+N//ThBirsSGCyGJohl8Oas
         wgVG8hJo4TlliqlPRe2gX3vv5cbWhTbdgO04y4qQhyOF53+tVio154OLyfQTyRM/kt
         jHlTp/7eqNtkrYRKobMODmed9HO+t8OESmcdc7wU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        Johan Hovold <johan@kernel.org>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: [PATCH 5.6 19/23] media: ov519: add missing endpoint sanity checks
Date:   Tue, 31 Mar 2020 10:59:31 +0200
Message-Id: <20200331085316.636106929@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200331085308.098696461@linuxfoundation.org>
References: <20200331085308.098696461@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johan Hovold <johan@kernel.org>

commit 998912346c0da53a6dbb71fab3a138586b596b30 upstream.

Make sure to check that we have at least one endpoint before accessing
the endpoint array to avoid dereferencing a NULL-pointer on stream
start.

Note that these sanity checks are not redundant as the driver is mixing
looking up altsettings by index and by number, which need not coincide.

Fixes: 1876bb923c98 ("V4L/DVB (12079): gspca_ov519: add support for the ov511 bridge")
Fixes: b282d87332f5 ("V4L/DVB (12080): gspca_ov519: Fix ov518+ with OV7620AE (Trust spacecam 320)")
Cc: stable <stable@vger.kernel.org>     # 2.6.31
Cc: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/media/usb/gspca/ov519.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/drivers/media/usb/gspca/ov519.c
+++ b/drivers/media/usb/gspca/ov519.c
@@ -3477,6 +3477,11 @@ static void ov511_mode_init_regs(struct
 		return;
 	}
 
+	if (alt->desc.bNumEndpoints < 1) {
+		sd->gspca_dev.usb_err = -ENODEV;
+		return;
+	}
+
 	packet_size = le16_to_cpu(alt->endpoint[0].desc.wMaxPacketSize);
 	reg_w(sd, R51x_FIFO_PSIZE, packet_size >> 5);
 
@@ -3603,6 +3608,11 @@ static void ov518_mode_init_regs(struct
 		return;
 	}
 
+	if (alt->desc.bNumEndpoints < 1) {
+		sd->gspca_dev.usb_err = -ENODEV;
+		return;
+	}
+
 	packet_size = le16_to_cpu(alt->endpoint[0].desc.wMaxPacketSize);
 	ov518_reg_w32(sd, R51x_FIFO_PSIZE, packet_size & ~7, 2);
 


