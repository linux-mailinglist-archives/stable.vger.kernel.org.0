Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0683F1B2675
	for <lists+stable@lfdr.de>; Tue, 21 Apr 2020 14:41:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728944AbgDUMlV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Apr 2020 08:41:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728479AbgDUMlP (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Apr 2020 08:41:15 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7C92C061A10
        for <stable@vger.kernel.org>; Tue, 21 Apr 2020 05:41:14 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id k13so15102976wrw.7
        for <stable@vger.kernel.org>; Tue, 21 Apr 2020 05:41:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Da4R2mObgWasMS/Jsu1LIg5EJg09QgEbjMnbzzaCLcM=;
        b=cfm5bh5+WTSPytGHjGPUJ0xIeaYazUaXDTjT1h0f4ojkeM2CfDrTn2hu2KumLmL3R+
         YRqg8c8qmM4OWjylPCQ/+mDklMAn61t6mqsxpKKWXrc3J04Wrflek065b+HwjGXcjhJm
         k+SPpH5RTrdmQyFJDS5FoVUQpAnn2RAhHu8ZfuNTEiGxOR/qzBzYmbgSx6krlpiYHO8F
         01WJU4NJv5qbFkbvmPo8FtOLEtVfum5ITW20u+7tsKJZcKysb9JFm6Xhf2nnzZVGmI1S
         tP4WeVJ9iD/lpsrFmMCzqGsGfMsMUn8Nqsl7ITYV1uFw0qWPIHEgfnsuL6/OXlnHcSdb
         pdpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Da4R2mObgWasMS/Jsu1LIg5EJg09QgEbjMnbzzaCLcM=;
        b=gOaLQR1Fs7it1zded7/mUW0w67vkP7N+u1R8Kv2QDpfpWEzSxqZKKTXH46NxVQ7GbK
         r0kf0d+LBmMpd1SQ8UkZDjlPg440j3ENuiMBL7jr7Estg6bnllnb8ggmh1aBRKEZ3z0A
         6aTLgQHNNjxzF7lJbLZRu307x8Uo584DICJ7k0ZnZk6B3P8XFLwyYsahr9xcXOn0hwy0
         ElUKVHxkA5IaCCdA6yCO8dA3EZXifNcM9gf58kaGDwzgT5694IEZ0aS5VmBLemS7kw7q
         QMPInJJW8+PyYfEiLHxrst+i5WMt1OEjl/daR0GXJXj6QPjebCleRMPx+bri2wHAgpC/
         6VcA==
X-Gm-Message-State: AGi0PuZmRuTTbeXw33uBRjzdGrAkBWik5PId2Aeo+1T4crsVYR262REg
        Uiw/nUtShpjIaiv42r+KzwI3fAAaOPE=
X-Google-Smtp-Source: APiQypLqVRssaGuoiTTAv7EZP41lJzzzOapQ16xuZM77Oco3TNym+1iFlig4NjM5UQxklR2fgjyNWA==
X-Received: by 2002:a05:6000:128d:: with SMTP id f13mr24895347wrx.241.1587472873368;
        Tue, 21 Apr 2020 05:41:13 -0700 (PDT)
Received: from localhost.localdomain ([2.31.163.63])
        by smtp.gmail.com with ESMTPSA id u3sm3408232wrt.93.2020.04.21.05.41.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Apr 2020 05:41:12 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     stable@vger.kernel.org
Cc:     Chris Lew <clew@codeaurora.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Andy Gross <andy.gross@linaro.org>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 4.14 22/24] soc: qcom: smem: Use le32_to_cpu for comparison
Date:   Tue, 21 Apr 2020 13:40:15 +0100
Message-Id: <20200421124017.272694-23-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200421124017.272694-1-lee.jones@linaro.org>
References: <20200421124017.272694-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chris Lew <clew@codeaurora.org>

[ Upstream commit a216000f0140f415cec96129f777b5234c9d142f ]

Endianness can vary in the system, add le32_to_cpu when comparing
partition sizes from smem.

Signed-off-by: Chris Lew <clew@codeaurora.org>
Acked-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Signed-off-by: Andy Gross <andy.gross@linaro.org>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/soc/qcom/smem.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/soc/qcom/smem.c b/drivers/soc/qcom/smem.c
index 18ec52f2078aa..89dd50fa404f7 100644
--- a/drivers/soc/qcom/smem.c
+++ b/drivers/soc/qcom/smem.c
@@ -646,7 +646,7 @@ static int qcom_smem_enumerate_partitions(struct qcom_smem *smem,
 			return -EINVAL;
 		}
 
-		if (header->size != entry->size) {
+		if (le32_to_cpu(header->size) != le32_to_cpu(entry->size)) {
 			dev_err(smem->dev,
 				"Partition %d has invalid size\n", i);
 			return -EINVAL;
-- 
2.25.1

