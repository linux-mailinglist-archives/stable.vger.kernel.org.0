Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B054F1391A
	for <lists+stable@lfdr.de>; Sat,  4 May 2019 12:30:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727312AbfEDK3h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 4 May 2019 06:29:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:36242 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727788AbfEDK0j (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 4 May 2019 06:26:39 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 000A020859;
        Sat,  4 May 2019 10:26:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556965598;
        bh=Sem2o+BRdo2MN41/QrjREvOG/W8x17nS6VM0QFnHptg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LTqL8DgNn3/zvrbD67ladwdlCG3GdVfrH4RKCrrHchVKc87GsfAMUpk7rtQPCdF0+
         MxaXGVlp2UgtunQyMdYnPR6rn6//2HwiFjURvWQgs8bHrwEMqBgSXWtRzkz533/Fd+
         9DoQbr7ClSoH3oKIa9pwACrNdHMJIEREDB4QvKQM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Laura Abbott <labbott@redhat.com>,
        Gabriel Ramirez <gabriello.ramirez@gmail.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Intel Linux Wireless <linuxwifi@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>
Subject: [PATCH 5.0 31/32] iwlwifi: mvm: properly check debugfs dentry before using it
Date:   Sat,  4 May 2019 12:25:16 +0200
Message-Id: <20190504102453.427675597@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190504102452.523724210@linuxfoundation.org>
References: <20190504102452.523724210@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

commit 154d4899e4111ae24e68d6ba955f46856cb046bc upstream.

debugfs can now report an error code if something went wrong instead of
just NULL.  So if the return value is to be used as a "real" dentry, it
needs to be checked if it is an error before dereferencing it.

This is now happening because of ff9fb72bc077 ("debugfs: return error
values, not NULL").  If multiple iwlwifi devices are in the system, this
can cause problems when the driver attempts to create the main debugfs
directory again.  Later on in the code we fail horribly by trying to
dereference a pointer that is an error value.

Reported-by: Laura Abbott <labbott@redhat.com>
Reported-by: Gabriel Ramirez <gabriello.ramirez@gmail.com>
Cc: Johannes Berg <johannes.berg@intel.com>
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Cc: Luca Coelho <luciano.coelho@intel.com>
Cc: Intel Linux Wireless <linuxwifi@intel.com>
Cc: Kalle Valo <kvalo@codeaurora.org>
Cc: stable <stable@vger.kernel.org> # 5.0
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/intel/iwlwifi/mvm/debugfs-vif.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/net/wireless/intel/iwlwifi/mvm/debugfs-vif.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/debugfs-vif.c
@@ -1482,6 +1482,11 @@ void iwl_mvm_vif_dbgfs_register(struct i
 		return;
 
 	mvmvif->dbgfs_dir = debugfs_create_dir("iwlmvm", dbgfs_dir);
+	if (IS_ERR_OR_NULL(mvmvif->dbgfs_dir)) {
+		IWL_ERR(mvm, "Failed to create debugfs directory under %pd\n",
+			dbgfs_dir);
+		return;
+	}
 
 	if (!mvmvif->dbgfs_dir) {
 		IWL_ERR(mvm, "Failed to create debugfs directory under %pd\n",


