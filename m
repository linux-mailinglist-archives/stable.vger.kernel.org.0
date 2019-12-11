Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6DB2311B689
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 17:01:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731430AbfLKQBe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 11:01:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:36988 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731419AbfLKPN2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 10:13:28 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 65ACB2467A;
        Wed, 11 Dec 2019 15:13:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576077207;
        bh=RzNCs8S3ckMl0QtLvNUcHCyuJiZfIk4C+x/j7Srm+o8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PinAiwY1hgjCxBBb4fX2xzuURgVinm2o71+stSOC74qRzxaBxCAHveL7zLJTIyjsm
         xqpdAKoz3iQJ/7pq/u+nh38CPmGNAb4cL8gWzgzHAcbbbFgJq3yS0oUn8oe62/pclr
         P1xtyZ6PzMzlpoX9dXE88g9KVxOkB+lXvh2wwcds=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        Bastien Nocera <hadess@hadess.net>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 5.3 058/105] Input: goodix - add upside-down quirk for Teclast X89 tablet
Date:   Wed, 11 Dec 2019 16:05:47 +0100
Message-Id: <20191211150243.842708344@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191211150221.153659747@linuxfoundation.org>
References: <20191211150221.153659747@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

commit df5b5e555b356662a5e4a23c6774fdfce8547d54 upstream.

The touchscreen on the Teclast X89 is mounted upside down in relation to
the display orientation (the touchscreen itself is mounted upright, but the
display is mounted upside-down). Add a quirk for this so that we send
coordinates which match the display orientation.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Reviewed-by: Bastien Nocera <hadess@hadess.net>
Link: https://lore.kernel.org/r/20191202085636.6650-1-hdegoede@redhat.com
Cc: stable@vger.kernel.org
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/input/touchscreen/goodix.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/drivers/input/touchscreen/goodix.c
+++ b/drivers/input/touchscreen/goodix.c
@@ -127,6 +127,15 @@ static const unsigned long goodix_irq_fl
 static const struct dmi_system_id rotated_screen[] = {
 #if defined(CONFIG_DMI) && defined(CONFIG_X86)
 	{
+		.ident = "Teclast X89",
+		.matches = {
+			/* tPAD is too generic, also match on bios date */
+			DMI_MATCH(DMI_BOARD_VENDOR, "TECLAST"),
+			DMI_MATCH(DMI_BOARD_NAME, "tPAD"),
+			DMI_MATCH(DMI_BIOS_DATE, "12/19/2014"),
+		},
+	},
+	{
 		.ident = "WinBook TW100",
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "WinBook"),


