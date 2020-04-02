Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B60A219C988
	for <lists+stable@lfdr.de>; Thu,  2 Apr 2020 21:13:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389163AbgDBTNC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Apr 2020 15:13:02 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:50841 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731823AbgDBTNC (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Apr 2020 15:13:02 -0400
Received: by mail-wm1-f66.google.com with SMTP id t128so4650350wma.0
        for <stable@vger.kernel.org>; Thu, 02 Apr 2020 12:13:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=rt76xR7KCVj8t8WANztjelIE43d3cCKEcT2bybKep5k=;
        b=vdhl7RG65QkLd56P2xNIATgDzItLicAdqcRt9S8C7amJ2/n3KuHOb7s0sSy7YYg6cT
         G8ncdezJR8t4jldMxZ3/Fwe599Bolu+foA6tjmlDFwSgIZXkhKyZPuA3piwzWtrFPNZq
         LFsK2Jthr8FVya1CRZ3SHakdnQ7xqdATOnnukglgjOgkK8+Ec/9Q4WKvHFTFtxCUsYg7
         JicoSmPdDmBsPr0oMSKuSUUqO3QRiZvW/pmxcc7GQ6zlK0fWhlbISYUp+Zk+XVbc0D1t
         6iLWN0SlAKFc/nGm2CgDkf4foFl0YGuRJy242gk5OMiaRr15WDWBrxafWh9RS1BPGuBP
         yFjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=rt76xR7KCVj8t8WANztjelIE43d3cCKEcT2bybKep5k=;
        b=K5dSOuLb2UquZqm6Plbto0678nsI5u9JRpsd5/TlCFTnXrq1QI0NKhD5y/0VTEwD6m
         Tjg7Auwpy3NOTfNaJ3Gp/cbNdUEPxFjpD+qnrlV6QlCZQpT3sUlQUf6UNC94Ibvh4R0H
         kBhv+9IsGkO/ZoA0gXuz6ok2XNlUCqauAGeMEjPV8i6nY774bZZcpXnGLU16jQVCuYJV
         c3dVLNZwG6FtFONDpK/eGysEmgGg9PtUrooCiZiL3gpBViffsNZ4SrxP1/zc263elhAG
         zmfHsR2UeVdGtw6Q8bnLYCo3MYcQ/dh+gQ+X8enTVjTyckUBsYi3ZDP1W3VHSCafhOP6
         lxUw==
X-Gm-Message-State: AGi0PuZGKIxku097fTQicuKxE12NfGyK7vup+o0UhKzvpdGxPSWdOUaq
        FKlPfUgpvzW2bRVUpYLw0PWYKQTOXl8Shw==
X-Google-Smtp-Source: APiQypL9/kQvjFmn3da8fvkxcLqjuTzZK3UJE7VlWzMMllb3XVacHRSfDbRRbOIRA9S/3QCNkBiDxA==
X-Received: by 2002:a1c:2506:: with SMTP id l6mr4664059wml.44.1585854780205;
        Thu, 02 Apr 2020 12:13:00 -0700 (PDT)
Received: from localhost.localdomain ([95.149.164.95])
        by smtp.gmail.com with ESMTPSA id y12sm5511514wrn.55.2020.04.02.12.12.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Apr 2020 12:12:59 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     stable@vger.kernel.org
Subject: [PATCH 4.14 01/33] clk: qcom: rcg: Return failure for RCG update
Date:   Thu,  2 Apr 2020 20:13:21 +0100
Message-Id: <20200402191353.787836-1-lee.jones@linaro.org>
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
index a93439242565d..2e23f8754f8ed 100644
--- a/drivers/clk/qcom/clk-rcg2.c
+++ b/drivers/clk/qcom/clk-rcg2.c
@@ -112,7 +112,7 @@ static int update_config(struct clk_rcg2 *rcg)
 	}
 
 	WARN(1, "%s: rcg didn't update its configuration.", name);
-	return 0;
+	return -EBUSY;
 }
 
 static int clk_rcg2_set_parent(struct clk_hw *hw, u8 index)
-- 
2.25.1

