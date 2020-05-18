Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CE651D80CE
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 19:42:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729385AbgERRmK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 13:42:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:38988 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729382AbgERRmK (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 May 2020 13:42:10 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0087920715;
        Mon, 18 May 2020 17:42:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589823729;
        bh=gVrthYkBfN2ySYLVUTOzmheUD2ZPxexmzYV/khAHBVc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kOPEvOtYRyG1i5HhCro+HHy4gjSiKw/E6X5jS+xdkF7b+retIa3F6+TxBJxr6SStE
         9KSZGDMTkJ5or98cvLGoAfgC8gPlxI0s7o4oQy13tC12qTnaHQGdgrwp2vMh04/ipF
         Z3jwq4IAGNsrIDA681NINBxklO0eZfRv2hjbA88g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 4.9 13/90] Revert "ACPI / video: Add force_native quirk for HP Pavilion dv6"
Date:   Mon, 18 May 2020 19:35:51 +0200
Message-Id: <20200518173453.920984244@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200518173450.930655662@linuxfoundation.org>
References: <20200518173450.930655662@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

commit fd25ea29093e275195d0ae8b2573021a1c98959f upstream.

Revert commit 6276e53fa8c0 (ACPI / video: Add force_native quirk for
HP Pavilion dv6).

In the commit message for the quirk this revert removes I wrote:

"Note that there are quite a few HP Pavilion dv6 variants, some
woth ATI and some with NVIDIA hybrid gfx, both seem to need this
quirk to have working backlight control. There are also some versions
with only Intel integrated gfx, these may not need this quirk, but it
should not hurt there."

Unfortunately that seems wrong, I've already received 2 reports of
this commit causing regressions on some dv6 variants (at least one
of which actually has a nvidia GPU). So it seems that HP has made a
mess here by using the same model-name both in marketing and in the
DMI data for many different variants. Some of which need
acpi_backlight=native for functional backlight control (as the
quirk this commit reverts was doing), where as others are broken by
it. So lets get back to the old sitation so as to avoid regressing
on models which used to work without any kernel cmdline arguments
before.

Fixes: 6276e53fa8c0 (ACPI / video: Add force_native quirk for HP Pavilion dv6)
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Cc: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/acpi/video_detect.c |   11 -----------
 1 file changed, 11 deletions(-)

--- a/drivers/acpi/video_detect.c
+++ b/drivers/acpi/video_detect.c
@@ -314,17 +314,6 @@ static const struct dmi_system_id video_
 		DMI_MATCH(DMI_PRODUCT_NAME, "Dell System XPS L702X"),
 		},
 	},
-	{
-	/* https://bugzilla.redhat.com/show_bug.cgi?id=1204476 */
-	/* https://bugs.launchpad.net/ubuntu/+source/linux-lts-trusty/+bug/1416940 */
-	.callback = video_detect_force_native,
-	.ident = "HP Pavilion dv6",
-	.matches = {
-		DMI_MATCH(DMI_SYS_VENDOR, "Hewlett-Packard"),
-		DMI_MATCH(DMI_PRODUCT_NAME, "HP Pavilion dv6 Notebook PC"),
-		},
-	},
-
 	{ },
 };
 


