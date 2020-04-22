Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F54A1B4317
	for <lists+stable@lfdr.de>; Wed, 22 Apr 2020 13:20:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726823AbgDVLUa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Apr 2020 07:20:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726732AbgDVLU3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Apr 2020 07:20:29 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35AE8C03C1A8
        for <stable@vger.kernel.org>; Wed, 22 Apr 2020 04:20:29 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id j2so1909670wrs.9
        for <stable@vger.kernel.org>; Wed, 22 Apr 2020 04:20:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Da4R2mObgWasMS/Jsu1LIg5EJg09QgEbjMnbzzaCLcM=;
        b=ZP49y3jPHLaBshweMq0PPTy+4/EwyWklEVqVBCDdf9mKDpm5zkiCJtiAdfmFV+1ATZ
         yaMw73D1brHHXX57zcccvxQMxhkiNkNWrvDikl5N2G/X4H5R1Xty8e1XJnf0I5krzQ8K
         m5dMHGKkPAbxjBiRK1ctcP5Aa+1pj8+EnxoxmyR5aw980ndXtGok9+OcZUZBujCogKCq
         a7GhP5X8CSR+hgmwIShapGPpq7C2eXHaf/Ip5UrYasgLgfSmdMM/+S3FKOrEyM8nOBWL
         wZu9FuK31W5vALjmUdBSNEIhDwWkYuhO7c3ypWwSxNhKmXyKg7El62paR89ViKRcsZFk
         5cOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Da4R2mObgWasMS/Jsu1LIg5EJg09QgEbjMnbzzaCLcM=;
        b=e/hFNcmZuGttGG1tlrBUWD3Tai0v0rxIkri9wv51n/35bhPLWlQh2dg3NpYEMRtAiM
         3+3SY8+E2qAuGZgzjUMC3PQ5xqC7//PKZo8VRcFKdEKV6iYHS5Vve9trU8q0GbCQefgB
         hO4xxIVyuGql/cXSMZFwPbQOSsv2XFe7b+CzPfXJR6tZYRfgeod+DcSA6fNOy/oU3tim
         Znvi52Iiar4sWYpPE5Kii0hDUjxYdeppVHTjd0rSPG6sqCm8FgUlx/76ie7qaT/2s7Cg
         7bkimjsq2uFuNDlB71+9bRGPHQegjfyQrx/Qn2qkVjRpKPGao1Wdnaw63jAk5YmvU8DS
         RUOA==
X-Gm-Message-State: AGi0PubLq35eVhCB/lXPuPwZ/hRE15cWB5y3fKxT0Z9O+PyNqWkHc/dA
        1IbkIv7OapQ7zvh05gCz3Wz/yT8bFHg=
X-Google-Smtp-Source: APiQypLvjpKhGQmQgdSK3dSmaWPJDd3x9NNiIOSiVV+Gy7fuQQLz3F/0VPyWzDzLi1TK0GxuAe3vxw==
X-Received: by 2002:adf:f091:: with SMTP id n17mr28822655wro.200.1587554427703;
        Wed, 22 Apr 2020 04:20:27 -0700 (PDT)
Received: from localhost.localdomain ([2.31.163.63])
        by smtp.gmail.com with ESMTPSA id n6sm8247255wrs.81.2020.04.22.04.20.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Apr 2020 04:20:26 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     stable@vger.kernel.org
Cc:     Chris Lew <clew@codeaurora.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Andy Gross <andy.gross@linaro.org>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 4.9 18/21] soc: qcom: smem: Use le32_to_cpu for comparison
Date:   Wed, 22 Apr 2020 12:19:54 +0100
Message-Id: <20200422111957.569589-19-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200422111957.569589-1-lee.jones@linaro.org>
References: <20200422111957.569589-1-lee.jones@linaro.org>
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

