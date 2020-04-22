Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E75701B428F
	for <lists+stable@lfdr.de>; Wed, 22 Apr 2020 13:02:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732411AbgDVLCN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Apr 2020 07:02:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:48214 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726023AbgDVKAl (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Apr 2020 06:00:41 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 836B920774;
        Wed, 22 Apr 2020 10:00:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587549641;
        bh=ipGa19nKKTFXIKRlrk5uJWMpFfYkR2QvtOVETI2Td8s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OBbCCPbL+dHRUW6SUAa871i2/3jXDWUUxKsbg0c+D5tHtijhKmG5FuBvYA3zYoP5m
         ot2hUtQe/ZYn66Ar8fsYa9PiPlY6ZjuaI8dZYV9Ug0zyJ5jma58j9N9AlkLXJSRQJm
         COuXS15GBTPhw2rdgpcUPoOXG6JTGNNclFR1vAlM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 4.4 045/100] Input: i8042 - add Acer Aspire 5738z to nomux list
Date:   Wed, 22 Apr 2020 11:56:15 +0200
Message-Id: <20200422095030.482850238@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200422095022.476101261@linuxfoundation.org>
References: <20200422095022.476101261@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

commit ebc68cedec4aead47d8d11623d013cca9bf8e825 upstream.

The Acer Aspire 5738z has a button to disable (and re-enable) the
touchpad next to the touchpad.

When this button is pressed a LED underneath indicates that the touchpad
is disabled (and an event is send to userspace and GNOME shows its
touchpad enabled / disable OSD thingie).

So far so good, but after re-enabling the touchpad it no longer works.

The laptop does not have an external ps2 port, so mux mode is not needed
and disabling mux mode fixes the touchpad no longer working after toggling
it off and back on again, so lets add this laptop model to the nomux list.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Link: https://lore.kernel.org/r/20200331123947.318908-1-hdegoede@redhat.com
Cc: stable@vger.kernel.org
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/input/serio/i8042-x86ia64io.h |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/drivers/input/serio/i8042-x86ia64io.h
+++ b/drivers/input/serio/i8042-x86ia64io.h
@@ -534,6 +534,17 @@ static const struct dmi_system_id __init
 			DMI_MATCH(DMI_PRODUCT_VERSION, "Lenovo LaVie Z"),
 		},
 	},
+	{
+		/*
+		 * Acer Aspire 5738z
+		 * Touchpad stops working in mux mode when dis- + re-enabled
+		 * with the touchpad enable/disable toggle hotkey
+		 */
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Acer"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Aspire 5738"),
+		},
+	},
 	{ }
 };
 


