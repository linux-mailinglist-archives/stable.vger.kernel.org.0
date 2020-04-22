Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 209F21B4306
	for <lists+stable@lfdr.de>; Wed, 22 Apr 2020 13:20:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726327AbgDVLUD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Apr 2020 07:20:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725787AbgDVLUD (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Apr 2020 07:20:03 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC5BAC03C1A8
        for <stable@vger.kernel.org>; Wed, 22 Apr 2020 04:20:02 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id k1so1933412wrx.4
        for <stable@vger.kernel.org>; Wed, 22 Apr 2020 04:20:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=VpbOaOtIIxM0qlnpSC/R72ufsSNvdYgk1tUvm25+WkY=;
        b=Up71fCq/12rTkyAKtdTiL7TNSD552dl6adsx/5ZCNZ8Mg68v3T2hAvfTkJY+ihpJfk
         QUQfdmOIH7UlWjyRzqYRo5sIK+5SmSUUvdoIkwOmJ/XXcuPg3SjXhcGDzhpj2G9piufh
         ikZwVPLVr1l8ovDs32iLmSTZFNoepP6s/5YT5mORcR2/43/PjUsku+bFKP+F9h6zZGZh
         c1zU4lZzpZ/k1rYj9fV9HJCKkik3NMeUTrBRjKkxkzmtfMQkIRV79c62loWEBsuWTkC2
         W2+PMSMiQqRmE9mKqP0mECGpehrOdXZ1cjlyeL5zcdDb/L+ahVNxi5NhZAcx6l6w78L4
         4/wA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=VpbOaOtIIxM0qlnpSC/R72ufsSNvdYgk1tUvm25+WkY=;
        b=ZagtBxhJZHxuGq+3HSHREMNlD824NNoospgSXBcUygF29OeiDujlK7y1TWB48NFHcW
         SZXZhXe1oittjjVqkEHySycqlP+eTtUpx1lv4r/46jQywmFINuuVYEkjSKQo6CMIT/h6
         iCb3v0X3aNxBfAerueI1NPcUOL7glid4wvHq9CKcctCiAm13l8o/Oz+kJbEMt1dDVRme
         uTU6oyEQMJ6SO8Zr0+X9itGk12IpQOyC5g8tR+4lCNSZc36jItmIuzJEB6gXlB7F+C+p
         eSR+1uGt3cMGrHnGzuSlNPqoLfY5Tuw/czXq2nyL4UMJmsR3BjByqhscTSYE0MEGuujU
         ISXQ==
X-Gm-Message-State: AGi0PuaRQKxACZAt2EXKfauiKqyMYleQsf4SaobnaDSshtZnuew+dypU
        RHz1PS4wrpGBavM02F3G4FyTNgM+pHE=
X-Google-Smtp-Source: APiQypK+dG/rkQlWAlhg7CG42Zd//x1+KFY+U4SXZaFL9ZnIM40ps/SzodjqF/2pcyORFQHVvlZiQg==
X-Received: by 2002:a05:6000:10:: with SMTP id h16mr29074471wrx.295.1587554401365;
        Wed, 22 Apr 2020 04:20:01 -0700 (PDT)
Received: from localhost.localdomain ([2.31.163.63])
        by smtp.gmail.com with ESMTPSA id n6sm8247255wrs.81.2020.04.22.04.20.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Apr 2020 04:20:00 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     stable@vger.kernel.org
Cc:     Taniya Das <tdas@codeaurora.org>, Stephen Boyd <sboyd@kernel.org>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 4.9 01/21] clk: qcom: rcg: Return failure for RCG update
Date:   Wed, 22 Apr 2020 12:19:37 +0100
Message-Id: <20200422111957.569589-2-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200422111957.569589-1-lee.jones@linaro.org>
References: <20200422111957.569589-1-lee.jones@linaro.org>
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
index d8601b138dc1e..29abb600d7e15 100644
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

