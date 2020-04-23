Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA66B1B65A3
	for <lists+stable@lfdr.de>; Thu, 23 Apr 2020 22:40:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726412AbgDWUki (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Apr 2020 16:40:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726183AbgDWUkh (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Apr 2020 16:40:37 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8CFBC09B042
        for <stable@vger.kernel.org>; Thu, 23 Apr 2020 13:40:36 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id d17so8211686wrg.11
        for <stable@vger.kernel.org>; Thu, 23 Apr 2020 13:40:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=p8LWrxA6zH1zzzzc2lI1WXxhrFnCRfVsxR9GFJcBEoQ=;
        b=qzl7mpFrbjeZB94qSH/xoq2QylZ2NFJfLTNgTV5rmHm2ztuuKgMu71h05bpegVoPsX
         kHSNqLYDWwBmtxuStT4gfX9MGINTa7RCnGHD2DFlbPKbq9eN95gO4UZchkK0Qa3y0bxs
         VheBQfAivwoStEe427sqRNfrXm4c+YT+gbQQ9QQA9teJmThEoVqkja1Cv/bca8bbRy0K
         oWFDejRT7rmWErS0WaTkBik7dbBe2WoziUk3VFtwXhQuCOuRxNetGkeLI1hlhEBmP1AN
         CPuuOCQ9R9XhQK9OnCNRqx+9tp+X+IzR3Z4Iw/AIx2K27OwEEa0YSawU/hhT4yC0dCQp
         fhXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=p8LWrxA6zH1zzzzc2lI1WXxhrFnCRfVsxR9GFJcBEoQ=;
        b=p7YC4y8Gwcn9vHSxnIlTmXhx8nZ9z8U48SfIlCKuLid2v0QVQHHjhRosFgLc7S7yYI
         QPsMs2Lc4zEJm94RWshpUpYZ/nS9IlGUDnuax1FcfuHWZu29A9bALAxZ4ZKsMnSmcbqi
         hQPGN3eTi9rHs+sVTgz6Q/gbsGC+ZdWQ7qiKxRbW1YaSR7iPUAXpLPES3MEraTTjYPbj
         jAqwtbB4teZMSNcDh0tqTx/onl++Wq81KYLNHKdAN92+NOavJVaJkqC/o7ZDfCgIMVAf
         /mJv//MzuW8Ou3Rd+LFeaqpV7GOs0DU5o6RoP+NZb63D4UA93rW2/a8R9p4eM7v228bk
         2wmg==
X-Gm-Message-State: AGi0Pua5+fnBd/JP4nSXg9UOYiZwulSvCDyvGWEOMbmVdSHhQGO6MTK7
        Pz4h5+9Zlegwk1l979dXuqJhcml2qY0=
X-Google-Smtp-Source: APiQypKLlR8JfNOkjuq4x40i8jDUayp1OeewxYQUTQL8nuLwjpIaHP3yoGt9X/IAQgaA+9YotPZZjw==
X-Received: by 2002:adf:dbce:: with SMTP id e14mr6433003wrj.337.1587674435467;
        Thu, 23 Apr 2020 13:40:35 -0700 (PDT)
Received: from localhost.localdomain ([2.31.163.63])
        by smtp.gmail.com with ESMTPSA id u17sm5933726wra.63.2020.04.23.13.40.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Apr 2020 13:40:34 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     stable@vger.kernel.org
Cc:     Chris Lew <clew@codeaurora.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Andy Gross <andy.gross@linaro.org>,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 4.4 14/16] soc: qcom: smem: Use le32_to_cpu for comparison
Date:   Thu, 23 Apr 2020 21:40:12 +0100
Message-Id: <20200423204014.784944-15-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200423204014.784944-1-lee.jones@linaro.org>
References: <20200423204014.784944-1-lee.jones@linaro.org>
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
index 19019aa092e86..a1572075b8acc 100644
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

