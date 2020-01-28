Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1C21514BB91
	for <lists+stable@lfdr.de>; Tue, 28 Jan 2020 15:48:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726716AbgA1OsB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jan 2020 09:48:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:49446 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727762AbgA1OC5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Jan 2020 09:02:57 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3E33E24685;
        Tue, 28 Jan 2020 14:02:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580220176;
        bh=HAplMGVFy+W3R6NQP5ZdvVfho2qbadRcoi09lYnwgsU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N0sge5TdKPK+5spg+5TwAY430IkEYw4fsTWa2prx45m205+m5GYCHJnQNzM9gdXd/
         tZoGhsNSl5p44rjbvUTcXQR9kzUQQzxArRKlCsMtmnOCwcc0EGseeGrvESW+7o6mFN
         NYaLc1y3s/YxsDcsLXL7PuhRWGugi/wJWcKNDNCg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mehmet Akif Tasova <makiftasova@gmail.com>,
        Luca Coelho <luciano.coelho@intel.com>
Subject: [PATCH 5.4 048/104] Revert "iwlwifi: mvm: fix scan config command size"
Date:   Tue, 28 Jan 2020 15:00:09 +0100
Message-Id: <20200128135824.326907454@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200128135817.238524998@linuxfoundation.org>
References: <20200128135817.238524998@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mehmet Akif Tasova <makiftasova@gmail.com>

commit 205608749e1ef394f513888091e613c5bfccbcca upstream.

Since v5.4-rc1 was released, iwlwifi started throwing errors when scan
commands were sent to the firmware with certain devices (depending on
the OTP burned in the device, which contains the list of available
channels).  For instance:

iwlwifi 0000:00:14.3: FW error in SYNC CMD SCAN_CFG_CMD

This bug was reported in the ArchLinux bug tracker:
https://bugs.archlinux.org/task/64703

And also in a specific case in bugzilla, when the lar_disabled option
was set: https://bugzilla.kernel.org/show_bug.cgi?id=205193

Revert the commit that introduced this error, by using the number of
channels from the OTP instead of the number of channels that is
specified in the FW TLV that tells us how many channels it supports.

This reverts commit 06eb547c4ae4382e70d556ba213d13c95ca1801b.

Cc: stable@vger.kernel.org # v5.4+
Signed-off-by: Mehmet Akif Tasova <makiftasova@gmail.com>
[ Luca: reworded the commit message a bit. ]
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/intel/iwlwifi/mvm/scan.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/scan.c
@@ -1220,7 +1220,7 @@ static int iwl_mvm_legacy_config_scan(st
 		cmd_size = sizeof(struct iwl_scan_config_v2);
 	else
 		cmd_size = sizeof(struct iwl_scan_config_v1);
-	cmd_size += num_channels;
+	cmd_size += mvm->fw->ucode_capa.n_scan_channels;
 
 	cfg = kzalloc(cmd_size, GFP_KERNEL);
 	if (!cfg)


