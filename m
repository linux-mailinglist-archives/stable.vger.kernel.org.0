Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E37132E691A
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 17:47:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728323AbgL1Qoh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 11:44:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:53668 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728314AbgL1M5Q (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 07:57:16 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id EA5ED21D94;
        Mon, 28 Dec 2020 12:56:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609160196;
        bh=cRicDIf1s2m/epyd1+FFfQ5TZVTtW4rSXtzd0631iK0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=emSZyFGxI7bL8iBxbFiS1qzfs+GzC7rq+Qx+Rb8UivjbAQMbBNyB2p3NfIC0snBFE
         fjl70nIMjpiByZxpSa4JLKff+FR+LMOfBflzk3RHIhLb72piZ96n/Ac9GJk9lvmvvE
         HzVIXko96VMnANWFBILTbmkAKQYZsXBCXUo/y7nc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Hui Wang <hui.wang@canonical.com>
Subject: [PATCH 4.4 102/132] ACPI: PNP: compare the string length in the matching_id()
Date:   Mon, 28 Dec 2020 13:49:46 +0100
Message-Id: <20201228124851.349723624@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124846.409999325@linuxfoundation.org>
References: <20201228124846.409999325@linuxfoundation.org>
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
@@ -320,6 +320,9 @@ static bool matching_id(const char *idst
 {
 	int i;
 
+	if (strlen(idstr) != strlen(list_id))
+		return false;
+
 	if (memcmp(idstr, list_id, 3))
 		return false;
 


