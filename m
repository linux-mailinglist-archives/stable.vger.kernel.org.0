Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ECE575BA1F8
	for <lists+stable@lfdr.de>; Thu, 15 Sep 2022 22:49:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229676AbiIOUtE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Sep 2022 16:49:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229497AbiIOUtD (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 15 Sep 2022 16:49:03 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF26A9AFC3;
        Thu, 15 Sep 2022 13:49:02 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id z21so28745065edi.1;
        Thu, 15 Sep 2022 13:49:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=k8iJ7L9yaA7qD0s2nB5tW0Kqk0H2NxzybAr7hwW0qQ8=;
        b=Gt7WXplca5WSGjFg8coRd5SWUVMnfGgQ1FpG6lk28KeHhcPKsC6SCG3MwF1hCqd6v5
         siQSRouNdzko/OR9BWe3hk13CE8On8O13XWxocmI7fCoJX1+mUI0e5pxPfF+gfLX4QJN
         PfDrkyauVy+UAvKlV9zsBA1AFR5SGUVnFUoXTDc1dMiZcPOFqD2SL/k2uNVgHo7skDvJ
         +WwsRGGKIm4ZsqK9UoyW9NoKoeUD5C1sXhJi9IF585eYpkoOwDyA2kihHQ1977Uvh2AC
         w9ZW3aTvtHpigb1W10Oup3TViHNy/fwiZMJOofhTZzfvvh4U+XJ6XNBXwfB0SkWSQj7k
         w4Hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=k8iJ7L9yaA7qD0s2nB5tW0Kqk0H2NxzybAr7hwW0qQ8=;
        b=yJ2xtpIslewsoVzhdLkx2s9W/h1r7ltAUpIMYrl98WqQqm0irazg/zZ91+c3S01aZL
         +M6c3GLj/YsDQJVHtZZPFuPPX3o7OP7z5Tb2XuuGDcisf5LLKiQri8i3nAmxptYNmAtC
         11aeQTv9hXx6MnYlWxEmhDMNyTzO41SnC0h4Y+tZqIH0CGFR1f7rD0WPNbImUkCjd0ZF
         3pgvBOyDhGD6Z2dXwBc15l3Ph9El2PbeofvFuNOLy1m7lB1tFhNTRDoph+9ilK/UjsvN
         7zpkubfbxmGa8sgzuNCBbDgvIhbUBkLnujWjznovhBOk9MQQLXDBvlqSkiNx3UgVm4Pl
         3VJw==
X-Gm-Message-State: ACrzQf2I+GoSxHt6z1FoQHndjyDz21E2Z2zTNQf5Qkc7ahYIfvodnS3g
        GY4UBNWGykPlYByTHg8Vgfg=
X-Google-Smtp-Source: AMsMyM5nuZewDVYKx1wSQhUz89PC5Qkx7BMd/9JOZT+MXGvT+rvDEJGDlHCun7Xqgz4b4XQAh7DfLA==
X-Received: by 2002:a05:6402:50ca:b0:451:a711:1389 with SMTP id h10-20020a05640250ca00b00451a7111389mr1330023edb.239.1663274941019;
        Thu, 15 Sep 2022 13:49:01 -0700 (PDT)
Received: from localhost.localdomain (93-42-70-134.ip85.fastwebnet.it. [93.42.70.134])
        by smtp.googlemail.com with ESMTPSA id u2-20020a1709061da200b00764a76d5888sm9504846ejh.27.2022.09.15.13.48.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 15 Sep 2022 13:49:00 -0700 (PDT)
From:   Christian Marangi <ansuelsmth@gmail.com>
To:     Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@somainline.org>,
        Vinod Koul <vkoul@kernel.org>, Mark Brown <broonie@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, linux-arm-msm@vger.kernel.org,
        dmaengine@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Christian Marangi <ansuelsmth@gmail.com>, stable@vger.kernel.org
Subject: [PATCH] dmaengine: qcom-adm: fix wrong sizeof config in slave_config
Date:   Thu, 15 Sep 2022 22:48:44 +0200
Message-Id: <20220915204844.3838-1-ansuelsmth@gmail.com>
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

Fix broken slave_config function that uncorrectly compare the
peripheral_size with the size of the config pointer instead of the size
of the config struct. This cause the crci value to be ignored and cause
a kernel panic on any slave that use adm driver.

To fix this, compare to the size of the struct and NOT the size of the
pointer.

Fixes: 03de6b273805 ("dmaengine: qcom-adm: stop abusing slave_id config")
Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
Cc: stable@vger.kernel.org # v5.17+
---
 drivers/dma/qcom/qcom_adm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/dma/qcom/qcom_adm.c b/drivers/dma/qcom/qcom_adm.c
index facdacf8aede..c77d9de853de 100644
--- a/drivers/dma/qcom/qcom_adm.c
+++ b/drivers/dma/qcom/qcom_adm.c
@@ -494,7 +494,7 @@ static int adm_slave_config(struct dma_chan *chan, struct dma_slave_config *cfg)
 
 	spin_lock_irqsave(&achan->vc.lock, flag);
 	memcpy(&achan->slave, cfg, sizeof(struct dma_slave_config));
-	if (cfg->peripheral_size == sizeof(config))
+	if (cfg->peripheral_size == sizeof(*config))
 		achan->crci = config->crci;
 	spin_unlock_irqrestore(&achan->vc.lock, flag);
 
-- 
2.37.2

