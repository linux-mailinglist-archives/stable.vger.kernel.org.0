Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 279BE1B2671
	for <lists+stable@lfdr.de>; Tue, 21 Apr 2020 14:41:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728950AbgDUMlP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Apr 2020 08:41:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728929AbgDUMlN (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Apr 2020 08:41:13 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B316C061A10
        for <stable@vger.kernel.org>; Tue, 21 Apr 2020 05:41:13 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id u13so16304144wrp.3
        for <stable@vger.kernel.org>; Tue, 21 Apr 2020 05:41:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=9HCLRvGXYC5n1AHCqufnjpyrxqZW9cO7ygbPcIujNSw=;
        b=bwUQKGe56p+Rs1RmD/AiA06aHfBOlHOD6TKND4DIGz5FuxhdyaxYcYMUdi+6n1KULV
         tmSha+Nf83O+z3Kn0M07bmdK/Af2K5JSzbZgEdF+m9c0nVZJPndVzDqcSMXnMve6Fa+s
         zBQOV/rUC1BLg/cKBxkOnMYScyEjj4fA77H8qLXMa0cKTtPiJlq22iTZZl7DNCNC0qaN
         iCPqCQ4u+vnrRs/AWztinKX0IE6HWwivzFtP06IL/oh+CjlbLHdA/pXZJq0F6h3HTuh4
         zfkqvZGs0UyTLEOcHoekUfKhX+Rzty0Y8uZvO55/4oow+gNGB2uI+OTatjTxZnHh3bqu
         GgDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=9HCLRvGXYC5n1AHCqufnjpyrxqZW9cO7ygbPcIujNSw=;
        b=pdw55CL5TMV5+PtYFRMBFXwVfyGgtdIgsV0GXAo+ouSL9RJYqeFUSuUn0dIK+zgq6Y
         3yNsuWRcdVYmFBXz5XHyWzJjWoXUUeitFaKxouxW7Bnjr16d0Yq/E5onOg0bBXPzjX0C
         GkNP5BFAn0gjNGdkr9ZxK34ifhnmD5PtJrB42wr4CeVwMM/lQiU9zYLNdhvO7VaYD35M
         0gGm9Ww8w14Dz+CGYaZLAOMj3WveVx8YYmmSSfGMocn5f9S9kBsxGwEcZXxVMV+M7i+5
         vZNGDR5hlqxPJqrGF2dPfkdCnoOyE/5kiwWihukPA6LIhgQGgbABEdvgKStYa3zbLRlG
         8+OA==
X-Gm-Message-State: AGi0PuYe9FNVgvFjbs1IkubxeVrUZtWmrcaXyuMTxiI0+fU31e7dHiun
        X6jIp4Hg+eW5OS/6HC5QnmDPMT+MOaE=
X-Google-Smtp-Source: APiQypLOCU+TuG15DRz77enIi3nX5O4aw9mUl8N0ZM2hWbnm0tl9IWNalAbI0vJLd/nNtgvrGPVLRQ==
X-Received: by 2002:adf:b181:: with SMTP id q1mr5559173wra.414.1587472872093;
        Tue, 21 Apr 2020 05:41:12 -0700 (PDT)
Received: from localhost.localdomain ([2.31.163.63])
        by smtp.gmail.com with ESMTPSA id u3sm3408232wrt.93.2020.04.21.05.41.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Apr 2020 05:41:10 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     stable@vger.kernel.org
Cc:     Hamad Kadmany <qca_hkadmany@qca.qualcomm.com>,
        Maya Erez <qca_merez@qca.qualcomm.com>,
        Kalle Valo <kvalo@qca.qualcomm.com>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 4.14 21/24] wil6210: abort properly in cfg suspend
Date:   Tue, 21 Apr 2020 13:40:14 +0100
Message-Id: <20200421124017.272694-22-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200421124017.272694-1-lee.jones@linaro.org>
References: <20200421124017.272694-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hamad Kadmany <qca_hkadmany@qca.qualcomm.com>

[ Upstream commit 144a12a6d83f3ca34ddefce5dee4d502afd2fc5b ]

On-going operations were not aborted properly
and required locks were not taken.

Signed-off-by: Hamad Kadmany <qca_hkadmany@qca.qualcomm.com>
Signed-off-by: Maya Erez <qca_merez@qca.qualcomm.com>
Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/net/wireless/ath/wil6210/cfg80211.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/cfg80211.c b/drivers/net/wireless/ath/wil6210/cfg80211.c
index c374ed311520e..58784e77e215b 100644
--- a/drivers/net/wireless/ath/wil6210/cfg80211.c
+++ b/drivers/net/wireless/ath/wil6210/cfg80211.c
@@ -1735,9 +1735,12 @@ static int wil_cfg80211_suspend(struct wiphy *wiphy,
 
 	wil_dbg_pm(wil, "suspending\n");
 
-	wil_p2p_stop_discovery(wil);
-
+	mutex_lock(&wil->mutex);
+	mutex_lock(&wil->p2p_wdev_mutex);
+	wil_p2p_stop_radio_operations(wil);
 	wil_abort_scan(wil, true);
+	mutex_unlock(&wil->p2p_wdev_mutex);
+	mutex_unlock(&wil->mutex);
 
 out:
 	return rc;
-- 
2.25.1

