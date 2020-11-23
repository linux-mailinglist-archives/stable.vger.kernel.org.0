Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9FD662C0786
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 13:44:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732535AbgKWMkl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 07:40:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:53528 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732529AbgKWMkj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Nov 2020 07:40:39 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5EA0820857;
        Mon, 23 Nov 2020 12:40:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606135238;
        bh=4tkJfRLL+x/vtIR/vHVvnhcoeEplKQ4liZAcFlzeWA8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=s9bWoyrmW7V4YQ0H6Jqx39xTJwBcODRABD3xKko0AW+0uoM1XMHAimfRu4rce1xuE
         gHfQAoghN1YHOgO0JFkLdpKtqmf5YR6KmDNipBJjXiH3OyGM0qZ5hrnQCF5Kzy/ae6
         DvvcJy6twVoLCcyL1gQKixd9L4RpvVKLYohmX+5A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>
Subject: [PATCH 5.4 125/158] HID: logitech-dj: Fix an error in mse_bluetooth_descriptor
Date:   Mon, 23 Nov 2020 13:22:33 +0100
Message-Id: <20201123121825.963444706@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201123121819.943135899@linuxfoundation.org>
References: <20201123121819.943135899@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

commit eec231e060fb79923c349f6e89f022b286f32c1e upstream.

Fix an error in the mouse / INPUT(2) descriptor used for quad/bt2.0 combo
receivers. Replace INPUT with INPUT (Data,Var,Abs) for the field for the
4 extra buttons which share their report-byte with the low-res hwheel.

This is likely a copy and paste error. I've verified that the new
0x81, 0x02 value matches both the mouse descriptor for the currently
supported MX5000 / MX5500 receivers, as well as the INPUT(2) mouse
descriptors for the Dinovo receivers for which support is being
worked on.

Cc: stable@vger.kernel.org
Fixes: f2113c3020ef ("HID: logitech-dj: add support for Logitech Bluetooth Mini-Receiver")
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/hid/hid-logitech-dj.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/hid/hid-logitech-dj.c
+++ b/drivers/hid/hid-logitech-dj.c
@@ -328,7 +328,7 @@ static const char mse_bluetooth_descript
 	0x25, 0x01,		/*      LOGICAL_MAX (1)                 */
 	0x75, 0x01,		/*      REPORT_SIZE (1)                 */
 	0x95, 0x04,		/*      REPORT_COUNT (4)                */
-	0x81, 0x06,		/*      INPUT                           */
+	0x81, 0x02,		/*      INPUT (Data,Var,Abs)            */
 	0xC0,			/*    END_COLLECTION                    */
 	0xC0,			/*  END_COLLECTION                      */
 };


