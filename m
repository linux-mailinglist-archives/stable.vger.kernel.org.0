Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B2132E3FE7
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:46:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732135AbgL1Opt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:45:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:59798 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2503057AbgL1OYV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:24:21 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 067C922D04;
        Mon, 28 Dec 2020 14:24:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609165446;
        bh=8VkzJDBeMi29PFDS0HI5w7Ul2rXmw/Asb617Y2dy6Sk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MOspK4wZb1kmqeZMfetx2i5reiIDOEH+ugsfJDPcQKXN9YdHoYLPnPi3v/yU9vZvq
         5wlnmmPVXH5GnVEQL2coUnHU8IxiKSYc9K0eowH8Xm7NxIDpdgbD7OpRFzMJLl6s+f
         ysDx5WdbXeDvqzxOOdVRufSXhMaJvgOmQQ/7Yvl4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Hui Wang <hui.wang@canonical.com>
Subject: [PATCH 5.10 534/717] ACPI: PNP: compare the string length in the matching_id()
Date:   Mon, 28 Dec 2020 13:48:52 +0100
Message-Id: <20201228125046.556137216@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hui Wang <hui.wang@canonical.com>

commit b08221c40febcbda9309dd70c61cf1b0ebb0e351 upstream.

Recently we met a touchscreen problem on some Thinkpad machines, the
touchscreen driver (i2c-hid) is not loaded and the touchscreen can't
work.

An i2c ACPI device with the name WACF2200 is defined in the BIOS, with
the current rule in matching_id(), this device will be regarded as
a PNP device since there is WACFXXX in the acpi_pnp_device_ids[] and
this PNP device is attached to the acpi device as the 1st
physical_node, this will make the i2c bus match fail when i2c bus
calls acpi_companion_match() to match the acpi_id_table in the i2c-hid
driver.

WACF2200 is an i2c device instead of a PNP device, after adding the
string length comparing, the matching_id() will return false when
matching WACF2200 and WACFXXX, and it is reasonable to compare the
string length when matching two IDs.

Suggested-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Hui Wang <hui.wang@canonical.com>
Cc: All applicable <stable@vger.kernel.org>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/acpi/acpi_pnp.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/acpi/acpi_pnp.c
+++ b/drivers/acpi/acpi_pnp.c
@@ -319,6 +319,9 @@ static bool matching_id(const char *idst
 {
 	int i;
 
+	if (strlen(idstr) != strlen(list_id))
+		return false;
+
 	if (memcmp(idstr, list_id, 3))
 		return false;
 


