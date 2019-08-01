Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 709F87D6B9
	for <lists+stable@lfdr.de>; Thu,  1 Aug 2019 09:55:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728843AbfHAHzP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Aug 2019 03:55:15 -0400
Received: from mga12.intel.com ([192.55.52.136]:27913 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726407AbfHAHzP (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 1 Aug 2019 03:55:15 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 01 Aug 2019 00:55:14 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,333,1559545200"; 
   d="scan'208";a="191563196"
Received: from black.fi.intel.com (HELO black.fi.intel.com.) ([10.237.72.28])
  by fmsmga001.fm.intel.com with ESMTP; 01 Aug 2019 00:55:13 -0700
From:   Heikki Krogerus <heikki.krogerus@linux.intel.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Ajay Gupta <ajayg@nvidia.com>, linux-usb@vger.kernel.org,
        stable@vger.kernel.org, kbuild test robot <lkp@intel.com>
Subject: [PATCH] usb: typec: ucsi: ccg: Fix uninitilized symbol error
Date:   Thu,  1 Aug 2019 10:55:12 +0300
Message-Id: <20190801075512.24354-1-heikki.krogerus@linux.intel.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Fix smatch error:
drivers/usb/typec/ucsi/ucsi_ccg.c:975 ccg_fw_update() error: uninitialized symbol 'err'.

Fixes: 5c9ae5a87573 ("usb: typec: ucsi: ccg: add firmware flashing support")
Cc: stable@vger.kernel.org
Reported-by: kbuild test robot <lkp@intel.com>
Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
---
 drivers/usb/typec/ucsi/ucsi_ccg.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/typec/ucsi/ucsi_ccg.c b/drivers/usb/typec/ucsi/ucsi_ccg.c
index f7a79a23ebed..8e9f8fba55af 100644
--- a/drivers/usb/typec/ucsi/ucsi_ccg.c
+++ b/drivers/usb/typec/ucsi/ucsi_ccg.c
@@ -1018,7 +1018,7 @@ static int do_flash(struct ucsi_ccg *uc, enum enum_flash_mode mode)
  ******************************************************************************/
 static int ccg_fw_update(struct ucsi_ccg *uc, enum enum_flash_mode flash_mode)
 {
-	int err;
+	int err = 0;
 
 	while (flash_mode != FLASH_NOT_NEEDED) {
 		err = do_flash(uc, flash_mode);
-- 
2.20.1

