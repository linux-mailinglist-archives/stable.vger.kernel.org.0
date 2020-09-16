Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ABAEF26BFFF
	for <lists+stable@lfdr.de>; Wed, 16 Sep 2020 11:00:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726643AbgIPJAk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Sep 2020 05:00:40 -0400
Received: from mga01.intel.com ([192.55.52.88]:59022 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726349AbgIPJAi (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 16 Sep 2020 05:00:38 -0400
IronPort-SDR: ezjXa9dDyZSvU1zbt7NPyEPocv5reXWevzXe0yeR7g66qq9JXjwFSEsLprFM83cGZc/012WAaa
 O4SMEyiTo+fA==
X-IronPort-AV: E=McAfee;i="6000,8403,9745"; a="177500631"
X-IronPort-AV: E=Sophos;i="5.76,432,1592895600"; 
   d="scan'208";a="177500631"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Sep 2020 02:00:37 -0700
IronPort-SDR: H9NdyXG4B3WLSCpcf5HOGEyAsANotDSIOZeyds4BnezyKilj3wmgpI1xNed/1C9eesbCmNXSoO
 IId4xflZ1Ylw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,432,1592895600"; 
   d="scan'208";a="409487537"
Received: from black.fi.intel.com (HELO black.fi.intel.com.) ([10.237.72.28])
  by fmsmga001.fm.intel.com with ESMTP; 16 Sep 2020 02:00:36 -0700
From:   Heikki Krogerus <heikki.krogerus@linux.intel.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-usb@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH 1/2] usb: typec: ucsi: acpi: Increase command completion timeout value
Date:   Wed, 16 Sep 2020 12:00:33 +0300
Message-Id: <20200916090034.25119-2-heikki.krogerus@linux.intel.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200916090034.25119-1-heikki.krogerus@linux.intel.com>
References: <20200916090034.25119-1-heikki.krogerus@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

UCSI specification quite clearly states that if a command
can't be completed in 10ms, the firmware must notify
about BUSY condition. Unfortunately almost none of the
platforms (the firmware on them) generate the BUSY
notification even if a command can't be completed in time.

The driver already considered that, and used a timeout
value of 5 seconds, but processing especially the alternate
mode discovery commands takes often considerable amount of
time from the firmware, much more than the 5 seconds. That
happens especially after bootup when devices are already
connected to the USB Type-C connector. For now on those
platforms the alternate mode discovery has simply failed
because of the timeout.

To improve the situation, increasing the timeout value for
the command completion to 1 minute. That should give enough
time for even the slowest firmware to process the commands.

Fixes: f56de278e8ec ("usb: typec: ucsi: acpi: Move to the new API")
Cc: stable@vger.kernel.org
Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
---
 drivers/usb/typec/ucsi/ucsi_acpi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/typec/ucsi/ucsi_acpi.c b/drivers/usb/typec/ucsi/ucsi_acpi.c
index c0aca2f0f23f0..fbfe8f5933af8 100644
--- a/drivers/usb/typec/ucsi/ucsi_acpi.c
+++ b/drivers/usb/typec/ucsi/ucsi_acpi.c
@@ -78,7 +78,7 @@ static int ucsi_acpi_sync_write(struct ucsi *ucsi, unsigned int offset,
 	if (ret)
 		goto out_clear_bit;
 
-	if (!wait_for_completion_timeout(&ua->complete, msecs_to_jiffies(5000)))
+	if (!wait_for_completion_timeout(&ua->complete, 60 * HZ))
 		ret = -ETIMEDOUT;
 
 out_clear_bit:
-- 
2.28.0

