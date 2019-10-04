Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 75D60CB7CF
	for <lists+stable@lfdr.de>; Fri,  4 Oct 2019 12:02:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730856AbfJDKCZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 4 Oct 2019 06:02:25 -0400
Received: from mga02.intel.com ([134.134.136.20]:15524 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726927AbfJDKCZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 4 Oct 2019 06:02:25 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 04 Oct 2019 03:02:25 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,256,1566889200"; 
   d="scan'208";a="205821755"
Received: from black.fi.intel.com (HELO black.fi.intel.com.) ([10.237.72.28])
  by fmsmga001.fm.intel.com with ESMTP; 04 Oct 2019 03:02:23 -0700
From:   Heikki Krogerus <heikki.krogerus@linux.intel.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Ajay Gupta <ajayg@nvidia.com>, linux-usb@vger.kernel.org,
        stable@vger.kernel.org
Subject: [PATCH 2/2] usb: typec: ucsi: displayport: Fix for the mode entering routine
Date:   Fri,  4 Oct 2019 13:02:19 +0300
Message-Id: <20191004100219.71152-3-heikki.krogerus@linux.intel.com>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191004100219.71152-1-heikki.krogerus@linux.intel.com>
References: <20191004100219.71152-1-heikki.krogerus@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Making sure that ucsi_displayport_enter() function does not
return an error if the displayport alternate mode has
already been entered. It's normal that the firmware (or
controller) has already entered the alternate mode by the
time the operating system is notified about the device.

Fixes: af8622f6a585 ("usb: typec: ucsi: Support for DisplayPort alt mode")
Cc: stable@vger.kernel.org
Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
---
 drivers/usb/typec/ucsi/displayport.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/usb/typec/ucsi/displayport.c b/drivers/usb/typec/ucsi/displayport.c
index 6c103697c582..d99700cb4dca 100644
--- a/drivers/usb/typec/ucsi/displayport.c
+++ b/drivers/usb/typec/ucsi/displayport.c
@@ -75,6 +75,8 @@ static int ucsi_displayport_enter(struct typec_altmode *alt)
 
 	if (cur != 0xff) {
 		mutex_unlock(&dp->con->lock);
+		if (dp->con->port_altmode[cur] == alt)
+			return 0;
 		return -EBUSY;
 	}
 
-- 
2.23.0

