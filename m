Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5691B18467F
	for <lists+stable@lfdr.de>; Fri, 13 Mar 2020 13:07:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726535AbgCMMHT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Mar 2020 08:07:19 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:59637 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726569AbgCMMHT (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 13 Mar 2020 08:07:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584101238;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=G0kaBi6IkDXHjWfkSFy1894dzC8BJqVH1twc7MebBYg=;
        b=Y5IvcOM55lFMvUxOdZq67chmAZ0DLmh4paM6BkOj9qzCh0xBrec7M9xvOmTjRLpdYha/qJ
        tBxiHIbT1N82iGGCxWxRlUc+TxqXPIA7q6lsG6TZw/uVDNGT227CyX85uQZWBmyqxd0gwD
        IsU9Jl/QcHt/j8BppUU3jF8PMFeP2r0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-264-jIXyjGxMPQS_sKmVWawSmQ-1; Fri, 13 Mar 2020 08:07:12 -0400
X-MC-Unique: jIXyjGxMPQS_sKmVWawSmQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 35BBC800D4E;
        Fri, 13 Mar 2020 12:07:11 +0000 (UTC)
Received: from x1.localdomain.com (ovpn-117-140.ams2.redhat.com [10.36.117.140])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DA2BB196AE;
        Fri, 13 Mar 2020 12:07:09 +0000 (UTC)
From:   Hans de Goede <hdegoede@redhat.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Hans de Goede <hdegoede@redhat.com>, linux-usb@vger.kernel.org,
        stable@vger.kernel.org, russianneuromancer@ya.ru
Subject: [PATCH] usb: quirks: add NO_LPM quirk for RTL8153 based ethernet adapters
Date:   Fri, 13 Mar 2020 13:07:08 +0100
Message-Id: <20200313120708.100339-1-hdegoede@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

We have been receiving bug reports that ethernet connections over
RTL8153 based ethernet adapters stops working after a while with
errors like these showing up in dmesg when the ethernet stops working:

[12696.189484] r8152 6-1:1.0 enp10s0u1: Tx timeout
[12702.333456] r8152 6-1:1.0 enp10s0u1: Tx timeout
[12707.965422] r8152 6-1:1.0 enp10s0u1: Tx timeout

This has been reported on Dell WD15 docks, Belkin USB-C Express Dock 3.1
docks and with generic USB to ethernet dongles using the RTL8153
chipsets. Some users have tried adding usbcore.quirks=3D0bda:8153:k to
the kernel commandline and all users who have tried this report that
this fixes this.

Also note that we already have an existing NO_LPM quirk for the RTL8153
used in the Microsoft Surface Dock (where it uses a different usb-id).

This commit adds a NO_LPM quirk for the generic Realtek RTL8153
0bda:8153 usb-id, fixing the Tx timeout errors on these devices.

BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=3D198931
Cc: stable@vger.kernel.org
Cc: russianneuromancer@ya.ru
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
---
 drivers/usb/core/quirks.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/usb/core/quirks.c b/drivers/usb/core/quirks.c
index 2dac3e7cdd97..c2525e9c117c 100644
--- a/drivers/usb/core/quirks.c
+++ b/drivers/usb/core/quirks.c
@@ -378,6 +378,9 @@ static const struct usb_device_id usb_quirk_list[] =3D=
 {
 	{ USB_DEVICE(0x0b05, 0x17e0), .driver_info =3D
 			USB_QUIRK_IGNORE_REMOTE_WAKEUP },
=20
+	/* Generic RTL8153 based ethernet adapters */
+	{ USB_DEVICE(0x0bda, 0x8153), .driver_info =3D USB_QUIRK_NO_LPM },
+
 	/* Action Semiconductor flash disk */
 	{ USB_DEVICE(0x10d6, 0x2200), .driver_info =3D
 			USB_QUIRK_STRING_FETCH_255 },
--=20
2.25.1

