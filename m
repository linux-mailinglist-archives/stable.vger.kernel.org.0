Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EB83D19C9D0
	for <lists+stable@lfdr.de>; Thu,  2 Apr 2020 21:20:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388757AbgDBTSF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Apr 2020 15:18:05 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:56213 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728452AbgDBTSF (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Apr 2020 15:18:05 -0400
Received: by mail-wm1-f65.google.com with SMTP id r16so4628704wmg.5
        for <stable@vger.kernel.org>; Thu, 02 Apr 2020 12:18:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Gww7ZWZZzzTgIH1NABGXfQvWuKronr667Izz47F9iEE=;
        b=PUWez78LxxCXO2HEAFZ6lL0rNKBCd1Vb6mC1D0JqYQNZcmPM53mW7HHgaQm+L3B/+8
         /qhMHNEaofOYj/zW8MoviuTwIkaHageLp+Il/guJtYHjhmxfYOq8dsyE63GlxroOVNBA
         mD7pVfn8CvhI2DGpy697Oajv5kXb19gDpUGA14AhR6Q8UHMJXOIH2QerqgAn+1Up/U/F
         uJdyDCH7iyaP1EDk5d3uPZEb97aUwOok5l5Ubir1cKnpb0LZq8J/YvnGjXj2457qmsbJ
         FvZyGb8mf7VFM/YA6AuiH3UqvAtEOLi6rjq71ujYdwBOyUJUiY+z/FjQKOckh/4BwgIA
         hB2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Gww7ZWZZzzTgIH1NABGXfQvWuKronr667Izz47F9iEE=;
        b=GHI7MSksaaYbglYBBuoXOToyfRZXCcz/MGAmtZOzvX7FU3FGcocEazsSqWQEDBURCx
         nRJv7vV79WhYLn5ym9qAEjwmeefGVIS6UhinZigYC72OBw4ILKsB1WV5upGSu2DH/hzd
         6nFildwSTSvnmF5vUuTYfrqnXc1/AGtNzAYMIow2D0JiZ5oM2lxFbTZnuYgNYJGWl45l
         K0dTz/2hoIYwQAvAtlJh4+PoZeks0NDJnZBC7aCLei7jAf++8h/ZzCOvSfVAziOBAwMx
         8GVz3inVZV6zSFQWr6GvlO5jbkO89yORNnxhZTB65h+7+ntJAggR2jLp6Qfx7+5hQOs0
         IRJw==
X-Gm-Message-State: AGi0Pua0KqDEOroYnwDY0kxblNiDwLIzliG0Jl5+Leuyb91N+MtT4D3W
        YNxsuVQEQ9pmTHlZtROqQFsll2/N9Fs81Q==
X-Google-Smtp-Source: APiQypJtgWrO8cAMDq3rZS793qe68mS74ucxAA5lCI46i9EuyNwjWh/8j2p+hlS88UCDrojUQhXIcQ==
X-Received: by 2002:a1c:3105:: with SMTP id x5mr5035328wmx.51.1585855083347;
        Thu, 02 Apr 2020 12:18:03 -0700 (PDT)
Received: from localhost.localdomain ([95.149.164.95])
        by smtp.gmail.com with ESMTPSA id l10sm8622707wrq.95.2020.04.02.12.18.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Apr 2020 12:18:02 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     stable@vger.kernel.org
Subject: [PATCH 4.4 01/20] clk: qcom: rcg: Return failure for RCG update
Date:   Thu,  2 Apr 2020 20:18:37 +0100
Message-Id: <20200402191856.789622-1-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Taniya Das <tdas@codeaurora.org>

[ Upstream commit 21ea4b62e1f3dc258001a68da98c9663a9dbd6c7 ]

In case of update config failure, return -EBUSY, so that consumers could
handle the failure gracefully.

Signed-off-by: Taniya Das <tdas@codeaurora.org>
Link: https://lkml.kernel.org/r/1557339895-21952-2-git-send-email-tdas@codeaurora.org
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/clk/qcom/clk-rcg2.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/qcom/clk-rcg2.c b/drivers/clk/qcom/clk-rcg2.c
index 350a01f748706..f7f31da1d6305 100644
--- a/drivers/clk/qcom/clk-rcg2.c
+++ b/drivers/clk/qcom/clk-rcg2.c
@@ -107,7 +107,7 @@ static int update_config(struct clk_rcg2 *rcg)
 	}
 
 	WARN(1, "%s: rcg didn't update its configuration.", name);
-	return 0;
+	return -EBUSY;
 }
 
 static int clk_rcg2_set_parent(struct clk_hw *hw, u8 index)
-- 
2.25.1

