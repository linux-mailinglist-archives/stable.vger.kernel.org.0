Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E149119C976
	for <lists+stable@lfdr.de>; Thu,  2 Apr 2020 21:11:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389086AbgDBTLb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Apr 2020 15:11:31 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:45828 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388862AbgDBTLa (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Apr 2020 15:11:30 -0400
Received: by mail-wr1-f65.google.com with SMTP id t7so5533382wrw.12
        for <stable@vger.kernel.org>; Thu, 02 Apr 2020 12:11:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=j0HDrtJ40KGmrEyhgHoOvV9sWkXPbMSoXXYHiNuzqAk=;
        b=eNn4Mp8oJ024yJBucYA9tWm9H0uF397pe4c8k4Uponeuvhb/AxEhgVGSaxdacnysZQ
         z3ZsF45MY3fpdqjI2m6rquBup8iVibJd9fh+7+LfgYWMeDts7R7LCDPUfJeW2wW4ayhA
         LSh1nL3rfTwT3Bqb6dJp9+uOwr6eUWrHOLslgzDFpi0b7CGUTk+RZdKAks42zJNCfC8e
         v3o9FKra619lN7zmjF+gHID/b7Cjq9C9zcsTZcp78xMcJBafvILNgm+6F496WN1znxZZ
         lBVGG7esAcvQ2c9ltmUhm5PYXaUoqt1txIAJhacRnxqNlD3BnUGJbccZDOE8hrSVYJ0J
         p09Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=j0HDrtJ40KGmrEyhgHoOvV9sWkXPbMSoXXYHiNuzqAk=;
        b=GWICX3y56eu9sYPR9dpfj5y7Ki6Pd4tRRAj/5Pr2JzxkIj3PWswjEU9dZoXSZkbpD7
         zbQd4bewjovCfzxwMcNB9pT/hPtZpr3fB3myfH62/0m/a7d9UR6oKWgf/HI1C7FZR+hq
         KIGjJcuQcGP5zycOLmq8jXUJVYv5pfM7HXcaoPhGEIfWijvfZhtevW0g+zDZiYFZJrpH
         5CsilOvQuNGBOnDJyzWm1nD4STrM3plyUdqOGzO4KMgXDpc9j66vYk2QxiiFaq3HSRRS
         fScXruWOkmitgJEunJez8PNt5Aw0LmYTINQolkTtfqMXmXyADQWjxU1J3WnHzrBcz7aD
         CSSw==
X-Gm-Message-State: AGi0Pub/INZqjrFzBRlJXpTGn9//NjZwJWbHYjmlvhJD+b5GBGaEtCoV
        IYe22vIx69Lm7PMjVDlYze6WBkgqGW8hpg==
X-Google-Smtp-Source: APiQypKjF2Hj85dBFTOHYy1Bf+xTgqi89lsutY9GXwH/nF3fcz97O+/NnXxITgLS75AUeVu8fB6u4w==
X-Received: by 2002:adf:f1c2:: with SMTP id z2mr5194765wro.40.1585854687383;
        Thu, 02 Apr 2020 12:11:27 -0700 (PDT)
Received: from localhost.localdomain ([95.149.164.95])
        by smtp.gmail.com with ESMTPSA id s15sm8442164wrt.16.2020.04.02.12.11.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Apr 2020 12:11:26 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     stable@vger.kernel.org
Subject: [PATCH 4.19 01/14] clk: qcom: rcg: Return failure for RCG update
Date:   Thu,  2 Apr 2020 20:12:07 +0100
Message-Id: <20200402191220.787381-1-lee.jones@linaro.org>
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
index ee693e15d9ebc..f420f0c968775 100644
--- a/drivers/clk/qcom/clk-rcg2.c
+++ b/drivers/clk/qcom/clk-rcg2.c
@@ -105,7 +105,7 @@ static int update_config(struct clk_rcg2 *rcg)
 	}
 
 	WARN(1, "%s: rcg didn't update its configuration.", name);
-	return 0;
+	return -EBUSY;
 }
 
 static int clk_rcg2_set_parent(struct clk_hw *hw, u8 index)
-- 
2.25.1

