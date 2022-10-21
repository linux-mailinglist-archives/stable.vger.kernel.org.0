Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10771607CE3
	for <lists+stable@lfdr.de>; Fri, 21 Oct 2022 18:54:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229608AbiJUQyV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Oct 2022 12:54:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231222AbiJUQxx (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 21 Oct 2022 12:53:53 -0400
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F336DB560;
        Fri, 21 Oct 2022 09:53:44 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id l16-20020a05600c4f1000b003c6c0d2a445so2429997wmq.4;
        Fri, 21 Oct 2022 09:53:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=D7USE7AcSD2YljcS61kNBptWjf/iLrS8g55c3sCGb5Y=;
        b=NWnooMotQFthGKv372Qu9SJBLRm/oAX/AuviKEsNRI2p2YWt6j8yleyRgwYR+BDmeE
         rVCZB05mibw5nfAH86+caUccRaOoRmYEe6fi4xonykx886oXK+MtgZpjqrGwO8c4j705
         IxVhP4NhYarzG+1/JE61XIvTMNKpllqwqu3S/Ji4p8fEYX1h2ExzeW4j1/qo/9zqy3zM
         J9rIKE26g2w4eCSDk519lzzmX4fUiiBrXRkL6kwLrn93BEotZZDrKQ8OiOZmHIqULddp
         DfEYIareszj9xkET2HCbMBDljv60wn7pYZO/Wn4DAFvMfs4/ImN44xK3xAWipZ18/h67
         OYww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=D7USE7AcSD2YljcS61kNBptWjf/iLrS8g55c3sCGb5Y=;
        b=Y+vqkHzja5d+ZTyvw2kiQxQwNhW4K1fzRZNP7p254vjN+aBnnuSG8CmZKNN+8WFpoH
         yV2uztPQmK6qXb386Al5f1pT8hTw8iO63d9euk5+wK5AWCniUM/qKY2qydN2DBnZJ9vu
         FFLbaRDjTckLfZJIsmaxRUovumATghkT9H+3BDEwURuLt/m2fphrSGwaD4ez3UZqhJWg
         t8vI0HE/j7tglyhaYqbtOy4dg+4wSjQZi3ewuaa6GQCrDUqM5FpED2fCVS1iCkgp8/CR
         ecl7pZ1YcC39x0HNuFshfsGHKkEaTg9nOfSe3/JeaS3OWTsH32VrObG5Cez4OmXCJYio
         gyaQ==
X-Gm-Message-State: ACrzQf3p331GErNpVq9pGcT4bIGIWBwX8hIQBIJlEkTWm6hnQzGZi/+P
        oMlS9lPzSIjCG4IXBde936vNZ9aEzCM=
X-Google-Smtp-Source: AMsMyM6/Nq4vjgilkRSoMe2QbfspmZeCAOdOstO79QV0k7bIX7XPsVdCW2Mw0iZJ3zw6btCR6hNVFA==
X-Received: by 2002:a05:600c:3108:b0:3c6:ff0a:c22 with SMTP id g8-20020a05600c310800b003c6ff0a0c22mr13609539wmo.25.1666371221909;
        Fri, 21 Oct 2022 09:53:41 -0700 (PDT)
Received: from localhost.localdomain (93-42-70-134.ip85.fastwebnet.it. [93.42.70.134])
        by smtp.googlemail.com with ESMTPSA id a15-20020adfeecf000000b00228692033dcsm18663234wrp.91.2022.10.21.09.53.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Oct 2022 09:53:41 -0700 (PDT)
From:   Christian Marangi <ansuelsmth@gmail.com>
To:     Manivannan Sadhasivam <mani@kernel.org>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Richard Weinberger <richard@nod.at>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Christian Marangi <ansuelsmth@gmail.com>,
        linux-mtd@lists.infradead.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: [PATCH] mtd: nand: raw: qcom_nandc: handle ret from parse with codeword_fixup
Date:   Fri, 21 Oct 2022 18:53:04 +0200
Message-Id: <20221021165304.19991-1-ansuelsmth@gmail.com>
X-Mailer: git-send-email 2.37.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

With use_codeword_fixup enabled, any return from
mtd_device_parse_register gets overwritten. Aside from the clear bug, this
is also problematic as a parser can EPROBE_DEFER and because this is not
correctly handled, the nand is never rescanned later in the bootup
process.

An example of this problem is when smem requires additional time to be
probed and nandc use qcomsmempart as parser. Parser will return
EPROBE_DEFER but in the current code this ret gets overwritten by
qcom_nand_host_parse_boot_partitions and qcom_nand_host_init_and_register
return 0.

Correctly handle the return code from mtd_device_parse_register so that
any error from this function is not ignored.

Fixes: 862bdedd7f4b ("mtd: nand: raw: qcom_nandc: add support for unprotected spare data pages")
Cc: stable@vger.kernel.org # v6.0+
Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
---
 drivers/mtd/nand/raw/qcom_nandc.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/mtd/nand/raw/qcom_nandc.c b/drivers/mtd/nand/raw/qcom_nandc.c
index 8f80019a9f01..198a44794d2d 100644
--- a/drivers/mtd/nand/raw/qcom_nandc.c
+++ b/drivers/mtd/nand/raw/qcom_nandc.c
@@ -3167,16 +3167,18 @@ static int qcom_nand_host_init_and_register(struct qcom_nand_controller *nandc,
 
 	ret = mtd_device_parse_register(mtd, probes, NULL, NULL, 0);
 	if (ret)
-		nand_cleanup(chip);
+		goto err;
 
 	if (nandc->props->use_codeword_fixup) {
 		ret = qcom_nand_host_parse_boot_partitions(nandc, host, dn);
-		if (ret) {
-			nand_cleanup(chip);
-			return ret;
-		}
+		if (ret)
+			goto err;
 	}
 
+	return 0;
+
+err:
+	nand_cleanup(chip);
 	return ret;
 }
 
-- 
2.37.2

