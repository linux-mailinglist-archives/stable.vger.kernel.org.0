Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CB21519D68F
	for <lists+stable@lfdr.de>; Fri,  3 Apr 2020 14:18:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403879AbgDCMSa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Apr 2020 08:18:30 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:44891 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2403880AbgDCMSa (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Apr 2020 08:18:30 -0400
Received: by mail-wr1-f68.google.com with SMTP id m17so8224654wrw.11
        for <stable@vger.kernel.org>; Fri, 03 Apr 2020 05:18:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=j0HDrtJ40KGmrEyhgHoOvV9sWkXPbMSoXXYHiNuzqAk=;
        b=l81xwjYjI2QueesoBZZ3DFadQQMAwkXjqGhYZn41UPl7x8uO/smq1qtz+udltxKzeR
         B7Zf58VxRHtBBBcwulnBqivYQy6GwInU98IZeGsqwMSW0PdTkw4+z39oHgYK6rc9ncU/
         Ur4kuyi5GEgypU9diO+1VaP4aSNa1BuhOui0ZJ49K7wRpLHZFDQ5pfNrFRteuZRWTLwA
         5t44k2V0wqvIcW+YKsS0oOEKKo0zgE6FqlzlB4c2E7DyhjsrC7dp+G6F9Thms2vGVcqj
         V0J0WsnzhOzxmor2CfL38CMPH/zpXsuffT4rI99gIDYTkhvQ0OSmq6u5Lj0O3+NPWcOf
         Uaug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=j0HDrtJ40KGmrEyhgHoOvV9sWkXPbMSoXXYHiNuzqAk=;
        b=NoZ4vqF+DjPhr0LLgkFLc9P5cZ2lqoSOHKqSdRnhri2gwZZE4bxK/f8pOd1I5uispB
         2gwsOpf9BaitjwkPuAv0hS98D2Tr6r4Z5Mz0iGm75h6M+hiyp6PFbUmZHjKgeam1bn42
         DMLu3w+VTmbGRm1VQOUhZc7Ryp57PVgsGPXYGKbP1BNKslrU50/NbtUCEbsaTIPofATr
         3mEA0AwJ5Vq6D7JkVt1UhnVQnpuAi6P1doKRW2g4ArTgLYMvb9fuTDlrjPFW8bDdXZgv
         ulf7FCsdHogNEjkEdh23zPuv6hfYwp4qptgB06Sr40gF8ORau1TTeXX8YXxj1U6b17Zf
         Ka1A==
X-Gm-Message-State: AGi0PuZxB1RPF8NK5nAoLB+UI9FvtajNbD1+vpANdrDecdnKReHi5Z6r
        Y3i+Vbo4XIG75IGJ2rRajetuivlQlz8=
X-Google-Smtp-Source: APiQypL9PURqKI+7TJOmPdLEiZaidxWE9VMh2Z482i1QvR5phW8GA3kv7+ypbtb+TmaITjSaWxL9tA==
X-Received: by 2002:a5d:4081:: with SMTP id o1mr9064608wrp.114.1585916306312;
        Fri, 03 Apr 2020 05:18:26 -0700 (PDT)
Received: from localhost.localdomain ([2.27.35.179])
        by smtp.gmail.com with ESMTPSA id l185sm11377712wml.44.2020.04.03.05.18.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Apr 2020 05:18:25 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     stable@vger.kernel.org
Cc:     Taniya Das <tdas@codeaurora.org>, Stephen Boyd <sboyd@kernel.org>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 4.19 01/13] clk: qcom: rcg: Return failure for RCG update
Date:   Fri,  3 Apr 2020 13:18:47 +0100
Message-Id: <20200403121859.901838-2-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200403121859.901838-1-lee.jones@linaro.org>
References: <20200403121859.901838-1-lee.jones@linaro.org>
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

