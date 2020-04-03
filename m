Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C166419D693
	for <lists+stable@lfdr.de>; Fri,  3 Apr 2020 14:18:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403904AbgDCMSg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Apr 2020 08:18:36 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:39008 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2403912AbgDCMSf (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Apr 2020 08:18:35 -0400
Received: by mail-wm1-f65.google.com with SMTP id e9so7455736wme.4
        for <stable@vger.kernel.org>; Fri, 03 Apr 2020 05:18:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=rizpshgRSVswJNtjW2UZ/pm8CNXM39+z2QpqQR8eHr8=;
        b=zy6PUgdiW27LUHIvvtmZQIoOr1E7bQ431qighQH04lqY+1ww5gv5l691mERZx7cO44
         C50dMOqm5V3moueQcvalZop4ISDjToL9Ul7OeDk1UPh/tGNK6c43q/DDXSqpykjGvd/9
         TWXsWhMzXq47uhY4tB+KkmqVIT4t8M08hfzHsi6XaR/UXLtAWZpGOX3ufAe1f8TEv41p
         D76p/kYkgcbVDTQdMsjW9wGNHF/9sOZVAfu/n7vbItS+ublm2Q21s6uhCl3ZjSCXPeyw
         jQn7eiqEDnwsxsydCDUSI4RoMPIIjV2bETcLGtbDFHRDeK6tvh7hH+OBq61XmiJhYqnL
         Tngg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rizpshgRSVswJNtjW2UZ/pm8CNXM39+z2QpqQR8eHr8=;
        b=IQabgYfGnoOfnxiVF2Xq7m6NCJtMPNxiAw8DTJMiF8D28Q2a74w+GJf6KN/SpVJ6uR
         5LaDiUldv6zPLSQhQz/GVjGiADOTHN2uKrDOZr+BdV33jpW0GwNxCYMzdY8F+eQYNUYy
         LTkB8SkRoxj0Xjr8WRTEqt56Q7kuq+SfgV4L/NA4JALcHdg/N/P4qMfifTXR3fACvcdV
         mSaTTVbPnyH6Z4T1MYoOYzuxOaO2XMOb+gOr6b/GkSrCYaywrPXHB4hocxaxeck7I07M
         cSaM5YfEkQIeqWsQZ8J8IxGbUU8SivrDdIAknJUvhqrqN5Bavln18imezJk/GNlWuPGp
         woWA==
X-Gm-Message-State: AGi0PuZJS3l+9Z6LfTKuJYoKlR0uqf7c8otAKaCOJM2xjwir0TWsADAe
        QT8oSI+Ovut0OxV0d+EeDHBuY8uqlWQ=
X-Google-Smtp-Source: APiQypIWiOrmKspD4fGPUs54NvOGOflYCfbgYv2wMgeva7Kxt/hlobCUyfAWn/951LmtM8K8ACbb6A==
X-Received: by 2002:a1c:9e42:: with SMTP id h63mr8002568wme.115.1585916311997;
        Fri, 03 Apr 2020 05:18:31 -0700 (PDT)
Received: from localhost.localdomain ([2.27.35.179])
        by smtp.gmail.com with ESMTPSA id l185sm11377712wml.44.2020.04.03.05.18.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Apr 2020 05:18:31 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     stable@vger.kernel.org
Cc:     Alexei Avshalom Lazar <ailizaro@codeaurora.org>,
        Maya Erez <merez@codeaurora.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 4.19 07/13] wil6210: add general initialization/size checks
Date:   Fri,  3 Apr 2020 13:18:53 +0100
Message-Id: <20200403121859.901838-8-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200403121859.901838-1-lee.jones@linaro.org>
References: <20200403121859.901838-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexei Avshalom Lazar <ailizaro@codeaurora.org>

[ Upstream commit ac0e541ab2f2951845acee784ef487be40fb4c77 ]

Initialize unset variable, and verify that mid is valid.

Signed-off-by: Alexei Avshalom Lazar <ailizaro@codeaurora.org>
Signed-off-by: Maya Erez <merez@codeaurora.org>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/net/wireless/ath/wil6210/debugfs.c | 2 ++
 drivers/net/wireless/ath/wil6210/wmi.c     | 2 +-
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/wil6210/debugfs.c b/drivers/net/wireless/ath/wil6210/debugfs.c
index 44296c0159252..acd95ca0430b9 100644
--- a/drivers/net/wireless/ath/wil6210/debugfs.c
+++ b/drivers/net/wireless/ath/wil6210/debugfs.c
@@ -991,6 +991,8 @@ static ssize_t wil_write_file_txmgmt(struct file *file, const char __user *buf,
 	int rc;
 	void *frame;
 
+	memset(&params, 0, sizeof(params));
+
 	if (!len)
 		return -EINVAL;
 
diff --git a/drivers/net/wireless/ath/wil6210/wmi.c b/drivers/net/wireless/ath/wil6210/wmi.c
index 8a603432f5317..3928b13ae0266 100644
--- a/drivers/net/wireless/ath/wil6210/wmi.c
+++ b/drivers/net/wireless/ath/wil6210/wmi.c
@@ -2802,7 +2802,7 @@ static void wmi_event_handle(struct wil6210_priv *wil,
 
 		if (mid == MID_BROADCAST)
 			mid = 0;
-		if (mid >= wil->max_vifs) {
+		if (mid >= ARRAY_SIZE(wil->vifs) || mid >= wil->max_vifs) {
 			wil_dbg_wmi(wil, "invalid mid %d, event skipped\n",
 				    mid);
 			return;
-- 
2.25.1

