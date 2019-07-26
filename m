Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3CC4A7646F
	for <lists+stable@lfdr.de>; Fri, 26 Jul 2019 13:28:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726262AbfGZL23 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Jul 2019 07:28:29 -0400
Received: from mail-lj1-f194.google.com ([209.85.208.194]:35513 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726574AbfGZL22 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 26 Jul 2019 07:28:28 -0400
Received: by mail-lj1-f194.google.com with SMTP id x25so51210919ljh.2
        for <stable@vger.kernel.org>; Fri, 26 Jul 2019 04:28:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=qXAXo0fvFfroRZgYWsv3eTIS6UJVzpeVoAbknFGsjMk=;
        b=vhHmCUXbOqW0ShlZ/0VDIpjuqPN+yllwC23Y3r37PVgVfm8QzAufXGqQE2M+e3bBXW
         Sa6agtYW/J24tzUmmzQjuBIoBrEixhf2OJJIwLPQWd9lzYXcR2RWUkVbv4kyj5McBBh8
         VCM3fRX1y9DZW93ANmXw5P15g2/wydbxmnos6SrNyEQldDQEgLri8kEg4Rc43TnBR8aU
         AF47mTvHieO1vcSgJNotQg7LAhRptdA3m/4kyvTmUukb0G6X/fGd+q4RKWD6SqLlU4Ic
         PjQCc0/aPxCrzqEw94q1kEOcur207rRqjYV3LPtB5ntt2FqDgvmoASo8zndwPTG1O1JC
         GTgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=qXAXo0fvFfroRZgYWsv3eTIS6UJVzpeVoAbknFGsjMk=;
        b=SoREqCnkHveLjZ1Pn+FaR9W9U7CXMENksfkiGHyG/UuqV0fY8m0QColpLlnns1d1n0
         AqhQ8bv68rPDG1HCKdBzu1QvVMp9vRxqCYWu9T7i758elZMH1U4UTbWxtqB3lZ/3C8U8
         NsV1sukeaQVRtNnC84QXJmA/epQqcVZH1tVV/dEOGbmtmZ9D8GG8UUuG1W1QgaaduYRJ
         LPrKo2n1CMuejrlq4B+LlRFcipAMPlk+is8vfDfs9OvtluC1Jm7UOgezo5EKQtzJ4wXR
         epCB0Ty0/r69E0MygT9FLfvkJ56SspFSzaGTR68FW3UmTx7o+eSM5LM41F2n3K7xs7fF
         t3JQ==
X-Gm-Message-State: APjAAAVIx/9hC/ndFI1NJsw29Kf0yOHTaXSO+pi1bHwmTtaEza+Yvr+e
        S5GaVeSoEZu2IJFyNCY3wrlopA==
X-Google-Smtp-Source: APXvYqxRcpeZfOkhl+kP2goAmuAtJQrE6rFVOEMWhCTxNELXPLbMSsa8XPVrXecSGADSpL4vrWzCFA==
X-Received: by 2002:a2e:301a:: with SMTP id w26mr48094531ljw.76.1564140506079;
        Fri, 26 Jul 2019 04:28:26 -0700 (PDT)
Received: from localhost (c-243c70d5.07-21-73746f28.bbcust.telenor.se. [213.112.60.36])
        by smtp.gmail.com with ESMTPSA id s26sm10008774ljs.77.2019.07.26.04.28.25
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Fri, 26 Jul 2019 04:28:25 -0700 (PDT)
From:   Anders Roxell <anders.roxell@linaro.org>
To:     will@kernel.org, joro@8bytes.org
Cc:     linux-arm-kernel@lists.infradead.org,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        Anders Roxell <anders.roxell@linaro.org>,
        stable@vger.kernel.org
Subject: [PATCH] iommu: arm-smmu-v3: Mark expected switch fall-through
Date:   Fri, 26 Jul 2019 13:28:21 +0200
Message-Id: <20190726112821.19775-1-anders.roxell@linaro.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

When fall-through warnings was enabled by default, commit d93512ef0f0e
("Makefile: Globally enable fall-through warning"), the following
warning was starting to show up:

../drivers/iommu/arm-smmu-v3.c: In function ‘arm_smmu_write_strtab_ent’:
../drivers/iommu/arm-smmu-v3.c:1189:7: warning: this statement may fall
 through [-Wimplicit-fallthrough=]
    if (disable_bypass)
       ^
../drivers/iommu/arm-smmu-v3.c:1191:3: note: here
   default:
   ^~~~~~~

Rework so that the compiler doesn't warn about fall-through. Make it
clearer by calling 'BUG()' when disable_bypass is set, and always
'break;'

Cc: stable@vger.kernel.org # v4.2+
Fixes: 5bc0a11664e1 ("iommu/arm-smmu: Don't BUG() if we find aborting STEs with disable_bypass")
Signed-off-by: Anders Roxell <anders.roxell@linaro.org>
---
 drivers/iommu/arm-smmu-v3.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/iommu/arm-smmu-v3.c b/drivers/iommu/arm-smmu-v3.c
index a9a9fabd3968..8e5f0565996d 100644
--- a/drivers/iommu/arm-smmu-v3.c
+++ b/drivers/iommu/arm-smmu-v3.c
@@ -1186,8 +1186,9 @@ static void arm_smmu_write_strtab_ent(struct arm_smmu_master *master, u32 sid,
 			ste_live = true;
 			break;
 		case STRTAB_STE_0_CFG_ABORT:
-			if (disable_bypass)
-				break;
+			if (!disable_bypass)
+				BUG();
+			break;
 		default:
 			BUG(); /* STE corruption */
 		}
-- 
2.20.1

