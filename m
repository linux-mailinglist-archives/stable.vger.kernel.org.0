Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5CBF119C9D9
	for <lists+stable@lfdr.de>; Thu,  2 Apr 2020 21:20:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389416AbgDBTSP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Apr 2020 15:18:15 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:37886 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389476AbgDBTSP (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Apr 2020 15:18:15 -0400
Received: by mail-wm1-f66.google.com with SMTP id j19so4955631wmi.2
        for <stable@vger.kernel.org>; Thu, 02 Apr 2020 12:18:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=2pZHt+hAsIb+Y7qJYHv626ADWtS8jmmdGfuI//hKgVk=;
        b=H8xgYwRy0V5ociFSvzK9Ef2e3PbyPsYvRB7DuergysBYp1W08YOpFDTQhsr/9t4NY9
         6AoXtDMIm7dBl2RSTmRkFeurCHAqQPgmKgR0Sx4WLxzeMVPviL4efYFkzLvA94bu+DlB
         veR+k9lb1zUgBGJ9WR2plosZGG0t+FV/3yJxtcwfF2B/O3b8xN9ibtTSKRznU7OFR2Z+
         iVc10nibAz6aM2F0FkAeGZzJd1Hb8MCD3ha9Wz0SA3bOVbUe8JR83YWBwX4hF6yVXMHw
         4gljvDUvh1hdxhnqYPmmQNT5luyotnAi3VCVB+QpLRleSZPtNbi/Xz/YdfzUwKE8pclK
         K5ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2pZHt+hAsIb+Y7qJYHv626ADWtS8jmmdGfuI//hKgVk=;
        b=evjC9JX2fYAeRnhxZONvCAHo4FADuqavSHwzIrv39R0PSqI57GDaQk85wFqUtvMSwA
         anPZdzE8v37rJwi+X40tvoewTU+gO2XM+Mm47aQy4XLRganY0I1CmlQ+6PWGrcnFOXtb
         DIVB7E8u0AF6v7BfQNxkogFSilCf8hXGrU/tNAuDQqlb7TpqonrBOtwnmbEtHa4UJvca
         4ArGZzY58QdH3cpwPaJfigSH1BZtx9l9ur79cs9ueai8Ez6eWX6VnG35Sl90NMRJLEkG
         f1MUyLqjSpa/B5pRPdjE3Z2sEkEyFAU11MdHAiAEIzzPa7ZUY60BlaPVLX6DBt+rg52E
         YsEg==
X-Gm-Message-State: AGi0PubAIBni9TymMbcAGRUz8Db/KHs9pjF11uc8PTeJggP6wo38jB2H
        fdl9FnkYLTtgqEyQEyiu9nJd4QYj9J4+Bg==
X-Google-Smtp-Source: APiQypLqKCRkWUW0vDiZ41xZo/IMnHiltquyUKsEN5/qj3iaTrg3bR/QOYtr2lvkywNg83rYxVlSpw==
X-Received: by 2002:a7b:c76d:: with SMTP id x13mr4840397wmk.146.1585855093453;
        Thu, 02 Apr 2020 12:18:13 -0700 (PDT)
Received: from localhost.localdomain ([95.149.164.95])
        by smtp.gmail.com with ESMTPSA id l10sm8622707wrq.95.2020.04.02.12.18.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Apr 2020 12:18:12 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     stable@vger.kernel.org
Subject: [PATCH 4.4 11/20] wil6210: increase firmware ready timeout
Date:   Thu,  2 Apr 2020 20:18:47 +0100
Message-Id: <20200402191856.789622-11-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200402191856.789622-1-lee.jones@linaro.org>
References: <20200402191856.789622-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hamad Kadmany <hkadmany@codeaurora.org>

[ Upstream commit 6ccae584014ef7074359eb4151086beef66ecfa9 ]

Firmware ready event may take longer than
current timeout in some scenarios, for example
with multiple RFs connected where each
requires an initial calibration.

Increase the timeout to support these scenarios.

Signed-off-by: Hamad Kadmany <hkadmany@codeaurora.org>
Signed-off-by: Maya Erez <merez@codeaurora.org>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/net/wireless/ath/wil6210/main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/wil6210/main.c b/drivers/net/wireless/ath/wil6210/main.c
index f09fafaaaf1a3..c377937aae1c4 100644
--- a/drivers/net/wireless/ath/wil6210/main.c
+++ b/drivers/net/wireless/ath/wil6210/main.c
@@ -741,7 +741,7 @@ static void wil_bl_crash_info(struct wil6210_priv *wil, bool is_err)
 
 static int wil_wait_for_fw_ready(struct wil6210_priv *wil)
 {
-	ulong to = msecs_to_jiffies(1000);
+	ulong to = msecs_to_jiffies(2000);
 	ulong left = wait_for_completion_timeout(&wil->wmi_ready, to);
 
 	if (0 == left) {
-- 
2.25.1

