Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2993726BEED
	for <lists+stable@lfdr.de>; Wed, 16 Sep 2020 10:16:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726438AbgIPIQ0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Sep 2020 04:16:26 -0400
Received: from mga18.intel.com ([134.134.136.126]:38799 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726068AbgIPIQX (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 16 Sep 2020 04:16:23 -0400
IronPort-SDR: wSkkgmturhWz/e4uts/0lsX9KISZ07sE8CkgLvmQwfJXqLZjPx/LqI4PLIOYPsRBALHVnAMgiL
 vxJ4p9NgZWDQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9745"; a="147174209"
X-IronPort-AV: E=Sophos;i="5.76,432,1592895600"; 
   d="scan'208";a="147174209"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Sep 2020 01:16:21 -0700
IronPort-SDR: 0d+xUJ6M7woc2aePHGbyg8VcHoXobaqWxPZJfKRAQSuCddaXfWKPXA6Hs7x/5CbImo4ByBJKBR
 h3dkJeale2Iw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.76,432,1592895600"; 
   d="scan'208";a="409471835"
Received: from black.fi.intel.com (HELO black.fi.intel.com.) ([10.237.72.28])
  by fmsmga001.fm.intel.com with ESMTP; 16 Sep 2020 01:16:19 -0700
From:   Heikki Krogerus <heikki.krogerus@linux.intel.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     "Mani, Rajmohan" <rajmohan.mani@intel.com>,
        linux-usb@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCH 1/5] usb: typec: ucsi: acpi: Increase command completion timeout value
Date:   Wed, 16 Sep 2020 11:16:13 +0300
Message-Id: <20200916081617.17146-2-heikki.krogerus@linux.intel.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200916081617.17146-1-heikki.krogerus@linux.intel.com>
References: <20200916081617.17146-1-heikki.krogerus@linux.intel.com>
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

