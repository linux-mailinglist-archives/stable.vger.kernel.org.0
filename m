Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EE675196F4E
	for <lists+stable@lfdr.de>; Sun, 29 Mar 2020 20:41:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727837AbgC2SlY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Mar 2020 14:41:24 -0400
Received: from mail-qk1-f193.google.com ([209.85.222.193]:40244 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727506AbgC2SlX (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 29 Mar 2020 14:41:23 -0400
Received: by mail-qk1-f193.google.com with SMTP id l25so16748664qki.7
        for <stable@vger.kernel.org>; Sun, 29 Mar 2020 11:41:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=3cGZvjYwHajcr93/tSPs0TDlTx6x2JxB8d17ydT2haw=;
        b=ur8/dTChczw/2YMx6il2YoL2xMeACDwyU6oBzNSgzAPySMneW5tyZPcdZVuKKISLpf
         QfFaMZgUpceaT+5bOpyZ/TSKUkpC+rxTtiMFvwg+pupVgsqryycVjAIfK1Yg8+ph/0bR
         h6ta6MQCuSIgxK4SAIzjfN1Gv8m+dYbbmfRzpKjvJzeXrLxsOfnSl1AiBgdJ8m3G7mo6
         nJ2sQf6IXC8/HxgoZfPFtGzI6R9frtoogMuE1HPjTUlgN2Pi4S/nn/oiovEYqZGyfRj3
         7X79fko9Y4nykPb8BMFBO0gdI/RZ+ATYnqgk7XTKVFXKs0bEPLh7pdX+39iFW5sdJGDN
         9sfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=3cGZvjYwHajcr93/tSPs0TDlTx6x2JxB8d17ydT2haw=;
        b=goU+YDWV7x/sBpzCDdA4xaVhZL9aUDkYinRGuzjrFjfmI/1EF7q2SV51nfScXBnixl
         CQAAQWUEfBb4A+9IdLf0twKqCZByL9XI2RldsT3mUlVAM1IiXCyqg9HdO4F8zgs1jC9s
         8ieVLcxgeXp0kof7Fgi+wW9cXJecufH3KtaiCNEq/aTQe6MVN8oY+2tiSYW7CuuDp8Mi
         Au4sxNCxTLfRl8dvOx/0/RmMtJ85mP/YB7oH+qOEhGzFveS9W4idDk0xQjomM7Cx/iwk
         yW63AutGLVLlT9RnCSHEpVP5GvogsqxQvwaJC+hXd47O5Kg56Y7Ofq604PB/qquET5Dn
         eiHw==
X-Gm-Message-State: ANhLgQ0vF55sib6LycXBXw5zAT0QGnCT4zdoF2LQNTrBsW3wB/VOsRpt
        v3IMK5ztE/bx7uiCbq5D17yCXa4e
X-Google-Smtp-Source: ADFU+vteeOcqmJElMOqZWf/7cW/ViPMoMcO/LWMqpDrXyBhQISI7vQtHalxph3JQraS0XwckPIaEpA==
X-Received: by 2002:a37:4852:: with SMTP id v79mr8253515qka.459.1585507282215;
        Sun, 29 Mar 2020 11:41:22 -0700 (PDT)
Received: from pm2-ws13.praxislan02.com ([2001:470:8:67e:ba27:ebff:fee8:ce27])
        by smtp.gmail.com with ESMTPSA id n142sm8490599qkn.11.2020.03.29.11.41.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 29 Mar 2020 11:41:21 -0700 (PDT)
From:   Jason Andryuk <jandryuk@gmail.com>
To:     stable@vger.kernel.org
Cc:     Johannes Berg <johannes.berg@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Jason Andryuk <jandryuk@gmail.com>
Subject: Stable request: iwlwifi: mvm: fix non-ACPI function
Date:   Sun, 29 Mar 2020 14:41:11 -0400
Message-Id: <20200329184111.17469-1-jandryuk@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johannes Berg <johannes.berg@intel.com>

commit 7937fd3227055892e169f4b34d21157e57d919e2 upstream.

The code now compiles without ACPI, but there's a warning since
iwl_mvm_get_ppag_table() isn't used, and iwl_mvm_ppag_init() must
not unconditionally fail but return success instead.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
[Drop hunk removing iwl_mvm_get_ppag_table() since it doesn't exist in
5.4]
Signed-off-by: Jason Andryuk <jandryuk@gmail.com>
---
A 5.4 kernel can't "up" an iwlwifi interface when CONFIG_ACPI=n.
`wpa_supplicant` or `ip link set wlan0 up` return "No such file or
directory".  The non-acpi stub iwl_mvm_ppag_init() always returns
-ENOENT which means iwl_mvm_up() always fails.  Backporting the commit
lets iwl_mvm_up() succeed.

 drivers/net/wireless/intel/iwlwifi/mvm/fw.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
index c59cbb8cbdd7..c54fe6650018 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
@@ -1181,7 +1181,7 @@ int iwl_mvm_ppag_send_cmd(struct iwl_mvm *mvm)
 
 static int iwl_mvm_ppag_init(struct iwl_mvm *mvm)
 {
-	return -ENOENT;
+	return 0;
 }
 #endif /* CONFIG_ACPI */
 
-- 
2.25.1

