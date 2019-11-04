Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 624F9EEDB0
	for <lists+stable@lfdr.de>; Mon,  4 Nov 2019 23:09:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390341AbfKDWJL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Nov 2019 17:09:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:42206 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389912AbfKDWJK (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Nov 2019 17:09:10 -0500
Received: from localhost (6.204-14-84.ripe.coltfrance.com [84.14.204.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9DAAD214D9;
        Mon,  4 Nov 2019 22:09:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572905350;
        bh=d11sopKfzpOkYe5kN+ObEO6qxaUWsS4eeR8/fg6kiik=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ReD0Hz5tyGPBJUVQ4BLnZ5D5T0aRj0HU187YpPLPdNZk6sDiHblUwXEmFEQFjF97R
         cAWK0za6f3e8ogiQMjKRZQVwfuMdLV0SMWe4v46nkKfG9a+WJYAFNTO2eWWByK1Uxr
         vPNi0ZhFmSBozf/9D4NPJk87ndBpG6SHo7+9+glo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>
Subject: [PATCH 5.3 115/163] HID: i2c-hid: add Trekstor Primebook C11B to descriptor override
Date:   Mon,  4 Nov 2019 22:45:05 +0100
Message-Id: <20191104212148.565050393@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191104212140.046021995@linuxfoundation.org>
References: <20191104212140.046021995@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

commit 09f3dbe474735df13dd8a66d3d1231048d9b373f upstream.

The Primebook C11B uses the SIPODEV SP1064 touchpad. There are 2 versions
of this 2-in-1 and the touchpad in the older version does not supply
descriptors, so it has to be added to the override list.

Cc: stable@vger.kernel.org
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/hid/i2c-hid/i2c-hid-dmi-quirks.c |   19 +++++++++++++++++++
 1 file changed, 19 insertions(+)

--- a/drivers/hid/i2c-hid/i2c-hid-dmi-quirks.c
+++ b/drivers/hid/i2c-hid/i2c-hid-dmi-quirks.c
@@ -323,6 +323,25 @@ static const struct dmi_system_id i2c_hi
 		.driver_data = (void *)&sipodev_desc
 	},
 	{
+		/*
+		 * There are at least 2 Primebook C11B versions, the older
+		 * version has a product-name of "Primebook C11B", and a
+		 * bios version / release / firmware revision of:
+		 * V2.1.2 / 05/03/2018 / 18.2
+		 * The new version has "PRIMEBOOK C11B" as product-name and a
+		 * bios version / release / firmware revision of:
+		 * CFALKSW05_BIOS_V1.1.2 / 11/19/2018 / 19.2
+		 * Only the older version needs this quirk, note the newer
+		 * version will not match as it has a different product-name.
+		 */
+		.ident = "Trekstor Primebook C11B",
+		.matches = {
+			DMI_EXACT_MATCH(DMI_SYS_VENDOR, "TREKSTOR"),
+			DMI_EXACT_MATCH(DMI_PRODUCT_NAME, "Primebook C11B"),
+		},
+		.driver_data = (void *)&sipodev_desc
+	},
+	{
 		.ident = "Direkt-Tek DTLAPY116-2",
 		.matches = {
 			DMI_EXACT_MATCH(DMI_SYS_VENDOR, "Direkt-Tek"),


