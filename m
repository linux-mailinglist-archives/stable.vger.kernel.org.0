Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E51D272E28
	for <lists+stable@lfdr.de>; Mon, 21 Sep 2020 18:46:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729743AbgIUQqs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Sep 2020 12:46:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:52978 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727333AbgIUQqf (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Sep 2020 12:46:35 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7F1AE2223E;
        Mon, 21 Sep 2020 16:46:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600706795;
        bh=pKSsipCzyCNmft1hAUmQoYh2br4qEHGJ8HzT9uh/vvs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MJd0cyVu5cpXSh2rRNkhqkInFgDkHHL+DCQKlb6RNt5kqyYkC9pv6BnsDxZFvu6W7
         fXOdtRScX+Iq8yHHx1WWIbIaBPMUYdF2fYU5jSBA+ypGXVFOkRzA03pXcIP49mu5Ey
         qve2oN9Ef+nBoLbby5M4tyafpBzaP6/YJdtKGQoI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: [PATCH 5.8 098/118] thunderbolt: Retry DROM read once if parsing fails
Date:   Mon, 21 Sep 2020 18:28:30 +0200
Message-Id: <20200921162040.925938340@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200921162036.324813383@linuxfoundation.org>
References: <20200921162036.324813383@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mika Westerberg <mika.westerberg@linux.intel.com>

commit f022ff7bf377ca94367be05de61277934d42ea74 upstream.

Kai-Heng reported that sometimes DROM parsing of ASUS PA27AC Thunderbolt 3
monitor fails. This makes the driver to fail to add the device so only
DisplayPort tunneling is functional.

It is not clear what exactly happens but waiting for 100 ms and retrying
the read seems to work this around so we do that here.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=206493
Reported-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
Tested-by: Kai-Heng Feng <kai.heng.feng@canonical.com>
Cc: stable@vger.kernel.org
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/thunderbolt/eeprom.c |   20 ++++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)

--- a/drivers/thunderbolt/eeprom.c
+++ b/drivers/thunderbolt/eeprom.c
@@ -7,6 +7,7 @@
  */
 
 #include <linux/crc32.h>
+#include <linux/delay.h>
 #include <linux/property.h>
 #include <linux/slab.h>
 #include "tb.h"
@@ -389,8 +390,8 @@ static int tb_drom_parse_entries(struct
 		struct tb_drom_entry_header *entry = (void *) (sw->drom + pos);
 		if (pos + 1 == drom_size || pos + entry->len > drom_size
 				|| !entry->len) {
-			tb_sw_warn(sw, "drom buffer overrun, aborting\n");
-			return -EIO;
+			tb_sw_warn(sw, "DROM buffer overrun\n");
+			return -EILSEQ;
 		}
 
 		switch (entry->type) {
@@ -526,7 +527,8 @@ int tb_drom_read(struct tb_switch *sw)
 	u16 size;
 	u32 crc;
 	struct tb_drom_header *header;
-	int res;
+	int res, retries = 1;
+
 	if (sw->drom)
 		return 0;
 
@@ -611,7 +613,17 @@ parse:
 		tb_sw_warn(sw, "drom device_rom_revision %#x unknown\n",
 			header->device_rom_revision);
 
-	return tb_drom_parse_entries(sw);
+	res = tb_drom_parse_entries(sw);
+	/* If the DROM parsing fails, wait a moment and retry once */
+	if (res == -EILSEQ && retries--) {
+		tb_sw_warn(sw, "parsing DROM failed, retrying\n");
+		msleep(100);
+		res = tb_drom_read_n(sw, 0, sw->drom, size);
+		if (!res)
+			goto parse;
+	}
+
+	return res;
 err:
 	kfree(sw->drom);
 	sw->drom = NULL;


