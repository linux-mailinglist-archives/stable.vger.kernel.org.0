Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E37F51818F7
	for <lists+stable@lfdr.de>; Wed, 11 Mar 2020 14:00:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729409AbgCKNAL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Mar 2020 09:00:11 -0400
Received: from mga05.intel.com ([192.55.52.43]:34246 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729358AbgCKNAL (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Mar 2020 09:00:11 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 11 Mar 2020 06:00:11 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,540,1574150400"; 
   d="scan'208";a="353878525"
Received: from black.fi.intel.com (HELO black.fi.intel.com.) ([10.237.72.28])
  by fmsmga001.fm.intel.com with ESMTP; 11 Mar 2020 06:00:09 -0700
From:   Heikki Krogerus <heikki.krogerus@linux.intel.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Hans de Goede <hdegoede@redhat.com>, linux-usb@vger.kernel.org,
        stable@vger.kernel.org
Subject: [PATCH 1/2] usb: typec: ucsi: displayport: Fix NULL pointer dereference
Date:   Wed, 11 Mar 2020 16:00:05 +0300
Message-Id: <20200311130006.41288-2-heikki.krogerus@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200311130006.41288-1-heikki.krogerus@linux.intel.com>
References: <20200311130006.41288-1-heikki.krogerus@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

If the registration of the DisplayPort was not successful,
or if the port does not support DisplayPort alt mode in the
first place, the function ucsi_displayport_remove_partner()
will fail with NULL pointer dereference when it attempts to
access the driver data.

Adding a check to the function to make sure there really is
driver data for the device before modifying it.

Fixes: af8622f6a585 ("usb: typec: ucsi: Support for DisplayPort alt mode")
Reported-by: Andrea Gagliardi La Gala <andrea.lagala@gmail.com>
BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=206365
Cc: stable@vger.kernel.org
Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
---
 drivers/usb/typec/ucsi/displayport.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/usb/typec/ucsi/displayport.c b/drivers/usb/typec/ucsi/displayport.c
index 0f1273ae086c..261131c9e37c 100644
--- a/drivers/usb/typec/ucsi/displayport.c
+++ b/drivers/usb/typec/ucsi/displayport.c
@@ -271,6 +271,9 @@ void ucsi_displayport_remove_partner(struct typec_altmode *alt)
 		return;
 
 	dp = typec_altmode_get_drvdata(alt);
+	if (!dp)
+		return;
+
 	dp->data.conf = 0;
 	dp->data.status = 0;
 	dp->initialized = false;
-- 
2.25.1

