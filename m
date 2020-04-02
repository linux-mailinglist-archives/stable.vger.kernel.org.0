Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 01C3119C9A4
	for <lists+stable@lfdr.de>; Thu,  2 Apr 2020 21:13:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388986AbgDBTNb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Apr 2020 15:13:31 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:39093 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388905AbgDBTNb (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Apr 2020 15:13:31 -0400
Received: by mail-wr1-f65.google.com with SMTP id p10so5579805wrt.6
        for <stable@vger.kernel.org>; Thu, 02 Apr 2020 12:13:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=Da4R2mObgWasMS/Jsu1LIg5EJg09QgEbjMnbzzaCLcM=;
        b=ycK9u6LPBIteLzkcnAoHj733wH90dKai/4ixwJ3xdPZ0Mq5pYnmuYgH2hSE0wgfyBM
         W0h5VwFkMdX+u39orAJWKTLHegypPpFUW891KO47TpEKX2/3kEvmmOZClpMeSoihoOMx
         BG6gp3OLI4Kz+gKba6oY9NeBewjvhGdn19HwwVqyYWfyWAGzzSvHtocGblPdl8pGQ/Td
         jsyn/eKgM6WYuVj4K0YzPBJph9928cc+sjQrtXOj6fSe+5tp7WS20daQhV/N9rqlfSOj
         fHt6ydXR+R7KUNnmLOY43v6ND1UEu80tdroAUog0P53QIm3tm1dNlda5FJRNJu1lZpo3
         MzMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Da4R2mObgWasMS/Jsu1LIg5EJg09QgEbjMnbzzaCLcM=;
        b=UW8LNWEoqv13HU1uOnoc0lFxzRTL3R/P61hRu/E/5DoUW1E6clrky3bliDvTCMYeSI
         ZULP0kGySWxaByJ4qsv56H9qPTvxBmFFsPC9i3iPRIvKcZg3i1rPW2H5Bpz//ce5uoDI
         OPfqVfS8VVKlJ7V85DggIqthO6HhNKZOpiyAqoDqn6h3kuFIsTtPfgvqsaSpmMXD5Nrg
         wdKR0fNUkV/7CrHrkihO6Td/drH6pme5Zbj2nhrLXyJqsy3casFgi8yEiOD4tJ3zHne9
         woFZVQPgb+2OyHDdCG1VbzTvSBkVkh16Arb8o/Rpz5c+CT7/NC3YNw+swVRYGgFwJ9VZ
         fOZA==
X-Gm-Message-State: AGi0PubCQM6W4yr4KgvUQMzIX/6puA00C5JkuYIh45OIgD6lZ9Q/zmp6
        1YMcJ3rRqY3Ai56jFG2We/mRwu4UOP7Oug==
X-Google-Smtp-Source: APiQypJE4rWMOJ2u8ktNKEAOZYmx2MJUljGy/Y3gbDZ+Y3bwsCcNwDuOZ8xfzz2DRkadi9RNojoVYg==
X-Received: by 2002:adf:fe87:: with SMTP id l7mr4741867wrr.377.1585854807514;
        Thu, 02 Apr 2020 12:13:27 -0700 (PDT)
Received: from localhost.localdomain ([95.149.164.95])
        by smtp.gmail.com with ESMTPSA id y12sm5511514wrn.55.2020.04.02.12.13.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Apr 2020 12:13:26 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     stable@vger.kernel.org
Subject: [PATCH 4.14 28/33] soc: qcom: smem: Use le32_to_cpu for comparison
Date:   Thu,  2 Apr 2020 20:13:48 +0100
Message-Id: <20200402191353.787836-28-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200402191353.787836-1-lee.jones@linaro.org>
References: <20200402191353.787836-1-lee.jones@linaro.org>
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

