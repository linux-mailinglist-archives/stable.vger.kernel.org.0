Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B45FC1818F9
	for <lists+stable@lfdr.de>; Wed, 11 Mar 2020 14:00:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729428AbgCKNAN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Mar 2020 09:00:13 -0400
Received: from mga05.intel.com ([192.55.52.43]:34246 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729358AbgCKNAN (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Mar 2020 09:00:13 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 11 Mar 2020 06:00:13 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,540,1574150400"; 
   d="scan'208";a="353878533"
Received: from black.fi.intel.com (HELO black.fi.intel.com.) ([10.237.72.28])
  by fmsmga001.fm.intel.com with ESMTP; 11 Mar 2020 06:00:11 -0700
From:   Heikki Krogerus <heikki.krogerus@linux.intel.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Hans de Goede <hdegoede@redhat.com>, linux-usb@vger.kernel.org,
        stable@vger.kernel.org
Subject: [PATCH 2/2] usb: typec: ucsi: displayport: Fix a potential race during registration
Date:   Wed, 11 Mar 2020 16:00:06 +0300
Message-Id: <20200311130006.41288-3-heikki.krogerus@linux.intel.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200311130006.41288-1-heikki.krogerus@linux.intel.com>
References: <20200311130006.41288-1-heikki.krogerus@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Locking the connector in ucsi_register_displayport() to make
sure that nothing can access the displayport alternate mode
before the function has finished and the alternate mode is
actually ready.

Fixes: af8622f6a585 ("usb: typec: ucsi: Support for DisplayPort alt mode")
Cc: stable@vger.kernel.org
Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
---
 drivers/usb/typec/ucsi/displayport.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/typec/ucsi/displayport.c b/drivers/usb/typec/ucsi/displayport.c
index 261131c9e37c..048381c058a5 100644
--- a/drivers/usb/typec/ucsi/displayport.c
+++ b/drivers/usb/typec/ucsi/displayport.c
@@ -288,6 +288,8 @@ struct typec_altmode *ucsi_register_displayport(struct ucsi_connector *con,
 	struct typec_altmode *alt;
 	struct ucsi_dp *dp;
 
+	mutex_lock(&con->lock);
+
 	/* We can't rely on the firmware with the capabilities. */
 	desc->vdo |= DP_CAP_DP_SIGNALING | DP_CAP_RECEPTACLE;
 
@@ -296,12 +298,15 @@ struct typec_altmode *ucsi_register_displayport(struct ucsi_connector *con,
 	desc->vdo |= all_assignments << 16;
 
 	alt = typec_port_register_altmode(con->port, desc);
-	if (IS_ERR(alt))
+	if (IS_ERR(alt)) {
+		mutex_unlock(&con->lock);
 		return alt;
+	}
 
 	dp = devm_kzalloc(&alt->dev, sizeof(*dp), GFP_KERNEL);
 	if (!dp) {
 		typec_unregister_altmode(alt);
+		mutex_unlock(&con->lock);
 		return ERR_PTR(-ENOMEM);
 	}
 
@@ -314,5 +319,7 @@ struct typec_altmode *ucsi_register_displayport(struct ucsi_connector *con,
 	alt->ops = &ucsi_displayport_ops;
 	typec_altmode_set_drvdata(alt, dp);
 
+	mutex_unlock(&con->lock);
+
 	return alt;
 }
-- 
2.25.1

